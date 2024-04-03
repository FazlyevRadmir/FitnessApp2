import UIKit
import WebKit

struct ExerciseBody: Codable {
    let url: String
    let name: String
    let description: String
    let benefits: String
}

class BodyExercisesViewController: UIViewController, UIGestureRecognizerDelegate{

    var exercises: [ExerciseBody] = []
    var imageViews: [UIImageView] = []
    let scrollView = UIScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        view.backgroundColor = UIColor(named: "Background")
    
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)


        let label = UILabel(frame: CGRect(x: 20, y: 20, width: view.bounds.width - 40, height: 50))
        label.text = "Всё тело"
        label.textAlignment = .left
        label.textColor = UIColor(named: "Green")
        label.font = UIFont.boldSystemFont(ofSize: 40)
        scrollView.addSubview(label)
        
        let button = UIButton(frame: CGRect(x: 20, y: scrollView.contentSize.height + 895, width: view.bounds.width - 40, height: 50))
        button.backgroundColor = UIColor(named: "Blue")
        button.layer.cornerRadius = 20
        button.setTitle("Старт", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        scrollView.addSubview(button)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        loadExercises()
    }
    

    @objc private func startButtonTapped() {
        let exerciseScreenViewController = TrainBodyViewController()
        navigationController?.pushViewController(exerciseScreenViewController, animated: true)
    }

    
    private func loadExercises() {
        guard let url = Bundle.main.url(forResource: "allBody", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            exercises = try decoder.decode([String: [ExerciseBody]].self, from: data)["exercises"] ?? []
            
            setupImageViews()
            
        } catch {
        }
    }

    private func setupImageViews() {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 10
        let rectangleWidth = (screenWidth - spacing * 3) / 2
        var xPosition: CGFloat = spacing
        var yPosition: CGFloat = 100
        let group = DispatchGroup()

        for (index, exercise) in exercises.enumerated() {
            let containerView = UIView(frame: CGRect(x: xPosition, y: yPosition, width: rectangleWidth, height: rectangleWidth))
            containerView.clipsToBounds = true
            containerView.layer.cornerRadius = 20
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor(named: "Green")?.cgColor
            scrollView.addSubview(containerView)

            let webView = WKWebView(frame: CGRect(x: -20, y: 0, width: rectangleWidth * 1.2, height: rectangleWidth * 2))
            webView.contentMode = .scaleAspectFit
            containerView.addSubview(webView)
            containerView.tag = index
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exerciseTapped(_:)))
            tapGesture.delegate = self
            containerView.addGestureRecognizer(tapGesture)

            
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
        }
        
        scrollView.contentSize = CGSize(width: screenWidth, height: yPosition + rectangleWidth - spacing + 16)
    }
    
    private func showExerciseDetails(_ exercise: ExerciseBody) {
        let modalViewController = BodyDetailViewController()
        modalViewController.exercise = exercise
        modalViewController.modalPresentationStyle = .pageSheet
        modalViewController.nameDescription = exercise.name
        modalViewController.exerciseDescription = exercise.description
        modalViewController.benefitsDescription = exercise.benefits
        present(modalViewController, animated: true, completion: nil)
    }


    @objc private func exerciseTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag,
              index < exercises.count else {
            return
        }

        let exercise = exercises[index]
        showExerciseDetails(exercise)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}


