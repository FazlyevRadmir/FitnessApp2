import UIKit
import WebKit
import AVFoundation

struct WarmUp: Codable {
    let url: String
    let repetitions: Int?
}


class TrainWarmupViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    var exercises: [WarmUp] = []
    var currentExerciseIndex = 0
    var imageView: UIImageView?
    let buttonNext = UIButton()
    let buttonPrevious = UIButton()
    let containerView = UIView()
    let webView = WKWebView()
    let startButton = UIButton()
    let repetitionsLabel = UILabel()
    let stopButton = UIButton()
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var currentRepetitionCount = 0
    var currentExerciseCount = 0
    
    var countDownTimer: Timer?
    var countDownSeconds = 0
    
    var restTimer: Timer?
    let restDuration = 10
    var restCountdownSpeechTimer: Timer?
    var restCountDownSeconds = 0
    var currentExerciseDuration: TimeInterval = 0
    
    var exerciseRestTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Background")
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        backButton.target = self
        backButton.action = #selector(backButtonTapped)
        
        containerView.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: view.bounds.width - 40)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor(named: "Green")?.cgColor
        view.addSubview(containerView)
        
        repetitionsLabel.textAlignment = .center
        repetitionsLabel.textColor = .black
        repetitionsLabel.font = UIFont.systemFont(ofSize: 24)
        repetitionsLabel.tag = 999
        repetitionsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(repetitionsLabel)

        NSLayoutConstraint.activate([
            repetitionsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            repetitionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repetitionsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            repetitionsLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    
        
        webView.frame = containerView.bounds
        webView.contentMode = .scaleAspectFit
        containerView.addSubview(webView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(webView)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.backgroundColor = UIColor(named: "Blue")
        startButton.layer.cornerRadius = 20
        startButton.setTitle("Старт", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)
        
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.backgroundColor = UIColor(named: "Blue")
        stopButton.layer.cornerRadius = 20
        stopButton.setTitle("Стоп", for: .normal)
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        view.addSubview(stopButton)
        
        buttonPrevious.translatesAutoresizingMaskIntoConstraints = false
        buttonPrevious.backgroundColor = UIColor(named: "Blue")
        buttonPrevious.layer.cornerRadius = 40
        buttonPrevious.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        buttonPrevious.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        view.addSubview(buttonPrevious)
        
        buttonNext.translatesAutoresizingMaskIntoConstraints = false
        buttonNext.backgroundColor = UIColor(named: "Blue")
        buttonNext.layer.cornerRadius = 40
        buttonNext.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        buttonNext.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(buttonNext)
        
        NSLayoutConstraint.activate([
            
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            startButton.widthAnchor.constraint(equalToConstant: 160),
            startButton.heightAnchor.constraint(equalToConstant: 80),

            stopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            stopButton.widthAnchor.constraint(equalToConstant: 160),
            stopButton.heightAnchor.constraint(equalToConstant: 80),

            buttonPrevious.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonPrevious.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            buttonPrevious.widthAnchor.constraint(equalToConstant: 80),
            buttonPrevious.heightAnchor.constraint(equalToConstant: 80),

            buttonNext.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            buttonNext.widthAnchor.constraint(equalToConstant: 80),
            buttonNext.heightAnchor.constraint(equalToConstant: 80)
        ])


        speechSynthesizer.delegate = self
        
        loadExercises()
        startExercise()
    }
    
    private func loadExercises() {
        guard let url = Bundle.main.url(forResource: "warm-up", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([String: [WarmUp]].self, from: data)
            exercises = decodedData["exercises"] ?? []
        } catch {
            print(error)
        }
    }
    
    private func startExercise() {
        guard currentExerciseIndex < exercises.count else {
            return
        }
        
        let exercise = exercises[currentExerciseIndex]
        
        if let url = URL(string: exercise.url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        currentRepetitionCount = 0
        currentExerciseCount = 0
        currentExerciseDuration = 0
        
        if let repetitions = exercise.repetitions {
            repetitionsLabel.text = "Количество повторений: \(repetitions)"
        } else {
            repetitionsLabel.text = ""
        }
        
        if currentExerciseIndex > 0 {
            startCountDownTimer()
        }
    }

    
    @objc private func startButtonTapped() {
        stopTimer()
        if currentExerciseIndex > 0 {
            speak(text: "Приготовьтесь")
        }
        startCountDownTimer()
    }

    
    @objc private func stopButtonTapped() {
        stopTimer()
    }
    
    private func startCountDownTimer() {
        stopTimer()
        guard currentExerciseIndex < exercises.count else {
            return
        }
        
        let exercise = exercises[currentExerciseIndex]
        
        let repetitions = exercise.repetitions ?? 0
        currentRepetitionCount = 0
        currentExerciseCount = 0
        
        countDownTimer?.invalidate()
        countDownSeconds = 0
        
        if currentRepetitionCount == 0 && currentExerciseCount == 0 {
            speak(text: "Приготовьтесь")
        }
        
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.countDownSeconds += 3
            
            if self.countDownSeconds % 3 == 0 {
                if self.currentRepetitionCount < repetitions {
                    self.currentRepetitionCount += 1
                    self.speak(text: "\(self.currentRepetitionCount)")
                    
                    if self.currentRepetitionCount == repetitions {
                        self.speak(text: "Отдохните 10 секунд")
                        self.restCountDownSeconds = self.restDuration
                        self.restCountdownSpeechTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                            self?.speak(text: "\(self?.restCountDownSeconds ?? 0)")
                            self?.restCountDownSeconds -= 1
                            if self?.restCountDownSeconds == 0 {
                                timer.invalidate()
                                self?.exerciseRestTimer?.invalidate()
                                self?.playNextExercise()
                            }
                        }
                    }
                } else {
                    if self.currentExerciseCount == 0 {
                        self.playNextExercise()
                    }
                }
            }
        }
    }
    
    private func stopTimer() {
        countDownTimer?.invalidate()
        countDownTimer = nil
        
        restTimer?.invalidate()
        restTimer = nil
        
        restCountdownSpeechTimer?.invalidate()
        restCountdownSpeechTimer = nil
    }
    
    private func playNextExercise() {
        stopTimer()
        
        currentExerciseIndex += 1
        
        if currentExerciseIndex < exercises.count {
            startExercise()
        } else {
            showExerciseFinishedAlert()
        }
    }
    
    private func showExerciseFinishedAlert() {
        let alert = UIAlertController(title: "Тренировка завершена", message: "Вы выполнили все упражнения", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func previousButtonTapped() {
        currentExerciseIndex -= 1
        
        if currentExerciseIndex >= 0 {
            startExercise()
        } else {
            currentExerciseIndex = 0
        }
    }
    
    @objc private func nextButtonTapped() {
        currentExerciseIndex += 1
        
        if currentExerciseIndex < exercises.count {
            startExercise()
        } else {
            currentExerciseIndex = exercises.count - 1
        }
    }
    
    private func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if utterance.speechString == "Приготовьтесь" {
            currentExerciseCount += 1
            if let repetitions = exercises[currentExerciseIndex].repetitions {
                speak(text: " \(repetitions) повторений")
            }
        }
    }
}


