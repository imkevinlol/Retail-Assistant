import UIKit
import RealmSwift

class EntryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var receiptImage: UIImageView!
    
    var picker = UIPickerView()
    var datePicker = UIDatePicker()
    var activeTextField = UITextField()
    var currentArray = [String]()
    
    var typeList = ["Clothing", "Bag", "Shoes", "Accessory", "Other"]
    var qualityList = ["Trash", "Poor", "Average", "Good", "Excellent", "Unknown"]
    var brandList = ["Stuart Weitzman", "Jimmy Choo", "Tory Burch", "Charlotte Olympia", "Manono Blahnik", "Valentino", "Other"]
    var storeList = ["Nordstrom Rack", "Neiman Marcus", "Saks", "Other"]
    var isImage : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDelegates()
        initializeViews()
        loadImageFunctions()
        createDatePicker()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        isImage = true
    }
    
    func receiptTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        isImage = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            if (isImage)! {
                itemImage.image = image
            } else {
                receiptImage.image = image
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "We had an issue in the image conversion process...", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.dismiss(animated: true, completion: nil)
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
            
            if (itemImage.image != nil) {
                let data = UIImageJPEGRepresentation(itemImage.image!, 1.0) as NSData?
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                let writePath = documentsPath.appendingPathComponent("ret-assist-" + String(newProduct.id) + ".jpg")
                data?.write(toFile: writePath, atomically: true)
                let itemImageUrl = writePath as NSString
                newProduct.imagePath = itemImageUrl
            }
            
            if (receiptImage.image != nil) {
                let data = UIImageJPEGRepresentation(receiptImage.image!, 1.0) as NSData?
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                let writePath = documentsPath.appendingPathComponent("ret-assist-" + String(newProduct.id) + "-receipt.jpg")
                data?.write(toFile: writePath, atomically: true)
                let receiptImageUrl = writePath as NSString
                newProduct.receiptPath = receiptImageUrl
            }
            
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
    
    func loadImageFunctions() {
        itemImage.image = UIImage(named: "shopping-bag")
        receiptImage.image = UIImage(named: "receipt")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        itemImage.isUserInteractionEnabled = true
        itemImage.addGestureRecognizer(tapGestureRecognizer)

        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(receiptTapped(tapGestureRecognizer:)))
        receiptImage.isUserInteractionEnabled = true
        receiptImage.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    func initializeViews() {
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
        originalPriceTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        purchasePriceTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    func loadDelegates() {
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
    }
}
