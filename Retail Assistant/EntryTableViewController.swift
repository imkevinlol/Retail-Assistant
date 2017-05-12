import UIKit

class EntryTableViewController: UITableViewController {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var receiptImage: UIImageView!
    @IBOutlet weak var storeField: UILabel!
    @IBOutlet weak var purchaseDateField: UILabel!
    @IBOutlet weak var categoryField: UILabel!
    @IBOutlet weak var brandField: UILabel!
    @IBOutlet weak var styleField: UILabel!
    @IBOutlet weak var sizeField: UILabel!
    @IBOutlet weak var qualityField: UILabel!
    @IBOutlet weak var originalPriceField: UITextField!
    @IBOutlet weak var purchasePriceField: UITextField!
    @IBOutlet weak var salePriceField: UITextField!
    @IBOutlet weak var profitField: UITextField!
    @IBOutlet weak var estSalePriceField: UITextField!
    @IBOutlet weak var estProfitLabel: UITextField!
    @IBOutlet weak var dustBagField: UILabel!
    @IBOutlet weak var originalBoxField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
