import RxSwift
import Alamofire
import Foundation
import SwiftyJSON
class UserService{

    
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
    
    func fetchDetailUser(string: String) -> Observable<[DetailUserModel]>{
        return Observable.create { observer -> Disposable in
            let url = "https://api.github.com/users/\(string)"
            let task =  AF.request(url).responseJSON {response in
                switch (response.result) {
                case .success( _):
                    do {
                        let users = try JSONDecoder().decode([DetailUserModel].self, from: response.data!)
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
