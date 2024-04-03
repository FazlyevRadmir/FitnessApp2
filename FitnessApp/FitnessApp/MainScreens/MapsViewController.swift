import UIKit
import MapKit

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var mapView: MKMapView!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(image: UIImage(systemName: "location.fill"), style: .plain, target: self, action: #selector(centerMapOnUserButtonClicked))
            navigationItem.rightBarButtonItem = button

        mapView = MKMapView(frame: view.frame)
        mapView.delegate = self
        view.addSubview(mapView)

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        let gym1 = Gym(name: "ReФорма", latitude: 55.838617, longitude: 49.041160)
        let gym2 = Gym(name: "Xfit АК Барс", latitude: 55.811816, longitude: 49.136253)
        let gym3 = Gym(name: "Планета Фитнес", latitude: 55.815458, longitude: 49.129977)
        let gym4 = Gym(name: "Олимп", latitude: 55.820202, longitude: 49.139562)
        let gym5 = Gym(name: "Fmom", latitude: 55.817365, longitude: 49.137280)
        let gym6 = Gym(name: "Alter Ego", latitude: 55.791916, longitude: 49.156818)
        let gym7 = Gym(name: "Габби Спорт", latitude: 55.778892, longitude: 49.136723)
        let gym8 = Gym(name: "360 Аit EMS", latitude: 55.759167, longitude: 49.177614)
        let gym9 = Gym(name: "Zumba", latitude: 55.748802, longitude: 49.196138)
        let gym10 = Gym(name: "Smart Fit", latitude: 55.746740, longitude: 49.206064)

        let gyms = [gym1, gym2, gym3, gym4, gym5, gym6, gym7, gym8, gym9, gym10]

        for gym in gyms {
            let annotation = MKPointAnnotation()
            annotation.title = gym.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: gym.latitude, longitude: gym.longitude)

            mapView.addAnnotation(annotation)
        }
    }

    //MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }

    //MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "marker"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    @objc func centerMapOnUserButtonClicked() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
}

// Модель спортзала
class Gym {
    let name: String
    let latitude: Double
    let longitude: Double

    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
