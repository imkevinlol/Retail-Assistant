import UIKit

class ProductDisplayViewController: UIViewController {
    
    @IBOutlet weak var displayTableView: UITableView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var receiptImage: UIImageView!
    var product : RetailProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProductView()
    }
    
    func loadProductView() {
        itemImage.image = getImage(id: (product?.id)!,isImage: true)
        itemImage.contentMode = .scaleAspectFit
        itemImage.backgroundColor = .gray
        receiptImage.image = getImage(id: (product?.id)!, isImage: false)
        receiptImage.contentMode = .scaleAspectFit
        receiptImage.backgroundColor = .gray
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        let pictureTap2 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        
        itemImage.addGestureRecognizer(pictureTap)
        itemImage.isUserInteractionEnabled = true
        receiptImage.addGestureRecognizer(pictureTap2)
        receiptImage.isUserInteractionEnabled = true
        
//        salePriceLB.text = String(format: "%.2f", (product?.estSalePrice)!)
//        profitLB.text = String(format: "%.2f", (product?.estProfit)!)
//        typeTF.text = product?.type
//        originalPriceTF.text = String(format: "%.2f", (product?.originalPrice)!)
//        purchasePriceTF.text = String(format: "%.2f", (product?.purchasePrice)!)
//        qualityTF.text = product?.quality
//        brandTF.text = product?.brand
//        dustBagSW.isOn = (product?.dustBag)!
//        originalBoxSW.isOn = (product?.originalBox)!
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        dateOfPurchaseTF.text = dateFormatter.string(from: (product?.dateOfPurchase)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
 
        newImageView.frame = CGRect(x: 0,y: 0,width: 450, height: 600)
        newImageView.center = (imageView.superview?.center)!
        
        newImageView.backgroundColor = .black
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
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
    
    @IBAction func toProductEditVC(_ sender: Any) {
        
    }
}
