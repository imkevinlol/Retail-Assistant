import UIKit
import RealmSwift

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statusTableView: UITableView!
    
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
            statusTableView?.reloadData()
        } catch {}
    }
    
    func setupTable() {
        statusTableView.delegate = self
        statusTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        var cell = statusTableView.dequeueReusableCell(withIdentifier: identifier)
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let viewController = storyboard?.instantiateViewController(withIdentifier: "productView") as! ProductDisplayViewController
//        viewController.product = datasource[indexPath.row]
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getCellDetailText(count: Int) -> String {
        switch count {
        case 0:
            return "Profit by Month"
        case 1:
            return "Profit YTD"
        case 2:
            return "Spending by Month"
        case 3:
            return "Spending YTD"
        default:
            print("I effed up somewhere")
            return ""
        }
    }
    
//    func getCellText(count: Int) -> String {
//        switch count {
//        case 0:
//            return getProfitByMonth()
//        case 1:
//            return getProfitYTD()
//        case 2:
//            return getSpendingByMonth()
//        case 3:
//            return getSpendingYTD()
//        default:
//            print("I effed up somewhere")
//            return ""
//        }
//    }
//    
//    func getProfitByMonth() -> String {
////        var 
//        for source in datasource {
//            
//        }
//        
//    }
//    
//    func getProfitYTD() -> String {
//        
//    }
//    
//    func getSpendingByMonth() -> String {
//        
//    }
//    
//    func getSpendingYTD() -> String {
//        
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
