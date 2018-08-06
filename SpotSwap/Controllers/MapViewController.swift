import UIKit
import MapKit
import CoreLocation
import UserNotifications
protocol MenuContainerDelegate: class {
    func triggerMenu()
}


class MapViewController: UIViewController {
    
    // MARK: - Properties
    private var initialLaunch = true
    private var contentView = MapView()
    private var addSpotView = AddSpotView()
    private var pushNotificationService: PushNotificationService!
    var menuContainerDelegate: MenuContainerDelegate?
    private var newSpot: Spot?
    // This is basically an instance of the current vehicle owner in a class that have some functions that helps in controlling the flow of the vehicleOwner operations.
    var vehicleOwnerService: VehicleOwnerService!

    private var minutes = ["3","4","5", "6", "7", "8", "9", "10"]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupContentView()
        setupServices()
        setupDelegates()
    }
    
    // MARK: - Setup - View/Data
    private func setupNavigationBar() {
        let labelView = UILabel()
        labelView.text = "Spot Swap"
        labelView.font = UIFont(name: Stylesheet.Fonts.Bold, size: 20)
        labelView.textColor = Stylesheet.Colors.White
        navigationItem.titleView = labelView
        navigationController?.navigationBar.barTintColor = Stylesheet.Contexts.NavigationController.BarColor
        let listNavigationItem = UIBarButtonItem(image: #imageLiteral(resourceName: "listIcon"), style: .plain, target: self, action: #selector(handleMenu(_:)))
        listNavigationItem.tintColor = .white
        navigationItem.leftBarButtonItem = listNavigationItem
        // Removes the gloss that makes the nav bar a different shade of the UIColor assigned to it
        navigationController?.navigationBar.isTranslucent = false
        // Removes 1px border line at the bottom of the nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    private func setupDelegates() {
        LocationService.manager.setDelegate(viewController: self)
        self.contentView.reservationViewDelegate = self
        self.addSpotView.pickerView.delegate = self
        self.addSpotView.pickerView.dataSource = self
        self.addSpotView.delegate = self
//        self.pushNotificationService.unNotificationCenter.delegate = self
    }
    
    private func setupContentView() {
        contentView = MapView(viewController: self)
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
    }
    private func setupAddSpotView(){
        view.addSubview(addSpotView)
        addSpotView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
    private func setupServices() {
        vehicleOwnerService = VehicleOwnerService(self)
        pushNotificationService = PushNotificationService(viewControllerConformsToUNUserNotificationCenterDelegate: self)
    }

}

// MARK: - Map Helper Functions
private extension MapViewController {
    func setMapRegion(around location: CLLocation) {
        if initialLaunch {
            let regionArea = 0.02 // smaller is more zoomed in
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: regionArea, longitudeDelta: regionArea))
            contentView.mapView.setRegion(region, animated: true)
            initialLaunch = false
        }
    }
    
    func addRoute(mapView: MKMapView, spotLocation:CLLocationCoordinate2D, userLocation:CLLocationCoordinate2D ) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: spotLocation))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            guard let unwrappedResponse = response else { return }
            for route in unwrappedResponse.routes {
                mapView.add(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    
}

// MARK: - Delegates
// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    // Create the pins and the detail view when the pin is tapped
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Show blue dot for user's current location
        if annotation is MKUserLocation {return nil}
        // Get instance of annotationView so we can modify color
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MapAnnotationView
        if pin == nil {
            pin = MapAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        }
        
        // Handle if the annotation comes from an open spot, my vehicle location or a spot the user reserved
        pin?.annotation = annotation
        return pin
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = Stylesheet.Colors.BlueMain
            renderer.lineWidth = 2
            renderer.lineCap = .round
            renderer.lineJoin = .round
            renderer.lineDashPattern = [2, 2]
            return renderer
        }
        return MKOverlayRenderer()
    }
}

// MARK: - LocationServiceDelegate
extension MapViewController: LocationServiceDelegate {
    func userLocationDidUpdate(_ userLocation: CLLocation) {
        LocationService.manager.setUserLocation(userLocation)
        setMapRegion(around: userLocation)
    }
    
    func spotsUpdatedFromFirebase(_ spots: [Spot]) {
        guard let vehicleOwner = vehicleOwnerService.getVehicleOwner() else {return}
        guard vehicleOwner.reservationId != nil else{
            // Refactor. Should add and remove individual annotation
            contentView.mapView.removeAnnotations(contentView.mapView.annotations)
            contentView.mapView.addAnnotations(spots)
            return
        }
    }
}

