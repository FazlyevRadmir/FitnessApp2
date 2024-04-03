import UIKit

enum Tabs: Int {
    case profile
    case history
    case maps
    case train
}
                

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        generateTabBar()

    }
    
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: ActivityViewController(),
                image: UIImage(named: "main")
            ),
            generateVC(
                viewController: TrainViewController(),
                image: UIImage(named: "training")
            ),
            generateVC(
                viewController: MapsViewController(),
                image: UIImage(named: "maps")
            ),
            generateVC(
                viewController: ProfileViewController(),
                image: UIImage(named: "profile")
            ),
        ]
        tabBar.isTranslucent = false
    }

    
    private func generateVC(viewController: UIViewController, image: UIImage?) -> UIViewController{
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem.image = image
        return navigationController
    }
}

