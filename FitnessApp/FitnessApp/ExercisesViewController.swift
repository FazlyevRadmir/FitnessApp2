import UIKit

protocol RectangularViewSetup {
    func setupRectangularView(mainView: UIView, imageView: UIImageView, rightView: UIView, label: UILabel, circles: [(String)])
}

extension RectangularViewSetup where Self: UIViewController {

    func setupRectangularView(mainView: UIView, imageView: UIImageView, rightView: UIView, label: UILabel, circles: [(String)]) {
        mainView.layer.cornerRadius = 30
        mainView.layer.borderWidth = 1
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainView.widthAnchor.constraint(equalToConstant: 350),
            mainView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        imageView.contentMode = .scaleAspectFit
        mainView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 280),
            imageView.heightAnchor.constraint(equalToConstant: 280)
        ])
        
        rightView.layer.cornerRadius = 20
        rightView.layer.borderWidth = 1
        rightView.layer.backgroundColor = UIColor(ciColor: .white).cgColor
        mainView.addSubview(rightView)
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        let circleDiameter: CGFloat = 55
        let circleSpacing: CGFloat = 15
        
        for (index, circle) in circles.enumerated() {
            let circleView = UIView()
            circleView.layer.cornerRadius = circleDiameter / 2
            circleView.backgroundColor = UIColor.clear
            circleView.layer.borderColor = UIColor.black.cgColor
            circleView.layer.borderWidth = 1
            circleView.translatesAutoresizingMaskIntoConstraints = false
            rightView.addSubview(circleView)
                      
            let circleLabel = UILabel()
            circleLabel.textAlignment = .center
            circleLabel.numberOfLines = 0
            circleLabel.textColor = .black
            circleLabel.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
            circleLabel.text = circle
            circleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            circleView.addSubview(circleLabel)
            circleLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true
            circleLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true

            NSLayoutConstraint.activate([
                circleView.topAnchor.constraint(equalTo: rightView.topAnchor, constant: (CGFloat(index) * (circleDiameter + circleSpacing)) + 20),
                circleView.centerXAnchor.constraint(equalTo: rightView.centerXAnchor),
                circleView.widthAnchor.constraint(equalToConstant: circleDiameter),
                circleView.heightAnchor.constraint(equalToConstant: circleDiameter)
            ])
        }

        
        NSLayoutConstraint.activate([
            rightView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            rightView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            rightView.widthAnchor.constraint(equalToConstant: 70),
            rightView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        mainView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
        ])

    }
}



class ExercisesViewController: UIViewController, RectangularViewSetup {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        setupViews()
    }
    

    private func setupViews() {
        view.backgroundColor = UIColor(named: "Background")
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        scrollView.isScrollEnabled = true

        
        setupTopView1(on: contentView)
        setupTopView2(on: contentView)
        setupTopView3(on: contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo:scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
    
    
    private func setupTopView1(on contentView: UIView) {
        let mainView = UIView()
        mainView.layer.borderColor = UIColor(named: "borderCardio")?.cgColor
        mainView.layer.backgroundColor = UIColor(named: "cardio")?.cgColor
        
        let imageView = UIImageView(image: UIImage(named: "cardio"))
        
        let rightView = UIView()
        rightView.layer.borderColor = UIColor(named: "borderCardio")?.cgColor
        
        let label = UILabel()
        label.text = "Всё тело"
        
        let circles: [(String)] = [
            ("8 упр."),
            ("300 ккл"),
            ("30 мин.")
        ]
        
        setupRectangularView(mainView: mainView, imageView: imageView, rightView: rightView, label: label, circles: circles)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            label.bottomAnchor.constraint(equalTo: mainView.topAnchor, constant: -20),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topView1Tapped))
        mainView.addGestureRecognizer(tapGesture)
        contentView.addSubview(mainView)
    }

    @objc private func topView1Tapped() {
        let viewController = BodyExercisesViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    private func setupTopView2(on contentView: UIView) {
        let mainView = UIView()
        mainView.layer.borderColor = UIColor(named: "borderStretch")?.cgColor
        mainView.layer.backgroundColor = UIColor(named: "stretching")?.cgColor
        
        let imageView = UIImageView(image: UIImage(named: "stretching"))
        
        let rightView = UIView()
        rightView.layer.borderColor = UIColor(named: "borderStretch")?.cgColor
        
        let label = UILabel()
        label.text = "Стретчинг"
        
        let circles: [(String)] = [
            ("8 упр."),
            ("300 ккл"),
            ("45 мин.")
        ]
        
        setupRectangularView(mainView: mainView, imageView: imageView, rightView: rightView, label: label, circles: circles)
    
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 420),
            label.bottomAnchor.constraint(equalTo: mainView.topAnchor, constant: -20),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topView2Tapped))
        mainView.addGestureRecognizer(tapGesture)
        contentView.addSubview(mainView)
    }
    
    @objc private func topView2Tapped() {
        let viewController = StretchingViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupTopView3(on contentView: UIView) {
        let mainView = UIView()
        mainView.layer.borderColor = UIColor(named: "borderWorkOut")?.cgColor
        mainView.layer.backgroundColor = UIColor(named: "workOut")?.cgColor
        
        let imageView = UIImageView(image: UIImage(named: "workOut"))
        
        let rightView = UIView()
        rightView.layer.borderColor = UIColor(named: "borderWorkOut")?.cgColor
        
        let label = UILabel()
        label.text = "Разминка"
        
        let circles: [(String)] = [
            ("8 упр."),
            ("200 ккл"),
            ("20 мин.")
        ]
        
        setupRectangularView(mainView: mainView, imageView: imageView, rightView: rightView, label: label, circles: circles)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 740),
            label.bottomAnchor.constraint(equalTo: mainView.topAnchor, constant: -20),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topView3Tapped))
        mainView.addGestureRecognizer(tapGesture)
        contentView.addSubview(mainView)
    }
    
    @objc private func topView3Tapped() {
        let viewController = WarmUpViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
