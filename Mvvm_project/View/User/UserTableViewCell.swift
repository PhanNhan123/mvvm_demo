import Foundation
import UIKit
class UserTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func bind(user: UserModel) {
            loginLabel.text = user.login
            linkLabel.text =  user.html_url
//            userImageView.loadURL(user.avatar_url)
       
        }

}
