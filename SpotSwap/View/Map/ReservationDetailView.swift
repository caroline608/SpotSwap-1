import UIKit
import SnapKit


class ReservationDetailView: UIView {
    // MARK: - Properties
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var timerButton: UIButton = {
        let bttn = UIButton()
        bttn.layer.cornerRadius = 5
        bttn.layer.masksToBounds = true
        bttn.backgroundColor = Stylesheet.Colors.PinkMain
        return bttn
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = Stylesheet.Colors.OrangeMain
        return view
    }()
    
    // this will either cancel current reservation or end it if the user arrived to the reserved spot
    lazy var reservationAction: UIButton = {
        let bttn = UIButton()
        bttn.backgroundColor = Stylesheet.Colors.PinkMain
        bttn.setTitle("Arrived/Cancel", for: .normal)
        bttn.titleLabel?.font = UIFont(name: Stylesheet.Fonts.Bold, size: 20)
        bttn.titleLabel?.textColor = Stylesheet.Colors.LightGray
        bttn.addTarget(self, action: #selector(prepareReservationAction(_:)), for: .touchUpInside)
        return bttn
    }()

    
    private weak var timer: Timer? = {
        let timer = Timer()
        return timer
    }()

    private var spotDuration = 5.0 //dummy initial value

    func runTimer(for duration: String) {
            spotDuration = DateProvider.parseIntoSeconds(duration: duration)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        guard let timer = timer, timer.isValid else { return }
        if spotDuration < 1.0 {
            timer.invalidate()
//            Alert.present(from: .reserveSpotConfirmation)
        } else {
            spotDuration -= 1.0
            let timeStr = DateProvider.parseIntoFormattedString(time: spotDuration)
            timerButton.setTitle(timeStr, for: .normal)
        }
    }
    
    private func fetchVehicleOwnerImage(vehicleOwner: VehicleOwner) {
        guard let url = vehicleOwner.userImage else { return }
        StorageService.manager.retrieveImage(imgURL: url, completionHandler: { [weak self] image in
            self?.imageView.image = image
        }) { [weak self] error in
            self?.imageView.backgroundColor = .red
            print(error)
        }
    }
    

    // MARK: - Inits
    init(viewController: UIViewController, vehicleOwner: VehicleOwner, reservation: Reservation) {
        self.init()
        fetchVehicleOwnerImage(vehicleOwner: vehicleOwner)
        userNameLabel.text = vehicleOwner.userName
        runTimer(for: reservation.duration)
        spotDuration = Double(reservation.duration) ?? 5.0
//        timerButton.setTitle(time, for: .normal)
        prepareViews()
        self.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup View/Data
    private func prepareViews() {
        prepareHeaderView()
        prepareImageView()
        prepareNameLabel()
        prepareTimerButton()
        prepareReservationAction()
    }
    
    private func prepareHeaderView(){
        addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).dividedBy(10)
            make.centerX.equalTo(snp.centerX)
        }
    }
    private func prepareImageView() {
        headerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(headerView.snp.left).offset(10)
            make.center.equalTo(headerView.snp.center)
            make.size.equalTo(headerView.snp.height).multipliedBy(0.7)
        }
    }
    
    private func prepareNameLabel() {
        headerView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(11)
            make.centerY.equalTo(headerView.snp.centerY)
        }
    }
    
    private func prepareTimerButton() {
        headerView.addSubview(timerButton)
        timerButton.snp.makeConstraints { make in
            make.right.equalTo(headerView.snp.right).offset(-10)
            make.centerY.equalTo(headerView.snp.centerY)
            make.height.equalTo(imageView.snp.height).dividedBy(2)
            make.width.equalTo(imageView.snp.width)
        }
    }
    private func prepareReservationAction(){
        addSubview(reservationAction)
        reservationAction.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.10)
            make.bottom.equalTo(snp.bottom)
            make.centerX.equalTo(snp.centerX)
        }
    }
    @objc func prepareReservationAction(_ sender: UIButton){
    }
    
}
