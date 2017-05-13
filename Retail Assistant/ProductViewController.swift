import UIKit
import RealmSwift

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var productTableView: UITableView!
    
    var datasource : Results<RetailProduct>!
    var searchResult:Array<RetailProduct>?
    
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
    }
    
    func reloadTable() {
        do {
            let realm = try Realm()
            datasource = realm.objects(RetailProduct.self)
            productTableView?.reloadData()
        } catch {}
        
        datasource = datasource!.sorted(byKeyPath: "dateOfPurchase", ascending: false)
    }
    
    func setupTable() {
        productTableView.delegate = self
        productTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductDisplayTableViewCell
        
        let currentProduct = datasource[indexPath.section]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        cell.dateOfPurchaseLabel.text = formatter.string(from: currentProduct.dateOfPurchase)
        cell.purchasePriceLabel.text = String(format: "$%.2f", (currentProduct.purchasePrice))
        cell.identifierLabel.text = getTypeId(type: currentProduct.type, id: currentProduct.id)
        
        cell.brandLabel.text = currentProduct.brand
        cell.sizeLabel.text = formatSize(size: currentProduct.size)
        cell.styleLabel.text = currentProduct.styleName
        if (currentProduct.imagePath != "") {
            cell.imageVIew.image = getImage(id: currentProduct.id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "productView") as! ProductDisplayViewController
        viewController.product = datasource[indexPath.section]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            do {
                let realm = try Realm()
                try! realm.write {
                    realm.delete(datasource[indexPath.section])
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
    
    func filterContentForSearchText(searchText: String) {
        if self.datasource == nil {
            self.searchResult = nil
            return
        }
        self.searchResult = self.datasource!.filter({( aProduct: RetailProduct) -> Bool in
            return aProduct.store.lowercased().range(of: searchText.lowercased()) != nil
        })
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        self.filterContentForSearchText(searchText: searchString!)
        return true
    }
}
