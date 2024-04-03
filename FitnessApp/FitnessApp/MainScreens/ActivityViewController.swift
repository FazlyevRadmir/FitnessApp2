import UIKit
import CoreMotion

class ActivityViewController: UIViewController {
    
    
    let topView1 = UIView()
    let topView2 = UIView()
    let bottomView = UIView()
    
    private let waterImageView = UIImageView()
    private let waterProgressLayer = CAShapeLayer()
    private let waterProgressBackgroundLayer = CAShapeLayer()
    private let waterCounterLabel = UILabel()
    private let editButton = UIButton()
    private let waterTargetLabel = UILabel()
    
    private var currentWaterAmount: Float = 0
    private var targetWaterAmount: Float = 2000
    
    
    let pedometer = CMPedometer()
    let pedometerImageView = UIImageView()
    let pedometerProgressLayer = CAShapeLayer()
    let pedometerProgressBackgroundLayer = CAShapeLayer()
    let pedometerCounterLabel = UILabel()
    let pedometerTargetLabel = UILabel()
    let peometerEditButton = UIButton()
    
    private var currentPedometerCount: Float = 0
    private var targetPedometerCount: Float = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = Calendar.current
        let currentDate = Date()

        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)
        dateComponents.hour = 24
        dateComponents.minute = 0

        let resetDate = calendar.date(from: dateComponents)

        let timer = Timer(fireAt: resetDate!, interval: 0, target: self, selector: #selector(resetCounters), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { [weak self] (pedometerData, error) in
                guard let self = self, let pedometerData = pedometerData else { return }
                DispatchQueue.main.async {
                    self.currentPedometerCount = pedometerData.numberOfSteps.floatValue
                    self.updatePedometerCounterLabel()
                    self.updatePedometerProgressView()
                }
            }
        } else {
            print("Step counting is not available")
        }
        
        setupViews()
        setupConstraints()
        updateWaterProgressView()
    //  loadData()
        
    }
    
//    func saveData() {
//        let defaults = UserDefaults.standard
//        defaults.set(currentWaterAmount, forKey: "WaterAmount")
//        defaults.set(currentPedometerCount, forKey: "PedometerCount")
//    }
    
