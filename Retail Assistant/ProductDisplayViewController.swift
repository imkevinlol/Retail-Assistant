import UIKit
import RealmSwift

class AlertHelper {
    func showAlert(fromController controller: UIViewController, baseController base: UIViewController, image img: UIImage) {
        let alert = UIAlertController(title: "Isabella", message: "Would you like to save this picture ma?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            let imageData = UIImageJPEGRepresentation(img, 1.0)
            let compressedImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            base.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            base.dismiss(animated: true, completion: nil)
        }))
        
        controller.present(alert, animated: true, completion: nil)
    }
}

class ProductDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ModalDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var displayTableView: UITableView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var receiptImage: UIImageView!
    var product : RetailProduct = RetailProduct()
    var currentImageView : UIImageView?
    var isCameraImage : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProductView()
        setupTable()
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height, 0)
        displayTableView.contentInset = adjustForTabbarInsets
        displayTableView.scrollIndicatorInsets = adjustForTabbarInsets
    }
    
    func showFullscreen() {
        let imageView = currentImageView
        let newImageView = UIImageView(image: imageView?.image)
        
        newImageView.frame = CGRect(x: 0,y: 0,width: 450, height: 600)
        newImageView.center = (imageView?.superview?.center)!
        
        newImageView.backgroundColor = .black
        newImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func takePicture() {
        print("2")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            isCameraImage = true
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showPicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            isCameraImage = false
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            let alertHelper = AlertHelper()
            if (currentImageView?.isEqual(itemImage))! {
                itemImage.image = image
                saveImageToDB()
            } else {
                receiptImage.image = image
                saveReceiptToDB()
            }
            if (isCameraImage)! {
                alertHelper.showAlert(fromController: picker, baseController: self, image: image)
            } else {
                dismiss(animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "We had an issue in the image conversion process...", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            picker.present(alert, animated: true, completion: nil)
        }
    }
    
    func setImage(img: UIImageView) {
        currentImageView = img
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTable()
    }
    
    func reloadTable() {
        displayTableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        var cell = displayTableView.dequeueReusableCell(withIdentifier: identifier)
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = getCellText(count: indexPath.row)
        cell?.detailTextLabel?.text = getCellDetailText(count: indexPath.row)
        cell?.textLabel?.textColor = .black
        cell?.textLabel?.font = cell?.textLabel?.font.withSize(12)
        
        
        cell?.detailTextLabel?.textColor = UIColor(red:0.31, green:0.77, blue:0.76, alpha:1.0)
        cell?.detailTextLabel?.font = cell?.detailTextLabel?.font.withSize(20)
        cell?.accessoryType = .disclosureIndicator
        cell?.tintColor = UIColor.cyan
        
        return cell!
    }
    
    func getCellText(count: Int) -> String {
        switch count {
        case 0:
            return "Type"
        case 1:
            return "Original Price"
        case 2:
            return "Purchase Price"
        case 3:
            return "Estimated Sale Price"
        case 4:
            return "Estimated Profit"
        case 5:
            return "Quality"
        case 6:
            return "Brand"
        case 7:
            return "Dust Bag Included"
        case 8:
            return "Original Box Included"
        case 9:
            return "Purchase Date"
        case 10:
            return "Style Name"
        case 11:
            return "Size"
        case 12:
            return "Store"
        case 13:
            return "Actual Sale Price"
        case 14:
            return "Actual Profit"
        case 15:
            
            
            return "Return Date"
        default:
            print("I effed up somewhere")
            return ""
        }
    }
    
    func getCellDetailText(count: Int) -> String {
        switch count {
        case 0:
            return (product.type)
        case 1:
            return "$" + String(format: "%.2f", (product.originalPrice))
        case 2:
            return "$" + String(format: "%.2f", (product.purchasePrice))
        case 3:
            return "$" + String(format: "%.2f", (product.estSalePrice))
        case 4:
            return "$" + String(format: "%.2f", (product.estProfit))
        case 5:
            return (product.quality)
        case 6:
            return (product.brand)
        case 7:
            if (product.dustBag) {
                return "Yes"
            } else {
                return "No"
            }
        case 8:
            if (product.originalBox) {
                return "Yes"
            } else {
                return "No"
            }
        case 9:
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: (product.dateOfPurchase))
        case 10:
            return (product.styleName)
        case 11:
            return (product.size)
        case 12:
            return (product.store)
        case 13:
            return "$" + String(format: "%.2f", (product.salePrice))
        case 14:
            return "$" + String(format: "%.2f", (product.salePrice) - (product.purchasePrice))
        case 15:
            return getReturnDate()
        default:
            print("I effed up somewhere")
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < 14) {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "productEditView") as! ProductEditViewController
            viewController.propertyEdited = displayTableView.cellForRow(at: indexPath)?.textLabel?.text
            viewController.index = indexPath.row
            viewController.productId = (product.id)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func setupTable() {
        displayTableView.delegate = self
        displayTableView.dataSource = self
    }
    
    func loadProductView() {
        itemImage.image = getImage(id: (product.id),isImage: true)
        itemImage.contentMode = .scaleAspectFit
        itemImage.backgroundColor = .gray
        receiptImage.image = getImage(id: (product.id), isImage: false)
        receiptImage.contentMode = .scaleAspectFit
        receiptImage.backgroundColor = .gray
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        let pictureTap2 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        
        itemImage.addGestureRecognizer(pictureTap)
        itemImage.isUserInteractionEnabled = true
        receiptImage.addGestureRecognizer(pictureTap2)
        receiptImage.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
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
    
    func getReturnDate() -> String {
        let start = product.dateOfPurchase
        let days = getDaysFromStore()
        
        if (days < 0) {
            return "Unlimited"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: Calendar.current.date(byAdding: .day, value: days, to: start)!)
    }
    
    func getDaysFromStore() -> Int {
        if (product.store == "Bloomingdale's") {
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
    
    func saveImageToDB() {
        do {
            let realm = try Realm()
            try realm.write {
                let data = UIImageJPEGRepresentation(itemImage.image!, 1.0) as NSData?
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                let writePath = documentsPath.appendingPathComponent("ret-assist-" + String(product.id) + ".jpg")
                data?.write(toFile: writePath, atomically: true)
                let itemImageUrl = writePath as NSString
                product.imagePath = itemImageUrl
            }
        } catch {}
    }
    
    func saveReceiptToDB() {
        do {
            let realm = try Realm()
            try realm.write {
                let data = UIImageJPEGRepresentation(receiptImage.image!, 1.0) as NSData?
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                let writePath = documentsPath.appendingPathComponent("ret-assist-" + String(product.id) + "-receipt.jpg")
                data?.write(toFile: writePath, atomically: true)
                let receiptImageUrl = writePath as NSString
                product.receiptPath = receiptImageUrl
            }
        } catch {}
    }
    
}
