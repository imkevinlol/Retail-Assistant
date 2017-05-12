import UIKit
import RealmSwift

class StatusTableViewController: UITableViewController {
    
    @IBOutlet weak var profitByMonthCell: UITableViewCell!
    @IBOutlet weak var profitYTDCell: UITableViewCell!
    @IBOutlet weak var spendingByMonthCell: UITableViewCell!
    @IBOutlet weak var spendingYTDCell: UITableViewCell!
    
    var datasource : Results<RetailProduct>!
    
    var storeList = [String](), brandList = [String](), styleList = [String](), topAmountList = [String](), bottomAmountList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatasource()
        setupGesture()
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        tabBarController?.tabBar.barStyle = UIBarStyle.black
    }
    
    func setupGesture() {
        profitByMonthCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cellProfitMonthTapped(_:))))
        
        profitYTDCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cellProfitYTDTapped(_:))))
        
        spendingByMonthCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cellSpendingMonthTapped(_:))))
        
        spendingYTDCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cellSpendingYTDTapped(_:))))
        
    }
    
    @IBAction func cellProfitMonthTapped(_ sender: UITapGestureRecognizer) {
        clearData()
        let reportView = storyboard?.instantiateViewController(withIdentifier: "reportVC") as! ReportViewController
        reportView.bottomHeader = "PROFIT STATEMENT"
        reportView.topHeader = "TOTAL PROFIT"
        reportView.month = "MAY"
        reportView.totalAmount = getTotalProfit(isYTD: false)
        reportView.storeList = storeList
        reportView.brandList = brandList
        reportView.styleList = styleList
        reportView.topAmountList = topAmountList
        reportView.bottomAmountList = bottomAmountList
        reportView.textColor = hexStringToUIColor(hex: "2EB04B")
        navigationController?.pushViewController(reportView, animated: true)
    }
    
    @IBAction func cellProfitYTDTapped(_ sender: UITapGestureRecognizer) {
        print("sender\(sender)")
        clearData()
        let reportView = storyboard?.instantiateViewController(withIdentifier: "reportVC") as! ReportViewController
        reportView.bottomHeader = "PROFIT STATEMENT YEAR-TO-DATE"
        reportView.topHeader = "TOTAL PROFIT YEAR-TO-DATE"
        reportView.month = "2017"
        reportView.totalAmount = getTotalProfit(isYTD: true)
        reportView.storeList = storeList
        reportView.brandList = brandList
        reportView.styleList = styleList
        reportView.topAmountList = topAmountList
        reportView.bottomAmountList = bottomAmountList
        reportView.textColor = hexStringToUIColor(hex: "2EB04B")
        navigationController?.pushViewController(reportView, animated: true)
    }
    
    @IBAction func cellSpendingMonthTapped(_ sender: UITapGestureRecognizer) {
        print("sender\(sender)")
        clearData()
        let reportView = storyboard?.instantiateViewController(withIdentifier: "reportVC") as! ReportViewController
        reportView.bottomHeader = "SPENDING STATEMENT"
        reportView.topHeader = "TOTAL SPENDING"
        reportView.month = "MAY"
        reportView.totalAmount = getTotalSpending(isYTD: false)
        reportView.storeList = storeList
        reportView.brandList = brandList
        reportView.styleList = styleList
        reportView.topAmountList = topAmountList
        reportView.bottomAmountList = bottomAmountList
        reportView.textColor = UIColor.red
        navigationController?.pushViewController(reportView, animated: true)
    }
    
    @IBAction func cellSpendingYTDTapped(_ sender: UITapGestureRecognizer) {
        print("sender\(sender)")
        clearData()
        let reportView = storyboard?.instantiateViewController(withIdentifier: "reportVC") as! ReportViewController
        reportView.bottomHeader = "SPENDING YEAR-TO-DATE STATEMENT"
        reportView.topHeader = "TOTAL SPENDING YEAR-TO-DATE"
        reportView.month = "2017"
        reportView.totalAmount = getTotalSpending(isYTD: true)
        reportView.storeList = storeList
        reportView.brandList = brandList
        reportView.styleList = styleList
        reportView.topAmountList = topAmountList
        reportView.bottomAmountList = bottomAmountList
        reportView.textColor = UIColor.red
        navigationController?.pushViewController(reportView, animated: true)
    }
    
    func clearData() {
        storeList = [String]()
        brandList = [String]()
        styleList = [String]()
        topAmountList = [String]()
        bottomAmountList = [String]()
    }

    
    func getTotalProfit(isYTD: Bool) -> String {
        var totalProfit: Double = 0.0
        for data in datasource {
            if(data.salePrice > 0 && ((isYTD && isCurrentYear(result: data)) || (!isYTD && isCurrentMonth(result: data)))) {
                let profit = data.salePrice - data.purchasePrice
                totalProfit += profit
                storeList.append(data.store)
                brandList.append(data.brand)
                styleList.append(data.styleName)
                topAmountList.append(currencyFormat(amount: profit))
                bottomAmountList.append(currencyFormat(amount: data.salePrice))
            }
        }
        
        return currencyFormat(amount: totalProfit)
    }
    
    func getTotalSpending(isYTD: Bool) -> String {
        var totalSpending: Double = 0.0
        for data in datasource {
            if((isYTD && isCurrentYear(result: data)) || (!isYTD && isCurrentMonth(result: data))) {
                totalSpending += data.purchasePrice
                storeList.append(data.store)
                brandList.append(data.brand)
                styleList.append(data.styleName)
                topAmountList.append(currencyFormat(amount: data.purchasePrice))
                bottomAmountList.append(currencyFormat(amount: data.salePrice))
            }
        }
        
        return currencyFormat(amount: totalSpending)
    }
    
    func isCurrentMonth(result: RetailProduct) -> Bool {
        let components = NSCalendar.current.dateComponents([.month], from: Date())
        let ourComponents = NSCalendar.current.dateComponents([.month], from: result.dateOfPurchase)
        return (components.month == ourComponents.month)
    }
    
    func isCurrentYear(result: RetailProduct) -> Bool {
        let components = NSCalendar.current.dateComponents([.year], from: Date())
        let ourComponents = NSCalendar.current.dateComponents([.year], from: result.dateOfPurchase)
        return (components.month == ourComponents.month)
    }
    
    
    func currencyFormat(amount: Double) -> String {
        if (amount >= 0.0) {
            return String(format: "$%.2f", (amount))
        } else {
            return String(format: "-$%.2f", (amount * -1))

        }
    }
    
    func setupDatasource() {
        do {
            let realm = try Realm()
            datasource = realm.objects(RetailProduct.self)
        } catch {}
    }
}
