import UIKit
import RealmSwift

class EntryTableViewController: UITableViewController, CategoryModalDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ModalDelegate, UITextFieldDelegate {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var receiptImage: UIImageView!
    @IBOutlet weak var storeField: UILabel!
    @IBOutlet weak var purchaseDateField: UITextField!
    @IBOutlet weak var categoryField: UILabel!
    @IBOutlet weak var brandField: UILabel!
    @IBOutlet weak var styleField: UITextField!
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
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var receiptBtn: UIButton!
    
    var categoryList = ["Clothing", "Bag", "Shoes", "Accessory", "Other"]
    var qualityList = ["Terrible", "Poor", "Average", "Good", "Excellent", "Unknown"]
    var shoeSizeList = ["5", "5.5", "6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "10.5", "11", "11.5", "12", "12.5", "13"]
    var bagSizeList = ["Micro", "Mini", "Small", "Medium", "Large", "Extra Large"]
    var clothingSizeList = ["00", "0", "2", "4", "6", "8", "10", "12", "XXS", "XS", "S", "M", "L", "XL", "XXL"]
    var brandList = ["Stuart Weitzman", "Jimmy Choo", "Tory Burch", "Charlotte Olympia", "Manono Blahnik", "Valentino", "Chanel", "Christian Dior", "Miu Miu", "Bottega Veneta", "Prada", "Christian Louboutin", "Salvatore Ferragamo", "Kate Spade", "Vince", "Chloe", "Celine", "Fendi", "Gucci", "Saint Laurent", "Rebecca Taylor", "Alexander McQueen", "Alexander Wang", "Burberry", "Coach"]
    var storeList = ["Nordstrom Rack", "Neiman Marcus", "Saks", "T.J. Maxx", "Poshmark", "Tradesy", "Marshalls", "Bloomingdale's"]
    var boolList = ["Yes", "No"]
    var isImage: Bool = false
    var currentImageView : UIImageView?
    var datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var isAddBtnPressed: Bool = true
    var product: RetailProduct = RetailProduct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brandList.sort()
        brandList.append("Other")
        storeList.sort()
        storeList.append("Other")
        createDatePicker()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        originalPriceField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        purchasePriceField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        salePriceField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setupFieldsForEdit()
    }
    
    func setupFieldsForEdit() {
        if (!isAddBtnPressed) {
            storeField.text = product.store
            purchaseDateField.text = dateFormatter.string(from: product.dateOfPurchase)
            categoryField.text = product.type
            brandField.text = product.brand
            styleField.text = product.styleName
            sizeField.text = product.size
            qualityField.text = product.quality
            originalPriceField.text = String(format:"%.2f", product.originalPrice)
            purchasePriceField.text = String(format:"%.2f", product.purchasePrice)
            salePriceField.text = String(format:"%.2f", product.salePrice)
            profitField.text = String(format:"%.2f", product.profit)
            estSalePriceField.text = String(format:"%.2f", product.estSalePrice)
            estProfitLabel.text = String(format:"%.2f", product.estProfit)
            dustBagField.text = getBoolStr(val: product.dustBag)
            originalBoxField.text = getBoolStr(val: product.originalBox)
            imageBtn.setTitle("", for: .normal)
            receiptBtn.setTitle("", for: .normal)
            itemImage.image = getImage(id: product.id, isImage: true)
            receiptImage.image = getImage(id: product.id, isImage: false)
        }
    }
    
    func getBoolStr(val: Bool) -> String {
        if (val == false) {
            return "No"
        } else {
            return "Yes"
        }
    }
    
