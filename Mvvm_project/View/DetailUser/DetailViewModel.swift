import Foundation
import UIKit
import CoreData
final class DetailViewModel{
    var infousers : [NSManagedObject] = []
    func fetchInfoUser(completion: @escaping ([NSManagedObject]) -> Void ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedConText = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDetail")
        do{
            infousers  = try managedConText.fetch(fetchRequest)
            completion(infousers)
            for data in infousers as! [NSManagedObject]{
                //                print(data.value(forKey: "name") as! String)
            }
        }catch let error as NSError{
            print("Could not fetch , \(error),\(error.userInfo)")
            print (0)
        }
    }
    
    func saveInfoUser(name: String,bio: String,avatar_url: String,created_at: Date, followers: Int64, email: String, login: String){
        print("save infor detail users")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "InfoUser", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(name, forKeyPath: "name")
        user.setValue(bio, forKeyPath: "bio")
        user.setValue(followers, forKey: "followers")
        user.setValue(email, forKey: "email")
        user.setValue(created_at, forKey: "created_at")
        user.setValue(login, forKey: "login")
        let urlImage = URL(string: avatar_url)!
        if let data  = try? Data(contentsOf: urlImage){
            user.setValue(data, forKeyPath: "avatar_url")
        }
        do{
            try managedContext.save()
            infousers.append(user)
        }catch let error as NSError{
            print("Could not save, \(error), \(error.userInfo)")
        }
    }
    func fetchDetailUser( ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedConText = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDetail")
        do{
            infousers  = try managedConText.fetch(fetchRequest)
            for data in infousers as! [NSManagedObject]{
                //                print(data.value(forKey: "name") as! String)
            }
        }catch let error as NSError{
            print("Could not fetch , \(error),\(error.userInfo)")
            print (0)
        }
    }
    func removeDetailUser(){
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserDetail")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error.localizedDescription)
        }
    }
}
