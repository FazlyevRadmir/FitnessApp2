import UIKit

class TrainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        addButtons()
        addImageView()
    }
    
    private func addImageView() {
        let imageView = UIImageView(image: UIImage(named: "trainScreen"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -120),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    private func addButtons() {
        let button1 = UIButton()
        let button2 = UIButton()
        let button3 = UIButton()
        let buttons = [button1, button2, button3]
        
        buttons.forEach { button in
            button.backgroundColor = UIColor(named: "Background")
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor(named: "Blue")?.cgColor
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
        }
        
        button1.setTitle("Создайте свою тренировку", for: .normal)
        button2.setTitle("Тренировки", for: .normal)
        button3.setTitle("Мои тренировки", for: .normal)
        
        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            button1.widthAnchor.constraint(equalToConstant: 500),
            button1.heightAnchor.constraint(equalToConstant: 50),
            button1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            button1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 20),
            button2.widthAnchor.constraint(equalToConstant: 500),
            button2.heightAnchor.constraint(equalToConstant: 50),
            button2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20),
            button3.widthAnchor.constraint(equalToConstant: 500),
            button3.heightAnchor.constraint(equalToConstant: 50),
            button3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            button3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
        
        button1.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2Tapped), for: .touchUpInside)
        button3.addTarget(self, action: #selector(button3Tapped), for: .touchUpInside)
    }
    
    
    @objc private func button1Tapped() {
        let trainVC = MyTrainViewController()
        navigationController?.pushViewController(trainVC, animated: true)
    }
    
    
    @objc private func button2Tapped() {        
        let exercisesVC = ExercisesViewController()
        navigationController?.pushViewController(exercisesVC, animated: true)
    }
    
    @objc private func button3Tapped() {
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }

}


