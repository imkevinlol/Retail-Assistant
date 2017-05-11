import UIKit

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var statementLabel: UILabel!
    @IBOutlet weak var statementTableView: UITableView!
    @IBOutlet weak var totalButton: ButtonDesignable!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var storeList = [String](), brandList = [String](), styleList = [String](), topAmountList = [String](), bottomAmountList = [String]()
    var topHeader = "", bottomHeader = "", totalAmount = "", month = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.statementTableView.contentInset = UIEdgeInsetsMake(-35, 0, 20, 0)
    }
    
    func initialize() {
        totalLabel.text = topHeader
        statementLabel.text = bottomHeader
        totalButton.setTitle(totalAmount, for: .normal)
        totalButton.isUserInteractionEnabled = false
        self.title = month
        statementTableView.delegate = self
        statementTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "protoCell",
            for: indexPath) as! StatementTableViewCell
        if (indexPath.row < brandList.count) {
            cell.brandLabel.text = brandList[indexPath.row]
            cell.storeLabel.text = storeList[indexPath.row]
            cell.styleNameLabel.text = styleList[indexPath.row]
            cell.topLabel.text = topAmountList[indexPath.row]
            cell.bottomLabel.text = bottomAmountList[indexPath.row]
        }
        
        return cell
    }
}
