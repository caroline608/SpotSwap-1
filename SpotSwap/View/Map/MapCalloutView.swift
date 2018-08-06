import UIKit
import MapKit
import SnapKit

protocol MapCalloutViewDelegate: class {
    func reserveButtonPressed(spot: Spot)
    func cancelButtonPressed(spot:Spot)
    func calloutSpotExpired()
}

class MapCalloutView: CalloutView {
    
    // MARK: - Properties
    // Map View - Navigate up view hierarchy until we find `MKMapView`.
    private var mapView: MapView? {
        var view = superview
        while view != nil {
            if let mapView = view as? MapView { return mapView }
            view = view?.superview
        }
        return nil
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Stylesheet.Colors.BlueMain
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var swapButton: UIButton = {
        let vehicleOwner = mapView?.parentViewController?.vehicleOwnerService.getVehicleOwner()
//        let spot = annotation as? Spot
        let button = UIButton(type: .roundedRect)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SWAP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Stylesheet.Colors.OrangeMain
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(didTapDetailsButton(_:)), for: .touchUpInside)
        
        if let spot = annotation as? Spot, vehicleOwnerMadeThisSpot(spot) {
            button.setTitle("CANCEL", for: .normal)
            button.backgroundColor = Stylesheet.Colors.PinkMain
            subtitleLabel.text = "MY SPOT"
        }
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "defaultProfileImage")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = Stylesheet.Colors.PinkMain
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "USERNAME"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var carTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "CAR TYPE"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "ADDRESS"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0 mi"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "-:--"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Stylesheet.Colors.PinkMain
        return label
    }()
    
    weak var calloutTimer: Timer? = {
        let timer = Timer()
        return timer
    }()
    
    private var spotDuration = 5.0 //dummy initial value
    
    // MARK: - Inits
    override init(annotation: MKAnnotation) {
        super.init(annotation: annotation)
        self.annotation = annotation
        updateContents(for: annotation)
        runCalloutTimer(for: annotation)
        configure()
    }
    
    func runCalloutTimer(for annotation: MKAnnotation) {
        if let spot = annotation as? Spot {
            guard let spotDurationInMinutes = Double(spot.duration)else{return}
            let duration = spotDurationInMinutes*60 - (DateProvider.currentTimeSince1970() - spot.timeStamp1970)
            print(duration)
            spotDuration = duration
            calloutTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCalloutTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateCalloutTimer() {
        guard let timer = calloutTimer, timer.isValid else { return }
        if spotDuration < 1.0 {
            timer.invalidate()
//            Alert.present(from: .reserveSpotConfirmation)
            if let mapView = mapView{
                mapView.calloutDelegate.calloutSpotExpired()
            }
            
        } else {
            spotDuration -= 1.0
            timerLabel.text = DateProvider.parseIntoFormattedString(time: spotDuration)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should not call init(coder:)")
    }
    
    // MARK: - Layout
    /// Add constraints for subviews of `contentView`
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviewsToContentView()
        prepareViews()
    }
    
    private func addSubviewsToContentView() {
        contentView.addSubview(swapButton)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(timerLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(carTypeLabel)
    }
    
    private func prepareViews() {
        prepareSwapButton()
        prepareTimerLabel()
        prepareDistanceLabel()
        prepareSubtitleLabel()
        prepareImageView()
        prepareUserNameLabel()
        prepareCarTypeLabel()
        prepareAddressLabel()
    }
    
    func prepareSwapButton() {
        swapButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-5)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.8)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    func prepareSubtitleLabel() {
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.centerX.equalTo(contentView.snp.centerX)
            make.left.greaterThanOrEqualTo(timerLabel.snp.right).offset(5)
            make.right.lessThanOrEqualTo(distanceLabel.snp.left).offset(-5)
        }
    }
    
    private func prepareTimerLabel() {
        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.left.equalTo(contentView.snp.left).offset(5)
        }
    }
    
    private func prepareDistanceLabel() {
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
        }
    }
    private func prepareImageView() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(5)
            make.left.equalTo(contentView.snp.left).offset(5)
            make.center.equalTo(contentView.snp.center)
            make.size.equalTo(contentView.snp.height).multipliedBy(0.5)
        }
    }
    
    private func prepareUserNameLabel() {
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(5)
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
        }
    }
    
    private func prepareCarTypeLabel() {
        carTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
        }
    }
    
    private func prepareAddressLabel() {
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(carTypeLabel.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-5)
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
        }
    }
    
    // MARK: - Setup - View/Data
    // Update callout contents
    private func updateContents(for annotation: MKAnnotation) {
        titleLabel.text = annotation.title ?? "Unknown"
        subtitleLabel.text = "OPEN"
        
        if let spot = annotation as? Spot {
            fetchVehicleOwnerData(spot: spot)
            fetchAddress(coordinates: spot.coordinate)
        }
    }
    
    private func fetchVehicleOwnerData(spot: Spot) {
        DataBaseService.manager.retrieveVehicleOwner(vehicleOwnerId: spot.userUID, dataBaseObserveType: .observing, completion: { [weak self] vehicleOwner in
            self?.fetchVehicleOwnerImage(vehicleOwner: vehicleOwner)
            
            self?.userNameLabel.text = vehicleOwner.userName
            self?.carTypeLabel.text = vehicleOwner.car.carMake + vehicleOwner.car.carModel
        }) { (error) in
            print(error)
        }
    }
    
    private func fetchAddress(coordinates: CLLocationCoordinate2D) {
        let locationOfSpot = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        if let currentUserLocation = LocationService.manager.getUserLocation() {
            let metersInAMile = 1609.34
            let distanceBewteenUserandSpot = locationOfSpot.distance(from: currentUserLocation) / metersInAMile
            distanceLabel.text = String(distanceBewteenUserandSpot.description.prefix(4)) + " mi"
        }
        
        LocationService.manager.lookUpAddress(location: locationOfSpot) { [weak self] placemark in
            self?.addressLabel.text = placemark?.name
        }
    }
    
    private func fetchVehicleOwnerImage(vehicleOwner: VehicleOwner) {
        StorageService.manager.retrieveImage(imgURL: vehicleOwner.car.carImageId, completionHandler: { [weak self] image in
            self?.imageView.image = image
        }) { [weak self] error in
            self?.imageView.backgroundColor = .red
            print(error)
        }
    }
    
    private func vehicleOwnerMadeThisSpot(_ spot: Spot) -> Bool {
        if let containerViewController = (UIApplication.shared.keyWindow?.rootViewController as? ContainerViewController){
            if let mapViewController = containerViewController.mapViewController{
                let vehicleOwner = mapViewController.vehicleOwnerService.getVehicleOwner()
            return spot.userUID == vehicleOwner?.userUID
            }
        } else if spot.userUID == AuthenticationService.manager.getCurrentUser()?.uid{
            return true
        }
        return false
    }
    
    // This is an example method, defined by `CalloutView`, which is called when you tap on the callout
    // itself (but not one of its subviews that have user interaction enabled).
    override func didTouchUpInCallout(_ sender: Any) {
        print("didTouchUpInCallout")
    }
    
    // Callout detail button was tapped
    @objc func didTapDetailsButton(_ sender: UIButton) {
        guard let annotation = annotation as? Spot else { return }
        if let mapView = mapView {
            if let delegate = mapView.calloutDelegate {
                if vehicleOwnerMadeThisSpot(annotation) {
                    delegate.cancelButtonPressed(spot: annotation)
                    return
                }
                delegate.reserveButtonPressed(spot: annotation)
            }
        }
    }
    
}

