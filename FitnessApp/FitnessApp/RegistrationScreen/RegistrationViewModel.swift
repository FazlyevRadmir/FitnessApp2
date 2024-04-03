import Foundation
import Firebase
import UIKit


protocol RegistrationViewModelProtocol {
    
    func registrationUser(completion: @escaping (Result<Bool, Error>) -> Void)
    
    func saveUserToFirebase(user: User, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

class RegistrationViewModel {

    var name: String = ""
    var surname: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
    func registrationUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        if password == confirmPassword {
            Auth.auth().fetchSignInMethods(forEmail: email) { signInMethods, error in
                if self.name.isEmpty || self.surname.isEmpty || self.email.isEmpty || self.password.isEmpty || self.confirmPassword.isEmpty {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не все поля заполнены"])
                    completion(.failure(error))
                } else if error != nil {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Неверный формат почты"])
                    completion(.failure(error))
                } else if let signInMethods = signInMethods, !signInMethods.isEmpty {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Пользователь с такой почтой уже существует"])
                    completion(.failure(error))
                } else {
                    let passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{8,}$"
                    if !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self.password) {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Пароль должен содержать не менее 8 символов, как минимум одну заглавную и строчную буквы, одну цифру."])
                        completion(.failure(error))
                    } else {
                        Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                let user = User(name: self.name, surname: self.surname, email: self.email, profileURL: "")
                                self.saveUserToFirebase(user: user) { result in
                                    completion(result)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Пароли не совпадают"])
            completion(.failure(error))
        }
    }

    private func saveUserToFirebase(user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить идентификатор пользователя"])
            completion(.failure(error))
            return
        }
        
        let userRef = Database.database().reference().child("users").child(userID)
        userRef.setValue(user.dictionaryRepresentation) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
