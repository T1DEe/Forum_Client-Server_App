
import UIKit

class ThreadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var threadTitle: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var threadDescription: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