    func getImage(id: Int, isImage: Bool) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL : URL?
            if (isImage) {
                imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("ret-assist-" + String(id) + ".jpg")
            } else {
                imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("ret-assist-" + String(id) + "-receipt.jpg")
            }
            return UIImage(contentsOfFile: imageURL!.path)!
        }
        
        return UIImage()
    }
    
    func setValueInField(section: Int, row: Int, value: String) {
        if(section == 1) {
            switch row {
            case 0:
                storeField.text = value
                break
            case 2:
                categoryField.text = value
                if(categoryField.text == "Accessory") {
                    sizeField.text = "One Size"
                } else {
                    sizeField.text = ""
                }
                break
            case 3:
                brandField.text = value
                break
            case 5:
                sizeField.text = value
                break
            case 6:
                qualityField.text = value
                break
            default:
                print("Row not meant to be selected")
                break
            }
        } else if (section == 3) {
            if (row == 0) {
                dustBagField.text = value
            } else {
                originalBoxField.text = value
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section != 2 && indexPath.section != 0 && getDisplayList(row: indexPath.row, section: indexPath.section).count > 0) {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "categorySelectionView") as! CategorySelectionViewController
            viewController.displayList = getDisplayList(row: indexPath.row, section: indexPath.section)
            viewController.delegate = self
            viewController.deledateIndexPath = indexPath
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func getDisplayList(row: Int, section: Int) -> Array<String> {
        switch row {
        case 0:
            if (section == 1) {
                return storeList
            }
            return boolList
        case 1:
            if (section != 1) {
                return boolList
            }
            return Array<String>()
        case 2:
            return categoryList
        case 3:
            return brandList
        case 5:
            if(categoryField.text == "Shoes") {
            return shoeSizeList
            } else if (categoryField.text == "Clothing") {
                return clothingSizeList
            } else if (categoryField.text == "Bag") {
                return bagSizeList
            }else {
                return Array<String>()
            }
        case 6:
            return qualityList
        default:
            return Array<String>()
        }
    }
    
    func showFullscreen() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "displayImage") as! ImageDisplayViewController
        viewController.theImage = (currentImageView?.image)!
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    func setImage(img: UIImageView) {
        currentImageView = img
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            isImage = true
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showPicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            isImage = false
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if(checkCanSave()) {
            if(isAddBtnPressed) {
                saveItem()
            } else {
                saveItemFromEdit()
            }
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please fill in all fields before saving.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkCanSave() -> Bool {
        print(categoryField.text != "")
        print(originalPriceField.text != "")
        if(categoryField.text != "" && qualityField.text != "" && brandField.text != "" && originalPriceField.text != "" && purchasePriceField.text != "" && estSalePriceField.text != "" && estProfitLabel.text != "" && storeField.text != "" && sizeField.text != "" && styleField.text != "" && purchaseDateField.text != "") {
            return true
        }
        return false
    }
    
    func saveItem() {
        do {
            let realm = try Realm()
            product.id = ((realm.objects(RetailProduct.self).map{$0.id}.max() ?? 0) + 1)
            setProduct()

            try realm.write({ () -> Void in
                realm.add(product)
                print("Product \(product.id) Saved")
            })
        } catch {}
    }
    
    func setProduct() {
        if (salePriceField.text == "" || salePriceField.text == nil) {
            salePriceField.text = "0.00"
            profitField.text = "0.00"
        }
        product.type = categoryField.text!
        product.quality = qualityField.text!
        product.brand = brandField.text!
        product.dustBag = (dustBagField.text == "Yes")
        product.originalBox = (originalBoxField.text == "Yes")
        product.originalPrice = Double(originalPriceField.text!)!
        product.purchasePrice = Double(purchasePriceField.text!)!
        product.estSalePrice = Double(estSalePriceField.text!)!
        product.estProfit = Double(estProfitLabel.text!)!
        product.profit = Double(profitField.text!)!
        product.salePrice = Double(salePriceField.text!)!
        product.store = storeField.text!
        product.size = sizeField.text!
        product.styleName = styleField.text!
        product.dateOfPurchase = dateFormatter.date(from: purchaseDateField.text!)!
        
        if (itemImage.image != nil) {
            let data = UIImageJPEGRepresentation(itemImage.image!, 1.0) as NSData?
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let writePath = documentsPath.appendingPathComponent("ret-assist-" + String(product.id) + ".jpg")
            data?.write(toFile: writePath, atomically: true)
            let itemImageUrl = writePath as NSString
            product.imagePath = itemImageUrl
        }
        
        if (receiptImage.image != nil) {
            let data = UIImageJPEGRepresentation(receiptImage.image!, 1.0) as NSData?
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let writePath = documentsPath.appendingPathComponent("ret-assist-" + String(product.id) + "-receipt.jpg")
            data?.write(toFile: writePath, atomically: true)
            let receiptImageUrl = writePath as NSString
            product.receiptPath = receiptImageUrl
        }
    }
    
    func saveItemFromEdit() {
        do {
            let realm = try Realm()
            
            try realm.write({ () -> Void in
                setProduct()
                print("Product \(product.id) Edit Saved")
            })
        } catch {}
    }
    
    @IBAction func showModalR(_ sender: Any) {
        let modalVC = self.storyboard?.instantiateViewController(withIdentifier: "modalView") as! PhotoModalViewController
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.delegate = self
        modalVC.imageView = receiptImage
        self.tabBarController?.present(modalVC, animated:true, completion: nil)
    }
    
    @IBAction func showModal(_ sender: Any) {
        let modalVC = self.storyboard?.instantiateViewController(withIdentifier: "modalView") as! PhotoModalViewController
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.delegate = self
        modalVC.imageView = itemImage
        self.tabBarController?.present(modalVC, animated:true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            if (currentImageView?.isEqual(itemImage))! {
                itemImage.image = image
                imageBtn.setTitle("", for: .normal)
            } else {
                receiptImage.image = image
                receiptBtn.setTitle("", for: .normal)
            }
            let compressedImage = UIImage(data: UIImageJPEGRepresentation(image, 1.0)!)
            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Alert", message: "We had an issue in the image conversion process...", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            picker.present(alert, animated: true, completion: nil)
        }
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnPressed))
        toolbar.setItems([doneBtn], animated: false)
        purchaseDateField.inputAccessoryView = toolbar
        purchaseDateField.inputView = datePicker
    }
    
    func doneBtnPressed() {
        purchaseDateField.text = dateFormatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        let originalPrice = Double(originalPriceField.text!)
        let purchasePrice = Double(purchasePriceField.text!)
        let salePrice = Double(salePriceField.text!)
        
        if (originalPrice != nil) {
            let estSalePrice = originalPrice! * 0.5
            estSalePriceField.text = String(format:"%.2f", estSalePrice)
            if (purchasePrice != nil) {
                let estProfit = (estSalePrice - purchasePrice!) * 0.8
                estProfitLabel.text = String(format: "%.2f", estProfit)
            } else {
                estProfitLabel.text = ""
            }
        } else {
            estSalePriceField.text = ""
        }
        if(salePrice != nil && purchasePrice != nil) {
            profitField.text = String(format: "%.2f", salePrice! - purchasePrice!)
        } else {
            profitField.text = ""
        }
    }
}
