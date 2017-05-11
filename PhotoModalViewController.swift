
import UIKit

protocol ModalDelegate {
    func showFullscreen()
    func takePicture()
    func showPicture()
    func setImage(img : UIImageView)
}

class PhotoModalViewController: UIViewController {

    var delegate: ModalDelegate?
    var imageView : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = self.delegate {
            delegate.setImage(img: imageView!)
        }
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showFullscreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if let delegate = self.delegate {
            delegate.showFullscreen()
        }
    }
    
    @IBAction func takePicture(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if let delegate = self.delegate {
            delegate.takePicture()
        }
    }
    
    @IBAction func showPicture(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if let delegate = self.delegate {
            delegate.showPicture()
        }
    }
    
    @IBAction func dismissFullscreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
