import UIKit

class ExerciseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var exercises: [ExerciseView]?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExerciseTableViewCell.self, forCellReuseIdentifier: "ExerciseCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseTableViewCell
        
        if let exercise = exercises?[indexPath.row] {
            cell.nameLabel.text = exercise.name
            cell.repetitionLabel.text = "\(exercise.repetitionCount)"
        }
        
        return cell
    }
}

class ExerciseTableViewCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repetitionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLabel)
        addSubview(repetitionLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            
            repetitionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            repetitionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
            repetitionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            repetitionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