//    func loadData() {
//        let defaults = UserDefaults.standard
//
//        if let waterAmount = defaults.value(forKey: "WaterAmount") as? Float {
//            currentWaterAmount = waterAmount
//        }
//
//        if let pedometerCount = defaults.value(forKey: "PedometerCount") as? Float {
//            currentPedometerCount = pedometerCount
//        }
//    }
    
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "Background")
        setupTopView1()
        setupTopView2()
        setupBottomView()
    }
    
    private func setupTopView1() {
        
        topView1.backgroundColor = UIColor(named: "Background")
        topView1.layer.cornerRadius = 20
        topView1.layer.borderWidth = 3
        topView1.layer.borderColor = UIColor(named: "Green")?.cgColor
        
        let pedometerCounterLabel = UILabel()
        pedometerCounterLabel.text = "Шагомер"
        pedometerCounterLabel.textColor = UIColor(named: "Green")
        pedometerCounterLabel.font = UIFont.boldSystemFont(ofSize: 24)
        topView1.addSubview(pedometerCounterLabel)
        pedometerCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pedometerTargetLabel.text = "\(currentPedometerCount) шагов"
        pedometerTargetLabel.textColor = UIColor(named: "Green")
        topView1.addSubview(pedometerTargetLabel)
        pedometerTargetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pedometerImageView.image = UIImage(systemName: "figure.walk")
        pedometerImageView.tintColor = UIColor(named: "Green")
        pedometerImageView.contentMode = .scaleAspectFit
        pedometerImageView.bounds.size = CGSize(width: 100, height: 100)
        topView1.addSubview(pedometerImageView)
        pedometerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        peometerEditButton.setTitle("Добавить", for: .normal)
        peometerEditButton.setTitleColor(UIColor(named: "Green"), for: .normal)
        peometerEditButton.addTarget(self, action: #selector(pedometerEditButtonTapped), for: .touchUpInside)
        topView1.addSubview(peometerEditButton)
        peometerEditButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupPedometerProgressLayer()
        updatePedometerCounterLabel()
        
        NSLayoutConstraint.activate([
            pedometerCounterLabel.centerXAnchor.constraint(equalTo: topView1.centerXAnchor),
            pedometerCounterLabel.topAnchor.constraint(equalTo: topView1.topAnchor, constant: 20),
            
            pedometerImageView.centerXAnchor.constraint(equalTo: topView1.centerXAnchor),
            pedometerImageView.bottomAnchor.constraint(equalTo: pedometerCounterLabel.topAnchor, constant: 150),
            pedometerImageView.widthAnchor.constraint(equalToConstant: 100),
            pedometerImageView.heightAnchor.constraint(equalToConstant: 100),
            
            
            pedometerTargetLabel.centerXAnchor.constraint(equalTo: topView1.centerXAnchor),
            pedometerTargetLabel.topAnchor.constraint(equalTo: pedometerImageView.bottomAnchor, constant: 20),
            
            peometerEditButton.centerXAnchor.constraint(equalTo: topView1.centerXAnchor),
            peometerEditButton.bottomAnchor.constraint(equalTo: topView1.bottomAnchor, constant: -10),
        ])
        
        
        updateWaterCounterLabel()
    }
    
    private func setupPedometerProgressLayer() {
        let lineWidth: CGFloat = 10.0
        let radius = min(pedometerImageView.bounds.width, pedometerImageView.bounds.height) / 1.75
        let centerX = pedometerImageView.bounds.width / 2
        let centerY = pedometerImageView.bounds.height / 2
        let center = CGPoint(x: centerX, y: centerY)
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let backgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        pedometerProgressBackgroundLayer.path = backgroundPath.cgPath
        pedometerProgressBackgroundLayer.fillColor = UIColor.clear.cgColor
        pedometerProgressBackgroundLayer.lineWidth = lineWidth
        pedometerImageView.layer.addSublayer(pedometerProgressBackgroundLayer)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        pedometerProgressLayer.path = path.cgPath
        pedometerProgressLayer.strokeColor = UIColor(named: "Green")?.cgColor
        pedometerProgressLayer.fillColor = UIColor.clear.cgColor
        pedometerProgressLayer.lineWidth = lineWidth
        pedometerProgressLayer.strokeEnd = 0.0
        pedometerImageView.layer.addSublayer(pedometerProgressLayer)
    }
    
    @objc private func startPedometerUpdates() {
        if currentPedometerCount > targetPedometerCount {
            targetPedometerCount = currentPedometerCount
        }
        guard CMPedometer.isStepCountingAvailable() else { return }
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: Date())
        pedometer.startUpdates(from: midnight) { [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            DispatchQueue.main.async {
                self?.currentPedometerCount = Float(pedometerData.numberOfSteps.intValue)
                self?.updatePedometerCounterLabel()
            }
        }
    }
    
    @objc private func pedometerEditButtonTapped() {
        let alertController = UIAlertController(title: "Сколько шагов вы хотите пройти сегодня?", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Добавить (шагов)"
            textField.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction(title: "Выйти", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            if let targetString = alertController.textFields?.first?.text, let target = Float(targetString) {
                self?.targetPedometerCount = target
                self?.updatePedometerCounterLabel()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func updatePedometerCounterLabel() {
        let formattedCurrentWaterAmount = String(format: "%.0f", currentPedometerCount)
        let formattedTargetWaterAmount = String(format: "%.0f", targetPedometerCount)
        pedometerTargetLabel.text = "\(formattedCurrentWaterAmount)/\(formattedTargetWaterAmount) шагов"
    }
    
    private func updatePedometerProgressView() {
        let progress = currentPedometerCount / targetPedometerCount
        pedometerProgressLayer.strokeEnd = CGFloat(progress)
    }
    
    private func setupTopView2() {
        
        topView2.backgroundColor = UIColor(named: "Background")
        topView2.layer.cornerRadius = 20
        topView2.layer.borderWidth = 3
        topView2.layer.borderColor = UIColor(named: "Blue")?.cgColor
        
        let plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        plusButton.tintColor = UIColor(named: "Blue")
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        topView2.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        let waterCounterLabel = UILabel()
        waterCounterLabel.text = "Трекер воды"
        waterCounterLabel.textColor = UIColor(named: "Blue")
        waterCounterLabel.font = UIFont.boldSystemFont(ofSize: 24)
        topView2.addSubview(waterCounterLabel)
        waterCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        waterTargetLabel.text = "\(currentWaterAmount) мл"
        waterTargetLabel.textColor = UIColor(named: "Blue")
        topView2.addSubview(waterTargetLabel)
        waterTargetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        waterImageView.image = UIImage(systemName: "drop")
        waterImageView.contentMode = .scaleAspectFit
        waterImageView.bounds.size = CGSize(width: 100, height: 100)
        topView2.addSubview(waterImageView)
        waterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        editButton.setTitle("Добавить", for: .normal)
        editButton.setTitleColor(UIColor(named: "Blue"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        topView2.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        setupWaterProgressLayer()
        updateWaterCounterLabel()
        
        
        NSLayoutConstraint.activate([
            waterCounterLabel.centerXAnchor.constraint(equalTo: topView2.centerXAnchor),
            waterCounterLabel.topAnchor.constraint(equalTo: topView2.topAnchor, constant: 20),
            
            waterImageView.centerXAnchor.constraint(equalTo: topView2.centerXAnchor),
            waterImageView.bottomAnchor.constraint(equalTo: waterCounterLabel.topAnchor, constant: 150),
            waterImageView.widthAnchor.constraint(equalToConstant: 100),
            waterImageView.heightAnchor.constraint(equalToConstant: 100),
            
            
            waterTargetLabel.centerXAnchor.constraint(equalTo: topView2.centerXAnchor),
            waterTargetLabel.topAnchor.constraint(equalTo: waterImageView.bottomAnchor, constant: 20),
            
            plusButton.centerXAnchor.constraint(equalTo: topView2.centerXAnchor),
            plusButton.topAnchor.constraint(equalTo: waterTargetLabel.bottomAnchor, constant: 10),
            
            editButton.centerXAnchor.constraint(equalTo: topView2.centerXAnchor),
            editButton.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 10),
            editButton.bottomAnchor.constraint(equalTo: topView2.bottomAnchor, constant: -10),
        ])
        
        updateWaterCounterLabel()
    }
    
    
    private func setupWaterProgressLayer() {
        let lineWidth: CGFloat = 10.0
        let radius = min(waterImageView.bounds.width, waterImageView.bounds.height) / 1.75
        let centerX = waterImageView.bounds.width / 2
        let centerY = waterImageView.bounds.height / 2
        let center = CGPoint(x: centerX, y: centerY)
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let backgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        waterProgressBackgroundLayer.path = backgroundPath.cgPath
        waterProgressBackgroundLayer.fillColor = UIColor.clear.cgColor
        waterProgressBackgroundLayer.lineWidth = lineWidth
        waterImageView.layer.addSublayer(waterProgressBackgroundLayer)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        waterProgressLayer.path = path.cgPath
        waterProgressLayer.strokeColor = UIColor(named: "Blue")?.cgColor
        waterProgressLayer.fillColor = UIColor.clear.cgColor
        waterProgressLayer.lineWidth = lineWidth
        waterProgressLayer.strokeEnd = 0.0
        waterImageView.layer.addSublayer(waterProgressLayer)
    }
    
    @objc private func plusButtonTapped() {
        currentWaterAmount += 200
        if currentWaterAmount > targetWaterAmount {
            targetWaterAmount = currentWaterAmount
        }
        let progress = currentWaterAmount / targetWaterAmount
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = waterProgressLayer.strokeEnd
        animation.toValue = progress
        animation.duration = 0.1
        waterProgressLayer.strokeEnd = CGFloat(progress)
        waterProgressLayer.add(animation, forKey: "waterProgress")
        updateWaterCounterLabel()
    }
    
    @objc private func editButtonTapped() {
        let alertController = UIAlertController(title: "Сколько воды вы хотите выпить сегодня?", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Добавить (мл)"
            textField.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction(title: "Выйти", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            if let targetString = alertController.textFields?.first?.text, let target = Float(targetString) {
                self?.targetWaterAmount = target
                self?.updateWaterCounterLabel()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateWaterCounterLabel() {
        let formattedCurrentWaterAmount = String(format: "%.0f", currentWaterAmount)
        let formattedTargetWaterAmount = String(format: "%.0f", targetWaterAmount)
        waterTargetLabel.text = "\(formattedCurrentWaterAmount)/\(formattedTargetWaterAmount) мл"
    }
    
    @objc private func resetCounters() {
        currentWaterAmount = 0
        currentPedometerCount = 0
        updateWaterCounterLabel()
        updatePedometerCounterLabel()
    }
    
    private func updateWaterProgressView() {
        let progress = currentWaterAmount / targetWaterAmount
        waterProgressLayer.strokeEnd = CGFloat(progress)
    }
    
    private func setupBottomView() {
        bottomView.backgroundColor = UIColor(named: "Background")
        bottomView.layer.cornerRadius = 20
        bottomView.layer.borderWidth = 3
        bottomView.layer.borderColor = UIColor(named: "Blue")?.cgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        saveData()
    }

    
    private func setupConstraints() {
        view.addSubview(topView1)
        view.addSubview(topView2)
        view.addSubview(bottomView)
        topView1.translatesAutoresizingMaskIntoConstraints = false
        topView2.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5),
            topView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            topView1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -15),
            topView1.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            topView2.topAnchor.constraint(equalTo: topView1.topAnchor),
            topView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            topView2.widthAnchor.constraint(equalTo: topView1.widthAnchor),
            topView2.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -10),
        ])
        
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bottomView.heightAnchor.constraint(equalTo: topView1.heightAnchor),
            
        ])
    }
    
}
