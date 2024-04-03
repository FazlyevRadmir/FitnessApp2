import UIKit


class RegistrationViewController: UIViewController {
    
    let viewModel = RegistrationViewModel()
    
    lazy var registerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "register")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()
    
    lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Фамилия"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = true
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        eyeButton.tintColor = UIColor(red: 94/255, green: 174/255, blue: 201/255, alpha: 1.0)
        textField.rightView = eyeButton
        textField.rightViewMode = .always
        return textField
    }()
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeButton = passwordTextField.rightView as? UIButton
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton?.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Повторите пароль"
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.addTarget(self, action: #selector(togglConfirmPasswordVisibility), for: .touchUpInside)
        eyeButton.tintColor = UIColor(red: 94/255, green: 174/255, blue: 201/255, alpha: 1.0)
        textField.rightView = eyeButton
        textField.rightViewMode = .always
        return textField
    }()
    
    @objc private func togglConfirmPasswordVisibility() {
        confirmPasswordTextField.isSecureTextEntry.toggle()
        let eyeButton = confirmPasswordTextField.rightView as? UIButton
        let imageName = confirmPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton?.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегестрироваться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        let customColor = UIColor(red: 94/255, green: 174/255, blue: 201/255, alpha: 1.0)
        button.backgroundColor = customColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var haveAccount: UIButton = {
        let button = UIButton()
        button.setTitle("Есть аккаунт? Войдите!", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(haveAccountButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [nameTextField, surnameTextField, emailTextField, passwordTextField, confirmPasswordTextField, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(haveAccount)
        stackView.addSubview(registerImageView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            haveAccount.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            haveAccount.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            registerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            registerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerImageView.heightAnchor.constraint(equalToConstant: 270),
            registerImageView.widthAnchor.constraint(equalToConstant: 270)
            
        ])
    }
    
    @objc private func haveAccountButtonTapped() {
        let authorizationVC = AuthorizationViewController()
        self.navigationController?.setViewControllers([authorizationVC], animated: true)
    }
    
    @objc private func registerButtonTapped() {
        
        viewModel.name = nameTextField.text ?? ""
        viewModel.surname = surnameTextField.text ?? ""
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
        
        viewModel.registrationUser { result in
            switch result {
            case .success:
                print("User registered successfully")
                let authorizationVC = AuthorizationViewController()
                self.navigationController?.setViewControllers([authorizationVC], animated: true)
            case .failure(let error):
                print("Error registering user: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
    }
}
