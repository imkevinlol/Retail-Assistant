import UIKit

class ImageDisplayViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var theImage: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = theImage
    }
}
