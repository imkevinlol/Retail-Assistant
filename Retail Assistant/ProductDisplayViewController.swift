import UIKit

class ProductDisplayViewController: UIViewController {
    
    @IBOutlet weak var salePriceLB: UILabel!
    @IBOutlet weak var profitLB: UILabel!
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var originalPriceTF: UITextField!
    @IBOutlet weak var purchasePriceTF: UITextField!
    @IBOutlet weak var qualityTF: UITextField!
    @IBOutlet weak var dateOfPurchaseTF: UITextField!
    @IBOutlet weak var brandTF: UITextField!
    @IBOutlet weak var dustBagSW: UISwitch!
    @IBOutlet weak var originalBoxSW: UISwitch!
    @IBOutlet weak var availableSW: UISwitch!
    
    var product : RetailProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProductView()
        makeAllViewUneditable()
    }
    
    func loadProductView() {
        salePriceLB.text = String(format: "%.2f", (product?.estSalePrice)!)
        profitLB.text = String(format: "%.2f", (product?.estProfit)!)
        typeTF.text = product?.type
        originalPriceTF.text = String(format: "%.2f", (product?.originalPrice)!)
        purchasePriceTF.text = String(format: "%.2f", (product?.purchasePrice)!)
        qualityTF.text = product?.quality
        brandTF.text = product?.brand
        dustBagSW.isOn = (product?.dustBag)!
        originalBoxSW.isOn = (product?.originalBox)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateOfPurchaseTF.text = dateFormatter.string(from: (product?.dateOfPurchase)!)
    }
    
    func makeAllViewUneditable() {
        salePriceLB.isUserInteractionEnabled = false
        profitLB.isUserInteractionEnabled = false
        typeTF.isEnabled = false
        originalPriceTF.isEnabled = false
        purchasePriceTF.isEnabled = false
        qualityTF.isEnabled = false
        dateOfPurchaseTF.isEnabled = false
        brandTF.isEnabled = false
        dustBagSW.isEnabled = false
        originalBoxSW.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
