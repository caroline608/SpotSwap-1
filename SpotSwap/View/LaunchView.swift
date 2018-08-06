import UIKit
import SnapKit
import Pastel
class LaunchView: UIView {
    // MARK: - Properties
    lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "trafficLowExposure")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    lazy var layerMask: PastelView = {
        let pastelView = PastelView(frame: frame)
        pastelView.layer.opacity = 0.50
        pastelView.startPastelPoint = .topRight
        pastelView.endPastelPoint = .bottomLeft
        pastelView.animationDuration = 3.0
        pastelView.setColors([Stylesheet.Colors.GrayMain,
                              UIColor.black,
                              Stylesheet.Colors.LightGray,
                              UIColor.black,
                              Stylesheet.Colors.GrayMain,])
        return pastelView
    }()
    
    lazy var logoImage: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named: "43iosgroup6logo")
        //style details
        logo.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        logo.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        logo.layer.shadowOpacity = 1.0
        logo.layer.shadowRadius = 0.0
        logo.clipsToBounds = false
        logo.layer.masksToBounds = false
        return logo
    }()
    
    lazy var logoSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Share your parking with people nearby"
        label.font = UIFont(name: Stylesheet.Fonts.Bold, size: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var tutorialButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "tutorialButton"), for: .normal)
        return button
    }()
    lazy var tutorialLabel: UILabel = {
        let label = UILabel()
        label.text = "Tutorial"
        label.font = UIFont(name: Stylesheet.Fonts.Bold, size: 14)
        label.textColor = Stylesheet.Colors.White
        return label
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Stylesheet.Colors.OrangeMain
        button.titleLabel?.font = UIFont(name: Stylesheet.Fonts.Bold, size: 20)
        button.titleLabel?.textColor = Stylesheet.Colors.LightGray
        button.titleLabel?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.titleLabel?.layer.shadowOpacity = 1.0
        button.layer.borderColor = Stylesheet.Colors.GrayMain.cgColor
        button.layer.shadowColor = Stylesheet.Colors.GrayMain.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        
        button.setTitle("Login", for: .normal)
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Stylesheet.Colors.PinkMain
        button.titleLabel?.font = UIFont(name: Stylesheet.Fonts.Bold, size: 20)
        button.titleLabel?.textColor = Stylesheet.Colors.LightGray
        button.titleLabel?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.titleLabel?.layer.shadowOpacity = 1.0
        button.layer.borderColor = Stylesheet.Colors.GrayMain.cgColor
        button.layer.shadowColor = Stylesheet.Colors.GrayMain.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        
        button.setTitle("SignUp", for: .normal)
        return button
    }()
    
    lazy var buttonContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareViews()
    }
    override func layoutSubviews() {
        loginButton.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 5
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup Views
    private func prepareViews() {
        setupBackgroundImageView()
        setupLogoImage()
        //setupLogoSubtitleLabel()
        setupTutorialButton()
        setupTutorialLabel()
        //        setupLogoSubtitleLabel()
        setupButtonContainerView()
        setUpLoginButton()
        setUpSignUpButton()
        setupLayerMask()
    }
    
    
    private func setupBackgroundImageView() {
        self.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
    }
    
    private func setupLogoImage() {
        self.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height*0.20)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(snp.width).multipliedBy(0.85)
            make.height.equalTo(snp.height).multipliedBy(0.45)
        }
    }
    
    private func setupLogoSubtitleLabel() {
        self.addSubview(logoSubtitleLabel)
        logoSubtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoImage.snp.bottom).offset(20)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(snp.width).multipliedBy(0.90)
        }
    }
    private func setupButtonContainerView(){
        addSubview(buttonContainerView)
        buttonContainerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(snp.bottom)
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.10)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    private func setupTutorialButton() {
        self.addSubview(tutorialButton)
        tutorialButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalTo(snp.right).offset(-10)
        }
    }
    private func setupTutorialLabel(){
        addSubview(tutorialLabel)
        tutorialLabel.snp.makeConstraints { (make) in
            make.right.equalTo(tutorialButton.snp.left).offset(-5)
            make.width.height.equalTo(50)
            make.centerY.equalTo(tutorialButton.snp.centerY)
        }
    }
    private func setUpLoginButton() {
        self.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(buttonContainerView.snp.width).multipliedBy(0.48)
            make.height.equalTo(buttonContainerView.snp.height).multipliedBy(0.90)
            make.right.equalTo(buttonContainerView.snp.centerX).offset(-5)
            make.centerY.equalTo(buttonContainerView.snp.centerY)
            
        }
    }
    private func setUpSignUpButton() {
        buttonContainerView.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.width.equalTo(buttonContainerView.snp.width).multipliedBy(0.48)
            make.height.equalTo(buttonContainerView.snp.height).multipliedBy(0.90)
            make.left.equalTo(buttonContainerView.snp.centerX).offset(5)
            make.centerY.equalTo(buttonContainerView.snp.centerY)
        }
    }
    private func setupLayerMask(){
        backgroundImageView.addSubview(layerMask)
        layerMask.snp.makeConstraints { (make) in
            make.edges.equalTo(backgroundImageView.snp.edges)
        }
        layerMask.startAnimation()
    }
    
    
}




