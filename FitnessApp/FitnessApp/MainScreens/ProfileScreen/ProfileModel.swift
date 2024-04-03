import Foundation

class Profile {
    var name: String
    var surname: String
    var email: String
    var profileURL: String

    init(name: String, surname: String, email: String, profileURL: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.profileURL = profileURL
    }
}
