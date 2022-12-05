import Foundation
import UIKit
class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var mailImage: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var githubImage: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
} 

