import Foundation
import UIKit
import CoreData
import RxSwift
import Alamofire

final class UserViewModel{
    
    //    let outUsers = PublishSubject<[UserModel]>()
    var users:  [NSManagedObject] = []
    let userService = UserService()
    
    
    func save(login: String,html_url:String,avatar_url:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(login, forKeyPath: "login")
        user.setValue(html_url, forKeyPath: "html_url")
        let urlImage = URL(string: avatar_url)!
        if let data  = try? Data(contentsOf: urlImage){
            user.setValue(data, forKeyPath: "avatar_url")
        }
        do{
            try managedContext.save()
            users.append(user)
        }catch let error as NSError{
            print("Could not save, \(error), \(error.userInfo)")
        }
    }
    func fetchData( ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedConText = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do{
            users  = try managedConText.fetch(fetchRequest)
            for data in users as! [NSManagedObject]{
                let string = data.value(forKey: "login") as! String
                print(string)
            }
        }catch let error as NSError{
            print("Could not fetch , \(error),\(error.userInfo)")
            print (0)
        }
    }
   
    func removeCoreData() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error.localizedDescription)
        }
    }
    
    func fetchUser() -> Observable<[UserModel]>{
        return Observable.create { observer -> Disposable in
            let url = "https://api.github.com/users"
            let task =  AF.request(url).responseJSON {response in
                switch (response.result) {
                case .success( _):
                    do {
                        let users = try JSONDecoder().decode([UserModel].self, from: response.data!)
                        observer.onNext(users)
                        
                        DispatchQueue.main.async {
                            print("dispatched to main")
                        }
                    } catch let error as NSError {
                        observer.onError(error)
                    }
                case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
