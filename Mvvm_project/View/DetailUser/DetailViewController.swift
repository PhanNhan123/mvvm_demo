
import Foundation
import RxSwift
import CoreData
import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var users:  [NSManagedObject] = []
    @IBOutlet weak var detailTableView: UITableView!
    private let viewModel = DetailViewModel()
    var login = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let disposeBag = DisposeBag()
        let service = UserService()
        service.fetchDetailUser(string: login).subscribe(onNext: {users in
            for item in users{
                self.viewModel.saveInfoUser(name: item.name, bio: item.bio, avatar_url: item.avatar_url, created_at: item.created_at, followers: item.followers, email: item.email, login: item.login)
                print("savedetailuser")
            }
        }).disposed(by: disposeBag)
        fetchDetailUser()
        detailTableView.dataSource = self
        detailTableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->  Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! DetailTableViewCell
        let user  = users.filter{item in return item.value(forKey:"login") as! String == login}
        let infouser = user[indexPath.row]
        cell.nameLabel.text = infouser.value(forKey: "name") as! String
        cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        cell.bioLabel.text = infouser.value(forKey: "bio") as! String
        cell.contentView.backgroundColor = .lightGray
        // change format date
        let date = infouser.value(forKey: "created_at") as! Date
        let  dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        cell.dateLabel.text = "Since \(dateString)"
        let data = infouser.value(forKey: "avatar_url") as! Data
        cell.avatarImage.image = UIImage(data: data)
        cell.followersLabel.text = "\(String(infouser.value(forKey: "followers") as! Int64)) Followers"
        cell.mailLabel.text = infouser.value(forKey: "email") as! String
        //        cell.emailLabel.text = "email@gmail.com"
        cell.githubImage.image = UIImage(named: "github.png")
        cell.mailImage.image = UIImage(named: "email.png")
        
//        cell.contentLabel.frame = CGRect(x:20 , y: 470 , width: UIScreen.main.bounds.width , height: 200)
//        cell.emailImage.frame = CGRect(x:100 , y: 670 , width: 30 , height: 30)
//        cell.emailLabel.frame = CGRect(x:140 , y: 670 , width: 250 , height: 30)
        return cell
    }
    func tableView(_ tableView:UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat{return 1000}
    
    func fetchDetailUser( ) {
        print("detchdetailuser")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedConText = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDetail")
        do{
            users  = try managedConText.fetch(fetchRequest)
            for data in users as! [NSManagedObject]{
                //                print(data.value(forKey: "name") as! String)
            }
        }catch let error as NSError{
            print("Could not fetch , \(error),\(error.userInfo)")
            print (0)
        }
    }
}

