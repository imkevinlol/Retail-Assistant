import UIKit

class ProductDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var dateOfPurchaseLabel: UILabel!
    @IBOutlet weak var purchasePriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
