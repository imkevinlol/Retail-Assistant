import UIKit
import RealmSwift

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var productTableView: UITableView!
    
    var datasource : Results<RetailProduct>!
    var searchResult:Array<RetailProduct>?
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
        self.reloadTable()
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        tabBarController?.tabBar.barStyle = UIBarStyle.black
        
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        productTableView.tableHeaderView = resultSearchController.searchBar
        resultSearchController.searchBar.searchBarStyle = .prominent
        resultSearchController.searchBar.sizeToFit()
        productTableView.keyboardDismissMode = .onDrag
    }
    
    func filterContentForSearchText(searchText: String) {
        if self.datasource == nil {
            self.searchResult = nil
            return
        }
        searchResult = datasource.filter { data in
            return (data.brand.lowercased().contains(searchText.lowercased())
                || data.styleName.lowercased().contains(searchText.lowercased())
                || data.store.lowercased().contains(searchText.lowercased()))
        }
        productTableView.reloadData()
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    
    func reloadTable() {
        do {
            let realm = try Realm()
            datasource = realm.objects(RetailProduct.self)
            productTableView?.reloadData()
        } catch {}
        
        datasource = datasource!.sorted(byKeyPath: "dateOfPurchase", ascending: true)
    }
    
    func setupTable() {
        productTableView.delegate = self
        productTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if resultSearchController.isActive {
            if(section == 0) {
                return 54
            }
            return 10
        }
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if resultSearchController.isActive && resultSearchController.searchBar.text != "" {
            return self.searchResult!.count 
        } else {
            return self.datasource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductDisplayTableViewCell
        var currentProduct = RetailProduct()
        
        if resultSearchController.isActive && resultSearchController.searchBar.text != "" {
            currentProduct = (searchResult?[indexPath.section])!
        } else {
            currentProduct = datasource[indexPath.section]

        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        cell.dateOfPurchaseLabel.text = formatter.string(from: currentProduct.dateOfPurchase)
        cell.purchasePriceLabel.text = String(format: "$%.2f", (currentProduct.purchasePrice))
        cell.identifierLabel.text = getTypeId(type: currentProduct.type, id: currentProduct.id)
        
        cell.brandLabel.text = currentProduct.brand
        cell.sizeLabel.text = formatSize(size: currentProduct.size)
        cell.styleLabel.text = currentProduct.styleName
        cell.idLabel.text = String(indexPath.section+1)
        if (currentProduct.imagePath != "") {
            cell.imageVIew.image = getImage(id: currentProduct.id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "entryView") as! EntryTableViewController
        viewController.isAddBtnPressed = false
        if resultSearchController.isActive && resultSearchController.searchBar.text != "" {
            viewController.product = (searchResult?[indexPath.section])!
        } else {
            viewController.product = datasource[indexPath.section]
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            do {
                let realm = try Realm()
                try! realm.write {
                    if resultSearchController.isActive && resultSearchController.searchBar.text != "" {
                        realm.delete((searchResult?[indexPath.section])!)
                    } else {
                        realm.delete(datasource[indexPath.section])
                    }
                }
            } catch{}
            
            productTableView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .fade)
        }
    }
    
    func getImage(id: Int) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("ret-assist-" + String(id) + ".jpg")
            return UIImage(contentsOfFile: imageURL.path)!
        }
        
        return UIImage()
    }
    
    func getTypeId(type: String, id: Int) -> String {
        return type[0] + String(id)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionToEntryVC(_ sender: Any) {
        performSegue(withIdentifier: "toEntryVC", sender: nil)
    }
    
    func formatSize(size: String) -> String {
        return "Size: " + size
    }
    
    @IBAction func addProductBtnPressed(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "entryView") as! EntryTableViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

