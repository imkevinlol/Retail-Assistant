import UIKit

class ReminderDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var displayList = [RetailProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return displayList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductDisplayTableViewCell
        
        let currentProduct = displayList[indexPath.section]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        cell.dateOfPurchaseLabel.text = formatter.string(from: currentProduct.dateOfPurchase)
        cell.purchasePriceLabel.text = String(format: "$%.2f", (currentProduct.purchasePrice))
        cell.identifierLabel.text = getTypeId(type: currentProduct.type, id: currentProduct.id)
        
        cell.brandLabel.text = currentProduct.brand
        cell.sizeLabel.text = "Size: " + currentProduct.size
        cell.styleLabel.text = currentProduct.styleName
        cell.idLabel.text = getDaysBetweenDate(product: currentProduct)
        if (currentProduct.imagePath != "") {
            cell.imageVIew.image = getImage(id: currentProduct.id)
        }
        
        return cell
    }
    
    func getDaysBetweenDate(product: RetailProduct) -> String {
        let calendar = NSCalendar.current

        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: product.dateOfPurchase)
        
        let components = calendar.dateComponents([.day], from: date2, to: date1)
        return String("\(components.day ?? 0)")
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
}
