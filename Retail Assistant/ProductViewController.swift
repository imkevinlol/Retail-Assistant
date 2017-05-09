import UIKit
import RealmSwift

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var productTableView: UITableView!
    
    var datasource : Results<RetailProduct>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
        self.reloadTable()
    }
    
    func reloadTable() {
        do {
            let realm = try Realm()
            datasource = realm.objects(RetailProduct.self)
            productTableView?.reloadData()
        } catch {}
    }
    
    func setupTable() {
        productTableView.delegate = self
        productTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        var cell = productTableView.dequeueReusableCell(withIdentifier: identifier)
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        
        let currentProduct = datasource[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let botVal = "PD: " +  formatter.string(from: currentProduct.dateOfPurchase) + " | PP: " + String(format: "%.2f", (currentProduct.purchasePrice))
        let topVal = getTypeId(type: currentProduct.type, id: currentProduct.id) + " | " + currentProduct.brand + " | " + currentProduct.size
        cell?.textLabel?.text = topVal
        cell?.detailTextLabel?.text = botVal
        if (currentProduct.imagePath != "") {
            cell?.imageView?.image = getImage(id: currentProduct.id)
        }
        
        return cell!
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "productView") as! ProductDisplayViewController
        viewController.product = datasource[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            do {
                let realm = try Realm()
                try! realm.write {
                    realm.delete(datasource[indexPath.row])
                }
            } catch{}
            productTableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        if(productTableView.isEditing == false) {
            self.navigationItem.leftBarButtonItem?.title = "Save"
            productTableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.leftBarButtonItem?.title = "Edit"
            productTableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
        }
    }
    
    @IBAction func actionToEntryVC(_ sender: Any) {
        performSegue(withIdentifier: "toEntryVC", sender: nil)
    }
}
