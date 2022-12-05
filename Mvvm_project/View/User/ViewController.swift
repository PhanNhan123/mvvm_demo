import RxSwift
import UIKit
import CoreData
import RxCocoa
class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var users:  [NSManagedObject] = []
    @IBOutlet weak var userTableView: UITableView!
    private let viewModel = UserViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = UserService()
        //        service.fetchUser().subscribe(onNext: {users in
        //            for item in users{
        //                print(item.login)
        ////                self.viewModel.removeCoreData()
        //                self.viewModel.save(login:item.login,html_url: item.html_url,avatar_url: item.avatar_url)
        //                print("save")
        //            }
        //        }).disposed(by: disposeBag)
        fetchData()
        userTableView.dataSource = self
        userTableView.delegate = self
        
        
        
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.loginLabel.text = user.value(forKey: "login") as! String
        cell.loginLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cell.linkLabel.text  =  user.value(forKey: "html_url") as! String
        cell.linkLabel.textColor = .blue
        let data = user.value(forKey: "avatar_url") as! Data
        cell.avatarImage.image  = UIImage(data: data)
        cell.avatarImage.layer.cornerRadius = 20
        cell.avatarImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return cell
    }
    func tableView(_ tableView:UITableView,didSelectRowAt indexPath: IndexPath){
        let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController
        var user = users[indexPath.row]
        vc?.login =  user.value(forKey: "login") as! String
        self.navigationController?.pushViewController(vc!, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.red
        
    }
    //    func bindTableView(){
    //        userTableView.rx.setDelegate(self).disposed(by: disposeBag )
    //        viewModel.users.bind(to: userTableView.rx.items(cellIdentifier: "UserTableViewCell",cellType: UserTableViewCell.self)){(row,item,cell) in
    //            cell.loginLabel?.text = item.login
    //            cell.linkLabel?.text = item.html_url
    //        }.disposed(by: disposeBag)
    //    }
    
    func fetchData( ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedConText = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do{
            users  = try managedConText.fetch(fetchRequest)
            
            for data in users as! [NSManagedObject]{
                let string = data.value(forKey: "login") as! String
                print("login: \(string)")
            }
        }catch let error as NSError{
            print("Could not fetch , \(error),\(error.userInfo)")
            print (0)
        }
    }
}


