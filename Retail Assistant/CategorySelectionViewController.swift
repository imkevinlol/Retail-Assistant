import UIKit

protocol CategoryModalDelegate {
    func setValueInField(section: Int, row: Int, value: String)
}

class CategorySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var delegate: CategoryModalDelegate?
    var deledateIndexPath: IndexPath?
    var displayList = [String]()
    var isCurrentImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "myCell")
        }
        
        cell?.textLabel?.text = displayList[indexPath.row]
        cell?.textLabel?.textColor = .black
        cell?.textLabel?.font = cell?.textLabel?.font.withSize(17)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        self.delegate?.setValueInField(section: (self.deledateIndexPath?.section)!, row: (self.deledateIndexPath?.row)!, value: (cell?.textLabel?.text)!)
        for aViewController:UIViewController in self.navigationController!.viewControllers as [UIViewController] {
            if aViewController.isKind(of: EntryTableViewController.self) {
                self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }
}
