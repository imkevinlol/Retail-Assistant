
import UIKit

class PhotoModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func dismissFullscreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
