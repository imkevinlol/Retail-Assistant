import UIKit
import RealmSwift

class ProductEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var originalLB: UILabel!
    @IBOutlet weak var editTF: UITextField!
    var product : RetailProduct?
    var productId : Int = 0
    var propertyEdited : String?
    var index : Int?
    
    var picker = UIPickerView()
    var datePicker = UIDatePicker()
    var currentArray = [String]()
    
    var typeList = ["Clothing", "Bag", "Shoes", "Accessory", "Other"]
    var qualityList = ["Trash", "Poor", "Average", "Good", "Excellent", "Unknown"]
    var brandList = ["Stuart Weitzman", "Jimmy Choo", "Tory Burch", "Charlotte Olympia", "Manono Blahnik", "Valentino", "Other"]
    var storeList = ["Nordstrom Rack", "Neiman Marcus", "Saks", "Other"]
    var boolList = ["Yes", "No"]

    
    override func viewDidLoad() {
        print(productId)
        super.viewDidLoad()
        do {
            let realm = try Realm()
            
            try realm.write {
                let val = "id = \(productId)"
                print(val)
                product = realm.objects(RetailProduct.self).filter(val).first
            }
        } catch {}
        let originalText = getCellDetailText(count: index!)
        originalLB.text = originalText
        editTF.text = originalText
        editTF.font = editTF.font?.withSize(20)
        editTF.textAlignment = .center
        picker.delegate = self
        picker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editTF.text = currentArray[row]
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentArray[row]
    }
    
    func setup() {
        editTF.inputView = picker
        editTF.delegate = self
    }
    
    func getCellDetailText(count: Int) -> String {
        switch count {
        case 0:
            setup()
            currentArray = typeList
            return (product?.type)!
        case 1:
            return String(format: "%.2f", (product?.originalPrice)!)
        case 2:
            return String(format: "%.2f", (product?.purchasePrice)!)
        case 3:
            return String(format: "%.2f", (product?.estSalePrice)!)
        case 4:
            return String(format: "%.2f", (product?.estProfit)!)
        case 5:
            setup()
            currentArray = qualityList
            return (product?.quality)!
        case 6:
            setup()
            currentArray = brandList
            return (product?.brand)!
        case 7:
            setup()
            currentArray = boolList
            if (product?.dustBag)! {
                return "Yes"
            } else {
                return "No"
            }
        case 8:
            setup()
            currentArray = boolList
            if (product?.originalBox)! {
                return "Yes"
            } else {
                return "No"
            }
        case 9:
            createDatePicker()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: (product!.dateOfPurchase))
        case 10:
            return (product?.styleName)!
        case 11:
            return (product?.size)!
        case 12:
            setup()
            currentArray = storeList
            return (product?.store)!
        default:
            print("I effed up somewhere")
            return ""
        }
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePicker.date = (product?.dateOfPurchase)!
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnPressed))
        toolbar.setItems([doneBtn], animated: false)
        editTF.inputAccessoryView = toolbar
        editTF.inputView = datePicker
    }
    
    func doneBtnPressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        editTF.text = dateFormatter.string(from: datePicker.date)
        product?.dateOfPurchase = datePicker.date
        
        self.view.endEditing(true)
    }
    
    @IBAction func saveEditBtn(_ sender: Any) {
        saveItem()
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: ProductDisplayViewController.self) {
                _ = self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    func saveItem() {
        let realm = try! Realm()
        do {
            try realm.write() {
                saveProduct()
            }
        } catch {}
    }
    
    func saveProduct() {
        switch index! {
        case 0:
            product?.type = editTF.text!
            break
        case 1:
            product?.originalPrice = Double(editTF.text!)!
            break
        case 2:
            product?.purchasePrice = Double(editTF.text!)!
            break
        case 3:
            product?.estSalePrice = Double(editTF.text!)!
            break
        case 4:
            product?.estProfit = Double(editTF.text!)!
            break
        case 5:
            product?.quality = editTF.text!
            break
        case 6:
            product?.brand = editTF.text!
            break
        case 7:
            if (editTF.text == "Yes") {
                product?.dustBag = true
            }
            else {
                product?.dustBag = false
            }
            break
        case 8:
            if (editTF.text == "Yes") {
                product?.originalBox = true
            }
            else {
                product?.originalBox = false
            }
            break
        case 9:
            product?.dateOfPurchase = datePicker.date
            break
        case 10:
            product?.styleName = editTF.text!
            break
        case 11:
            product?.size = editTF.text!
            break
        case 12:
            product?.store = editTF.text!
            break
        default:
            print("I effed up saving somewhere")
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
