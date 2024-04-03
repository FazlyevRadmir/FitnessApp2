import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol AuthorizationViewModelProtocol {
    
    func signInUser(email: String, password: String, completion: @escaping (String?) -> Void)
    
    func sendPasswordResetEmail(withEmail email: String, completion: @escaping (Error?) -> Void)
}

class AuthorizationViewModel {
    var email: String?
    var password: String?
    
    func signInUser(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Ошибка при авторизации пользователя: \(error.localizedDescription)")
                completion(error.localizedDescription)
            } else {
                print("Пользователь успешно авторизован")
                completion(nil)
            }
        }
    }
    
    func sendPasswordResetEmail(withEmail email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}

