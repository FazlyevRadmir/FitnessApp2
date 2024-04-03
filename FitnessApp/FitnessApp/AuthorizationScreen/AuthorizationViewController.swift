import Foundation
import UIKit
import Firebase
import FirebaseAuth

class AuthorizationViewController: UIViewController, UITextFieldDelegate {
    
    let viewModel = AuthorizationViewModel()
    
    lazy var authImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "auth")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        let customColor = UIColor(red: 94/255, green: 174/255, blue: 201/255, alpha: 1.0)
        button.backgroundColor = customColor
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нет аккаунта? Зарегестрируйтесь здесь!", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(authImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            authImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            authImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authImageView.heightAnchor.constraint(equalToConstant: 350),
            authImageView.widthAnchor.constraint(equalToConstant: 350),
            
            emailTextField.topAnchor.constraint(equalTo: authImageView.bottomAnchor, constant: 0),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func loginButtonDidTap() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let viewModel = AuthorizationViewModel()
        viewModel.email = email
        viewModel.password = password
        
        viewModel.signInUser(email: email, password: password) { error in
            if error != nil {
                let alert = UIAlertController(title: "Ошибка", message: "Неверно указана почта или пароль", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { _ in }))
                alert.addAction(UIAlertAction(title: "Очистить", style: .destructive, handler: { _ in
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let tabBarController = TabBarController()
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = tabBarController
                    window.makeKeyAndVisible()
                }
                print("Пользователь успешно авторизован")
            }
        }
    }
    
    @objc private func forgotPasswordButtonTapped() {
        let alertController = UIAlertController(title: "Сброс пароля", message: "Введите адрес электронной почты, чтобы сбросить пароль", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
            textField.autocorrectionType = .no
        }
        
        let saveAction = UIAlertAction(title: "Окей", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if let email = firstTextField.text {
                self.viewModel.sendPasswordResetEmail(withEmail: email) { error in
                    if let error = error {
                        print("Не удалось сбросить пароль: \(error.localizedDescription)")
                    } else {
                        print("Ссылка для сброса пароля отправлена на вашу почту.")
                        DispatchQueue.main.async {
                            self.showPopup()
                        }
                    }
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func registerButtonTapped() {
        let registrationVC = RegistrationViewController()
        self.navigationController?.setViewControllers([registrationVC], animated: true)
    }
    
    func showPopup() {
        let popupView = UIView(frame: CGRect(x: 0, y: 0, width: 393, height: 50))
        
        // Создаем объект UIBezierPath для формы овала с заостренными концами
        let popupPath = UIBezierPath(roundedRect: popupView.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 50, height: 20))
        
        // Создаем слой CAShapeLayer для маскирования popupView
        let popupMask = CAShapeLayer()
        popupMask.path = popupPath.cgPath
        popupView.layer.mask = popupMask
        
        // Задаем цвет и анимацию
        popupView.backgroundColor = UIColor.gray
        popupView.alpha = 0.0
        popupView.layer.cornerRadius = 0
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 390, height: 50))
        label.text = "Ссылка отправлена на указанную почту"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.numberOfLines = 0
        
        popupView.addSubview(label)
        self.view.addSubview(popupView)
        
        // Анимация появления и исчезновения овала
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseOut], animations: {
            popupView.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: [.curveEaseOut], animations: {
                popupView.alpha = 0.0
            }, completion: { _ in
                popupView.removeFromSuperview()
            })
        })
        
        popupView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            popupView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popupView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70)
        ])
    }

}

