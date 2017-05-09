import UIKit
import RealmSwift

class EntryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var originalPriceTF: UITextField!
    @IBOutlet weak var purchasePriceTF: UITextField!
    @IBOutlet weak var qualityTF: UITextField!
    @IBOutlet weak var dateOfPurchaseTF: UITextField!
    @IBOutlet weak var brandTF: UITextField!
    @IBOutlet weak var dustBagSW: UISwitch!
    @IBOutlet weak var originalBoxSW: UISwitch!
    @IBOutlet weak var salePriceLB: UILabel!
    @IBOutlet weak var profitLB: UILabel!
    @IBOutlet weak var storeTF: UITextField!
    @IBOutlet weak var sizeTF: UITextField!
    @IBOutlet weak var styleNameTF: UITextField!
    
    var picker = UIPickerView()
    var datePicker = UIDatePicker()
    var activeTextField = UITextField()
    var currentArray = [String]()
        
    var typeList = ["Clothing", "Bag", "Shoes", "Accessory", "Other"]
    var qualityList = ["Trash", "Poor", "Average", "Good", "Excellent"]
    var brandList = ["Stuart Weitzman", "Jimmy Choo", "Tory Burch", "Charlotte Olympia", "Manono Blahnik", "Valentino"]
    var storeList = ["Nordstrom Rack", "Neiman Marcus", "Saks", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        typeTF.inputView = picker
        typeTF.delegate = self
        qualityTF.inputView = picker
        qualityTF.delegate = self
        brandTF.inputView = picker
        storeTF.delegate = self
        storeTF.inputView = picker
        brandTF.delegate = self
        typeTF.text = "Shoes"
        profitLB.text = "0.00"
        salePriceLB.text = "0.00"
        originalPriceTF.text = "0.00"
        purchasePriceTF.text = "0.00"
        brandTF.text = "Stuart Weitzman"
        dustBagSW.isOn = false
        originalBoxSW.isOn = false
        qualityTF.text = "Excellent"
        storeTF.text = "Nordstrom Rack"
        sizeTF.text = "1"
        dateOfPurchaseTF.text = getTodayDate()
        createDatePicker()
        originalPriceTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        purchasePriceTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        let originalPrice = Double(originalPriceTF.text!)
        let purchasePrice = Double(purchasePriceTF.text!)

        if (originalPrice != nil) {
            let salePrice = originalPrice! * 0.5
            salePriceLB.text = String(format:"%.2f", salePrice)
            if (purchasePrice != nil) {
                let profit = (salePrice - purchasePrice!) * 0.8
                profitLB.text = String(format: "%.2f", profit)
            } else {
                profitLB.text = "0.00"
            }
        } else {
            salePriceLB.text = "0.00"
        }
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnPressed))
        toolbar.setItems([doneBtn], animated: false)
        dateOfPurchaseTF.inputAccessoryView = toolbar
        dateOfPurchaseTF.inputView = datePicker
    }
    
    func doneBtnPressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateOfPurchaseTF.text = dateFormatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getTodayDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
         return formatter.string(from: date)
    }
    
    func getDateFromString(dateStr: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.date(from: dateStr)!
    }

    @IBAction func actionSaveItem(_ sender: Any) {
        saveItem()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveItem() {
        let newProduct = RetailProduct()
        newProduct.type = typeTF.text!
        newProduct.quality = qualityTF.text!
        newProduct.brand = brandTF.text!
        newProduct.dustBag = dustBagSW.isOn
        newProduct.originalBox = originalBoxSW.isOn
        newProduct.originalPrice = Double(originalPriceTF.text!)!
        newProduct.purchasePrice = Double(purchasePriceTF.text!)!
        newProduct.estSalePrice = Double(salePriceLB.text!)!
        newProduct.estProfit = Double(profitLB.text!)!
        newProduct.store = storeTF.text!
        newProduct.size = sizeTF.text!
        newProduct.styleName = styleNameTF.text!
        
        do {
            let realm = try Realm()
            newProduct.id = ((realm.objects(RetailProduct.self).map{$0.id}.max() ?? 0) + 1)
            try realm.write({ () -> Void in
                realm.add(newProduct)
                print("Contact Saved")
            })
        } catch {}
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        if (activeTextField == qualityTF) {
            self.currentArray = qualityList
        } else if (activeTextField == typeTF) {
            self.currentArray = typeList
        } else if (activeTextField == brandTF) {
            self.currentArray = brandList
        } else if (activeTextField == storeTF) {
            self.currentArray = storeList
        }
        
        picker.reloadAllComponents()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeTextField.text = currentArray[row]
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentArray[row]
    }
    
    
}
