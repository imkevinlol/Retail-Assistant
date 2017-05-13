import UIKit

class ImageDisplayViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var theImage: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = theImage
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.clipsToBounds = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
