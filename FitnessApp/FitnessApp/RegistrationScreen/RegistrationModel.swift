class User {
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

    var dictionaryRepresentation: [String: Any] {
        return [
            "name": name,
            "surname": surname,
            "email": email,
            "profileURL": profileURL
        ]
    }
}
