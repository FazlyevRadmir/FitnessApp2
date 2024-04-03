import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImage



class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        isChangesMade = true
        updateSaveButtonState()
    }
    
    let viewModel = ProfileViewModel()
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let emailTextField = UITextField()
    let nameTextField = UITextField()
    let surnameTextField = UITextField()
    let saveButton = UIButton()
    let logoutButton = UIButton()
    
    var isChangesMade = false
    var userProfile: Profile?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        ref = Database.database().reference()
        loadUserData()
    }
    
    private func setupUI() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.isUserInteractionEnabled = false
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setImage(UIImage(systemName: "power"), for: .normal)
        logoutButton.tintColor = .red
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.isEnabled = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.backgroundColor = .gray
        saveButton.layer.cornerRadius = 20
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        emailTextField.placeholder = "Загрузка данных..."
        nameTextField.placeholder = "Загрузка данных..."
        surnameTextField.placeholder = "Загрузка данных..."
        
        view.addSubview(logoutButton)
        view.addSubview(saveButton)
        view.addSubview(emailTextField)
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        
        let textFields = [emailTextField, nameTextField, surnameTextField]
        
        textFields.forEach { textField in
            textField.backgroundColor = UIColor(named: "Background")
            textField.layer.cornerRadius = 20
            textField.layer.borderWidth = 3
            textField.layer.borderColor = UIColor(named: "Blue")?.cgColor
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.textAlignment = .left
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
            
            view.addSubview(textField)
        }
        
        view.backgroundColor = UIColor(named: "Background")
        
        profileImageView.image = UIImage(named: "defaultAvatar")
        profileImageView.layer.cornerRadius = 100
        profileImageView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: 250),
            profileImageView.heightAnchor.constraint(equalToConstant: 250),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            emailTextField.widthAnchor.constraint(lessThanOrEqualToConstant: 550),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(lessThanOrEqualToConstant: 550),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            nameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            
            surnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            surnameTextField.widthAnchor.constraint(lessThanOrEqualToConstant: 550),
            surnameTextField.heightAnchor.constraint(equalToConstant: 50),
            surnameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            surnameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            saveButton.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 30),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoutButton.widthAnchor.constraint(equalToConstant: 25),
            logoutButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
    }
    
    @objc func saveButtonTapped() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userRef = ref.child("users").child(userID)
        
        if let name = nameTextField.text, let surname = surnameTextField.text, isChangesMade {
            let updatedValues: [String: Any] = ["name": name, "surname": surname]
            
            userRef.updateChildValues(updatedValues) { [weak self] error, _ in
                if let error = error {
                    print("Ошибка при обновлении профиля пользователя: \(error.localizedDescription)")
                    return
                }
                
                print("Профиль пользователя успешно обновлен")
                self?.isChangesMade = false
                self?.updateSaveButtonState()
            }
        }
    }
    
    private func updateSaveButtonState() {
        let isDataChanged = nameTextField.text != userProfile?.name || surnameTextField.text != userProfile?.surname
        saveButton.isEnabled = isDataChanged
        let customColor = UIColor(red: 94/255, green: 174/255, blue: 201/255, alpha: 1.0)
        saveButton.backgroundColor = isDataChanged ? customColor : .gray
    }
    
    func loadUserData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        print("UserID: \(userID)")

        let userRef = ref.child("users").child(userID)

        userRef.observe(.value) { [weak self] (snapshot: DataSnapshot) in
            guard let userData = snapshot.value as? [String: Any],
                  let name = userData["name"] as? String,
                  let surname = userData["surname"] as? String,
                  let email = userData["email"] as? String,
                  let profileURL = userData["profileURL"] as? String
            else {
                return
            }

            self?.userProfile = Profile(name: name, surname: surname, email: email, profileURL: profileURL)

            DispatchQueue.main.async {
                self?.emailTextField.text = self?.userProfile?.email
                self?.nameTextField.text = self?.userProfile?.name
                self?.surnameTextField.text = self?.userProfile?.surname
            }

            if let url = URL(string: profileURL) {
                self?.profileImageView.sd_setImage(with: url) { [weak self] (_, _, _, _) in
                    DispatchQueue.main.async {
                        self?.updateSaveButtonState()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.updateSaveButtonState()
                }
            }
        }
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImageView.image = pickedImage
            
            guard let userID = Auth.auth().currentUser?.uid else {
                return
            }
            
            let storageRef = Storage.storage().reference().child("profileImages").child(userID)
            
            if let imageData = pickedImage.jpegData(compressionQuality: 0.8) {
                let uploadTask = storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        print("Ошибка при загрузке фотографии в Firebase Storage: \(error.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print("Ошибка при получении URL загруженной фотографии: \(error.localizedDescription)")
                            return
                        }
                        
                        if let profileURL = url?.absoluteString {
                            self.updateUserProfile(profileURL: profileURL)
                        }
                    }
                }
                
                uploadTask.resume()
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func updateUserProfile(profileURL: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userRef = ref.child("users").child(userID)
        
        userRef.updateChildValues(["profileURL": profileURL]) { error, _ in
            if let error = error {
                print("Ошибка при обновлении профиля пользователя: \(error.localizedDescription)")
                return
            }
            
            print("Профиль пользователя успешно обновлен")
        }
    }
    
    @objc func logoutButtonTapped() {
        do {
            print("Кнопка выхода нажата")
            try Auth.auth().signOut()
            let authVC = AuthorizationViewController()
            UIApplication.shared.keyWindow?.rootViewController = authVC
        } catch let signOutError as NSError {
            print("Ошибка при выходе: \(signOutError.localizedDescription)")
        }
    }


    
    
    
    @objc func didTapProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: nil, message: "Камера недоступга", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let libraryAction = UIAlertAction(title: "Медиатека", style: .default) { (_) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Выйти", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isChangesMade = true
        updateSaveButtonState()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isChangesMade = true
        updateSaveButtonState()
    }
}
