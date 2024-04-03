import UIKit
import WebKit
import Firebase
import FirebaseDatabase

struct AllBody: Codable {
    let url: String
    let name: String
    var repetitionCount: Int?
}


class MyTrainViewController: UIViewController {
    
    private var exerciseViews: [UIView] = []
    var trainingName: String?
    private var trainingNameTextField: UITextField?
    private var selectedExercises: [AllBody] = []
    
    var imageViews: [UIImageView] = []
    let scrollView = UIScrollView()
    var allExercises: [AllBody] = []
    let fileNames = ["allBody", "stretching", "warm-up"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        
        loadAllExercises()
        
        let textFieldHeight: CGFloat = 60
        let buttonHeight: CGFloat = 60
        let spacing: CGFloat = 20
        let textFieldFrame = CGRect(x: spacing, y: spacing, width: view.bounds.width - 2 * spacing, height: textFieldHeight)
        let buttonFrame = CGRect(x: spacing, y: spacing, width: view.bounds.width - 2 * spacing, height: buttonHeight)
        
        let textField = UITextField(frame: textFieldFrame)
        textField.placeholder = "Введите название тренировки"
        textField.textAlignment = .left
        textField.layer.borderWidth = 3
        textField.layer.cornerRadius = spacing
        textField.layer.borderColor = UIColor(named: "Blue")?.cgColor
        trainingNameTextField = textField
        scrollView.addSubview(textField)
        
        let startButton = UIButton(type: .system)
        startButton.frame = buttonFrame
        startButton.setTitle("Сохранить", for: .normal)
        startButton.backgroundColor = UIColor(named: "Blue")
        startButton.layer.cornerRadius = spacing
        startButton.layer.borderWidth = 3
        startButton.layer.borderColor = UIColor(named: "Blue")?.cgColor
        startButton.setTitleColor(.black, for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        scrollView.addSubview(startButton)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -spacing)
        let leadingConstraint = startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing)
        let trailingConstraint = startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing)
        let heightConstraint = startButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        NSLayoutConstraint.activate([bottomConstraint, leadingConstraint, trailingConstraint, heightConstraint])
    }
    
    private func loadAllExercises() {
        
        for fileName in fileNames {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                print("JSON file not found: \(fileName)")
                continue
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let exercises = try decoder.decode([String: [AllBody]].self, from: data)["exercises"] ?? []
                allExercises += exercises
                print("Data loaded successfully: \(fileName)")
            } catch {
                print("Error loading data: \(error)")
            }
        }
        
        setupImageViews()
    }
    
    private func setupImageViews() {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 10
        let rectangleWidth = (screenWidth - spacing * 3) / 2
        var xPosition: CGFloat = spacing
        var yPosition: CGFloat = 100
        let group = DispatchGroup()
        
        for (index, exercise) in allExercises.enumerated() {
            let containerView = UIView(frame: CGRect(x: xPosition, y: yPosition, width: rectangleWidth, height: rectangleWidth))
            containerView.clipsToBounds = true
            containerView.layer.cornerRadius = 20
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor(named: "Green")?.cgColor
            scrollView.addSubview(containerView)
            let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: rectangleWidth, height: rectangleWidth))
            webView.contentMode = .scaleAspectFit
            containerView.addSubview(webView)
            
            let plusButton = UIButton(type: .system)
            plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            plusButton.tintColor = .black
            plusButton.frame = CGRect(x: rectangleWidth - 35, y: rectangleWidth - 35, width: 35, height: 35)
            plusButton.tag = index
            plusButton.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
            containerView.addSubview(plusButton)
            exerciseViews.append(containerView)
            
            if let url = URL(string: exercise.url) {
                let request = URLRequest(url: url)
                group.enter()
                webView.load(request)
            } else {
                print("Invalid URL: \(exercise.url)")
            }
            
            if index % 2 == 0 {
                xPosition += rectangleWidth + spacing
            } else {
                yPosition += rectangleWidth + spacing
                xPosition = spacing
            }
        }
        
        group.notify(queue: .main) {
            print("All gifs have finished loading")
        }
        
        scrollView.contentSize = CGSize(width: screenWidth, height: yPosition + rectangleWidth - spacing - 50)
    }
    
    @objc private func plusButtonTapped(_ sender: UIButton) {
        exerciseViews[sender.tag].backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        
        let alertController = UIAlertController(title: "Введите количество повторений", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Количество повторений"
            textField.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first,
               let repetitionCount = Int(textField.text ?? "") {
                self?.updateExerciseView(sender.tag, repetitionCount: repetitionCount)
                self?.exerciseViews[sender.tag].backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    private func updateExerciseView(_ index: Int, repetitionCount: Int) {
        guard index >= 0, index < allExercises.count else {
            return
        }
        
        var exercise = allExercises[index]
        exercise.repetitionCount = repetitionCount
        
        let exerciseView = exerciseViews[index]
        exerciseView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        exerciseView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        label.text = "\(repetitionCount)"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.center = CGPoint(x: exerciseView.bounds.midX, y: exerciseView.bounds.midY)
        exerciseView.addSubview(label)
        
        selectedExercises.append(exercise)
    }
    
    
    
    @objc func startButtonTapped(_ sender: UIButton) {
        if let trainingName = trainingNameTextField?.text, !trainingName.isEmpty {
            saveTraining(trainingName)
        }
    }
    
    private func saveTraining(_ name: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Пользователь не вошел в систему")
            return
        }
        
        let userRef = Database.database().reference().child("users").child(userId)
        let trainingRef = userRef.child("trainings").childByAutoId()
        let trainingData: [String: Any] = [
            "name": name
        ]
        
        trainingRef.setValue(trainingData) { [weak self] (error, _) in
            if let error = error {
                print("Ошибка при сохранении тренировки: \(error.localizedDescription)")
            } else {
                print("Тренировка успешно сохранена")
            }
            
            self?.exerciseViews = self?.scrollView.subviews ?? []
            self?.saveExerciseData(for: trainingRef)
        }
        
        print(userRef)
        print(trainingRef)
    }
    
    
    private func saveExerciseData(for trainingRef: DatabaseReference) {
        print("saveExerciseData in work")
        var trainingData: [String: Any] = [:]
        var exercisesData: [[String: Any]] = []
        
        for exercise in selectedExercises {
            let exerciseData: [String: Any] = [
                "name": exercise.name,
                "repetitionCount": exercise.repetitionCount ?? 0
            ]
            exercisesData.append(exerciseData)
            
            print("Exercise added: \(exercise.name)")
        }
        
        trainingData["name"] = trainingNameTextField?.text
        trainingData["exercises"] = exercisesData
        
        print("Training data: \(trainingData)")
        
        trainingRef.setValue(trainingData) { (error, _) in
            if let error = error {
                print("Ошибка при сохранении данных тренировки: \(error.localizedDescription)")
            } else {
                print("Данные тренировки успешно сохранены")
            }
        }
    }
    
}