// MARK: - MapViewGestureDelegate
extension MapViewController: MapViewGestureDelegate {
    func mapViewWasLongPressed(at location: CLLocationCoordinate2D) {
        guard userHasNoSpots() else {
            print(#function, "Error: User has a spot already.")
            Alert.present(from: .userHasSpot)
            return
        }
        setupAddSpotView()
        self.newSpot = Spot(location: location)
    }
}

// MARK: - VehicleOwnerServiceDelegate
extension MapViewController: VehicleOwnerServiceDelegate {
    func vehicleOwnerRetrieved() {
    }
    func vehiclOwnerRemoveReservation(_ reservationId: Reservation) {
        //To Do remove the reservationView if it is on the mainView and load all the spots back
    }
    func vehicleOwnerSpotReserved(reservationId: String, currentVehicleOwner: VehicleOwner) {
        DataBaseService.manager.retrieveReservation(reservationId: reservationId, dataBaseObserveType: .singleEvent, completion: { reservation in
            //Adding annotaion for the reservation
            let reservationAnnotation = MKPointAnnotation()
            reservationAnnotation.coordinate = CLLocationCoordinate2D(latitude: reservation.latitude, longitude: reservation.longitude)
            self.contentView.mapView.removeAnnotations(self.contentView.mapView.annotations)
            self.contentView.mapView.addAnnotation(reservationAnnotation)
            //This will check to setup the reservationDetailView a. if the current user is the spot owner or b. if the current user is the reserver
            if reservation.takerId == currentVehicleOwner.userUID {
                DataBaseService.manager.retrieveVehicleOwner(vehicleOwnerId: reservation.spotOwnerId, dataBaseObserveType: .singleEvent, completion: {(vehicleOwnerTaker) in
                    let mapView = self.contentView.mapView
                    let userLocation = mapView.userLocation.coordinate
                    self.contentView.showReservationView(with: vehicleOwnerTaker, reservation: reservation)
                    self.addRoute(mapView: mapView, spotLocation: reservationAnnotation.coordinate, userLocation: userLocation)
                }, errorHandler: { (error) in
                    //this will give an alert to the user in case the taker data can't be retrieved
                    self.alertWithOkButton(title: "there was an error retrieving your matched spot taker", message: nil)
                    return
                })
            } else {
                DataBaseService.manager.retrieveVehicleOwner(vehicleOwnerId: reservation.takerId, dataBaseObserveType: .singleEvent, completion: {(spotOwnerVehicleOwner) in
                    self.pushNotificationService.triggerReservationNotification(vehicleOwner: spotOwnerVehicleOwner, trigerDuration: 0.1, reservation: reservation, errorHandler: { (error) in
                    })
                    self.contentView.showReservationView(with: spotOwnerVehicleOwner, reservation: reservation)
                }, errorHandler: { (error) in
                    //this will give an alert to the user in case the taker data can't be retrieved
                    self.alertWithOkButton(title: "there was an error retrieving your matched spot owner", message: nil)
                    return
                })
            }
            // Here we need to a. setup the reservationView for the reserver and for the spot owner b. clear all the map from anotation c. have a cancel button to cancel the whole reservation and retrieve back the normal map
            
        }) { (error) in
            print(error)
        }
    }
    private func alertWithOkButton(title: String, message: String?){
        let alerViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerViewController.addAction(okAction)
        self.present(alerViewController, animated: true, completion: nil)
    }
    
    func vehiclOwnerHasNoReservation() {
        if contentView.reservationHeaderView.isDescendant(of: contentView){
            self.pushNotificationService.triggerCompletedNotification(trigerDuration: 0.1, errorHandler: { (error) in
                print(error)
            })
//            alertWithOkButton(title: "Reservation was canceled or completed", message: nil)
            contentView.removeReservationDetailsFromMap()
        }
    }
}

//MARK: - DetailReservation Delegate
extension MapViewController: ReservationViewDelegate {
    func reservationExpired() {
        alertWithOkButton(title: "Your Reservation is expired", message: nil)
        completeReservation()
    }
    
    func cancelReservation() {
        reservationCancelationHelper()
    }
    
    func completeReservation() {
        vehicleOwnerService.removeReservation { (reservation) in
            self.contentView.removeReservationDetailsFromMap()
        }
    }
    
    private func reservationCancelationHelper() {
        let cancelationAlert = UIAlertController(title: "Are you sure you want to cancel", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            //TODO Handle Flagging
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (cancelForNoReason) in
            //            self.completeReservation()
        }
        let reportButton = UIAlertAction(title: "Yes", style: .destructive) { (reportUserAction) in
            //TODO Handle Flagging
            self.completeReservation()
        }
        cancelationAlert.addAction(cancelAction)
        cancelationAlert.addAction(noAction)
        cancelationAlert.addAction(reportButton)
        self.present(cancelationAlert, animated: true, completion: nil)
    }
    
}


//MARK: - Menu ContainerDelegate Delegate
extension MapViewController {
    @objc private func handleMenu(_ sender: UIBarButtonItem){
        addSpotView.removeFromSuperview()
        menuContainerDelegate?.triggerMenu()
    }
}

//MARK: - ExampleCalloutView Delegate
extension MapViewController: MapCalloutViewDelegate {
    func calloutSpotExpired() {
        alertWithOkButton(title: "Current Spot has Expired", message: nil)
        LocationService.manager.addSpotsFromFirebaseToMap()
    }
    
    func cancelButtonPressed(spot: Spot) {
        DataBaseService.manager.removeSpot(spotId: spot.spotUID)
    }
    
    func reserveButtonPressed(spot: Spot) {
        print("Reserved")
        vehicleOwnerService.reserveSpot(spot)
    }
}

//MARK: - AddSpot time Duration PickerView DataSource  Delegates
extension MapViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return minutes[row]
    }
}

//MARK: - AddSpotView Delegate
extension MapViewController: AddSpotDelegate {

    func addSpotButtonClicked() {
        let duration = minutes[addSpotView.pickerView.selectedRow(inComponent: 0)]
        guard let newSpot = newSpot else {return}
        newSpot.duration = duration
        DataBaseService.manager.addSpot(spot: newSpot)
        self.addSpotView.removeFromSuperview()
        guard let durationTimeInterval = TimeInterval(duration) else {
            return
        }
        pushNotificationService.triggerExpiredSpotNotification(trigerDuration: durationTimeInterval*60, errorHandler: { (error) in
            print(error.localizedDescription)
        }, spot: newSpot)
    }
    
    func userHasNoSpots() -> Bool {
        let spotsCreatedByCurrentUser = contentView.mapView.annotations.filter({ annotation -> Bool in
            if let spot = annotation as? Spot {
                if spot.userUID == vehicleOwnerService.getVehicleOwner()?.userUID {
                    return true
                }
                return false
            }
            return false
        })
        
        return spotsCreatedByCurrentUser.isEmpty
    }

    
}
//MARK: - Notification Center delegate and Functions

extension MapViewController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
    
}

