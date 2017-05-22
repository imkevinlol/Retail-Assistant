import UIKit
import RealmSwift

class ReminderTableViewController: UITableViewController {

    @IBOutlet weak var oneWeekCell: UITableViewCell!
    @IBOutlet weak var twoWeekCell: UITableViewCell!
    
    var datasource : Results<RetailProduct>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatasource()
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        tabBarController?.tabBar.barStyle = UIBarStyle.black
        setupGesture()
    }
    
    func setupGesture() {
        oneWeekCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cellOneWeekPressed(_:))))
        
        twoWeekCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cellTwoWeekPressed(_:))))
        
    }
    
    @IBAction func cellOneWeekPressed(_ sender: UITapGestureRecognizer) {
        let reportView = storyboard?.instantiateViewController(withIdentifier: "reminderDisplay") as! ReminderDisplayViewController
        reportView.displayList = getReturnListWithin(weekWithin: 1)
        navigationController?.pushViewController(reportView, animated: true)
    }
    
    @IBAction func cellTwoWeekPressed(_ sender: UITapGestureRecognizer) {
        let reportView = storyboard?.instantiateViewController(withIdentifier: "reminderDisplay") as! ReminderDisplayViewController
        reportView.displayList = getReturnListWithin(weekWithin: 2)
        navigationController?.pushViewController(reportView, animated: true)
    }
    
    func getReturnListWithin(weekWithin: Int) -> Array<RetailProduct> {
        var list = [RetailProduct]()
        for data in datasource {
            if (isWithinXWeek(data: data, weekWithin: weekWithin) && data.salePrice == 0.00) {
                list.append(data)
            }
        }
        
        return list
    }
    
    func isWithinXWeek(data: RetailProduct, weekWithin: Int) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"

        let days = getDaysFromStore(product: data)
        
        if (days < 0) {
            return false
        }
        let returnDateStr = formatter.string(from: Calendar.current.date(byAdding: .day, value: days, to: data.dateOfPurchase)!)
        
        let returnDate = formatter.date(from: returnDateStr)
        
        let returnDateStrMinusWeek = formatter.string(from: Calendar.current.date(byAdding: .day, value: (weekWithin * -7), to: returnDate!)!)
        let returnDateMinusWeek = formatter.date(from: returnDateStrMinusWeek)

        return (Date() <= returnDate! && Date() > returnDateMinusWeek!)
    }
    
    func getDaysFromStore(product: RetailProduct) -> Int {
        if (product.store == "Bloomingdale's" || product.store == "Tradesy" || product.store == "Poshmark" || product.store == "The Real Real") {
            return -1
        }
        else if (product.store == "Nordstrom Rack") {
            return 90
        } else if (product.store == "Neiman Marcus") {
            return 60
        } else {
            return 30
        }
    }
    
    func setupDatasource() {
        do {
            let realm = try Realm()
            datasource = realm.objects(RetailProduct.self)
        } catch {}
    }
}
