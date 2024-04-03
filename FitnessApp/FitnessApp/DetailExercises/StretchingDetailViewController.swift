import WebKit

class StretchingDetailViewController: UIViewController {
    var exercise: ExerciseStretch?
    var nameDescription: String?
    var exerciseDescription: String?
    var benefitsDescription: String?
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        scrollView.addSubview(contentView)
        
        let nameLabel = UILabel()
        nameLabel.text = nameDescription
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor(named: "Blue")
        nameLabel.font = UIFont.systemFont(ofSize: 30)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        
        if let urlString = exercise?.url, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView = WKWebView(frame: .zero)
            webView.load(request)
            webView.scrollView.isScrollEnabled = false
            webView.contentMode = .scaleAspectFit
            webView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(webView)
        }
        
        let descriptionTitleLabel = UILabel()
        descriptionTitleLabel.text = "Описание"
        descriptionTitleLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionTitleLabel.textColor = UIColor(named: "Blue")
        descriptionTitleLabel.textAlignment = .left
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionTitleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = exerciseDescription
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        let benefitsTitleLabel = UILabel()
        benefitsTitleLabel.text = "Польза"
        benefitsTitleLabel.textColor = UIColor(named: "Blue")
        benefitsTitleLabel.font = UIFont.systemFont(ofSize: 20)
        benefitsTitleLabel.textAlignment = .left
        benefitsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(benefitsTitleLabel)
        
        let benefitsLabel = UILabel()
        benefitsLabel.text = benefitsDescription
        benefitsLabel.textAlignment = .left
        benefitsLabel.numberOfLines = 0
        benefitsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(benefitsLabel)
        
        
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            webView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 1),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            benefitsTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            benefitsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            benefitsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            benefitsLabel.topAnchor.constraint(equalTo: benefitsTitleLabel.bottomAnchor, constant: 10),
            benefitsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            benefitsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            benefitsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ]
        NSLayoutConstraint.activate(scrollViewConstraints)
    }
    
}

