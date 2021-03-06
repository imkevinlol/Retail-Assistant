import UIKit
import RealmSwift

open class RetailProduct: Object {
    dynamic var type : String = ""
    dynamic var originalPrice : Double = 0.0
    dynamic var purchasePrice : Double = 0.0
    dynamic var estSalePrice : Double = 0.0
    dynamic var estProfit : Double = 0.0
    dynamic var quality : String = ""
    dynamic var brand : String = ""
    dynamic var dustBag : Bool = false
    dynamic var originalBox : Bool = false
    dynamic var dateOfPurchase : Date = Date()
    dynamic var id = 0
    dynamic var styleName : String = ""
    dynamic var size : String = ""
    dynamic var store : String = ""
    dynamic var imagePath : NSString = ""
    dynamic var receiptPath : NSString = ""
    dynamic var salePrice : Double = 0.0
    dynamic var profit : Double = 0.0

    
    override open static func primaryKey() -> String? {
        return "id"
    }
}
