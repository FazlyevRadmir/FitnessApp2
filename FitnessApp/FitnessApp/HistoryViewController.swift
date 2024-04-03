import UIKit
import Firebase

struct Training {
    var name: String
    var isLiked: Bool
    var exercises: [ExerciseView]
}

struct ExerciseView {
    var name: String
    var repetitionCount: Int
}

class HistoryViewController: UITableViewController {
    var trainings: [Training] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.tableFooterView = UIView()
        
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        
        fetchTrainingsFromFirebase()
    }
    
    func fetchTrainingsFromFirebase() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let ref = Database.database().reference().child("users").child(userId).child("trainings")
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            var fetchedTrainings: [Training] = []
            
            for childSnapshot in snapshot.children {
                if let childSnapshot = childSnapshot as? DataSnapshot,
                   let trainingData = childSnapshot.value as? [String: Any],
                   let name = trainingData["name"] as? String,
                   let exercisesData = trainingData["exercises"] as? [[String: Any]] {
                    
                    var exercises: [ExerciseView] = []
                    
                    for exerciseData in exercisesData {
                        if let exerciseName = exerciseData["name"] as? String,
                           let repetitionCount = exerciseData["repetitionCount"] as? Int {
                            let exercise = ExerciseView(name: exerciseName, repetitionCount: repetitionCount)
                            exercises.append(exercise)
                        }
                    }
                    
                    let training = Training(name: name, isLiked: false, exercises: exercises)
                    fetchedTrainings.append(training)
                }
            }
            
            self?.trainings = fetchedTrainings
            self?.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let training = trainings[indexPath.row]
        let exercises = training.exercises
        
        // Открывает новый контроллер (например, ExerciseListViewController) и передает список упражнений
        let exerciseListViewController = ExerciseListViewController()
        exerciseListViewController.exercises = exercises
        navigationController?.pushViewController(exerciseListViewController, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! HistoryTableViewCell
        
        let training = trainings[indexPath.row]
        cell.titleLabel.text = training.name
        cell.likeButton.isSelected = training.isLiked
        
        cell.selectionStyle = .none
        
        cell.exercises = training.exercises
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        trainings[index].isLiked.toggle()
        
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}

class HistoryTableViewCell: UITableViewCell {
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = UIColor.red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var exercises: [ExerciseView]? {
        didSet {
            setupExerciseLabels()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
        
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.tintColor = UIColor.black
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24.0),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(likeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            likeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -48.0),
            likeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 24.0),
            likeButton.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }
    
    private func setupExerciseLabels() {
        guard let exercises = exercises else {
            return
        }
        
        for subview in containerView.subviews {
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
        
        var previousLabel: UILabel?
        
        for (index, exercise) in exercises.enumerated() {
            let exerciseLabel = UILabel()
            exerciseLabel.textColor = UIColor.black
            exerciseLabel.font = UIFont.systemFont(ofSize: 16.0)
            exerciseLabel.translatesAutoresizingMaskIntoConstraints = false
            exerciseLabel.text = "\(exercise.name) - \(exercise.repetitionCount)"
            
            containerView.addSubview(exerciseLabel)
            
            NSLayoutConstraint.activate([
                exerciseLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
                exerciseLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            ])
            
            if let previousLabel = previousLabel {
                NSLayoutConstraint.activate([
                    exerciseLabel.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 8.0)
                ])
            } else {
                NSLayoutConstraint.activate([
                    exerciseLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0)
                ])
            }
            
            previousLabel = exerciseLabel
            
            if index < exercises.count - 1 {
                let separatorView = UIView()
                separatorView.backgroundColor = UIColor.lightGray
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                separatorView.tag = 100
                containerView.addSubview(separatorView)
                
                NSLayoutConstraint.activate([
                    separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
                    separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
                    separatorView.heightAnchor.constraint(equalToConstant: 1.0),
                    separatorView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 8.0)
                ])
            }
        }
    }
}

