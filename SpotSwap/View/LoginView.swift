import UIKit
import SnapKit
import Pastel
protocol SignInViewDelegate: class {
    func dismissKeyBoard()
    func loginButtonClicked()
    func forgotPasswordButtonClicked()
}
class LoginView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    lazy var pastelView: PastelView = {
        let pastelView = PastelView(frame: frame)
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        // Custom Duration
        pastelView.animationDuration = 3.0
        // Custom Color
        pastelView.setColors([Stylesheet.Colors.BlueMain,
                              Stylesheet.Colors.GrayMain,
                              Stylesheet.Colors.LightGray,
                              Stylesheet.Colors.OrangeMain,
                              Stylesheet.Colors.PinkMain,
                              Stylesheet.Colors.OrangeMain])
        return pastelView
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //        scrollView.backgroundColor = Stylesheet.Colors.PinkMain
        return scrollView
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        //                view.backgroundColor = .white
        return view
    }()
    lazy var logoImage: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "43iosgroup6logo")
        logo.contentMode = .scaleAspectFill
        //style details
        logo.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        logo.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        logo.layer.shadowOpacity = 1.0
        logo.layer.shadowRadius = 0.0
        //        logo.backgroundColor = .yellow
        logo.clipsToBounds = false
        logo.layer.masksToBounds = false
        return logo
    }()
    
    lazy var logoSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Share your parking spot with people nearby"
        label.numberOfLines = 2
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        textField.placeholder = "Enter your Email"
        textField.layer.cornerRadius = 5
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    lazy var emailLogo: UIImageView = {
        let iView = UIImageView()
        iView.image = #imageLiteral(resourceName: "envelope white")
        iView.contentMode = .scaleToFill
        return iView
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true // this helps to obscure the user's password with *******
        return textField
    }()
    lazy var passwordLogo: UIImageView = {
        let iView = UIImageView()
        iView.image = #imageLiteral(resourceName: "password white")
        iView.contentMode = .scaleToFill
        return iView
    }()
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.textColor = Stylesheet.Colors.BlueMain
        button.addTarget(self, action: #selector(forgotPassword(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = Stylesheet.Colors.GrayMain
        button.setTitle("Login", for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(loginTapped(_:)), for: .touchUpInside)
        return button
    }()
    // MARK: - Delegates
    weak var signInViewDelegate: SignInViewDelegate?
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
        prepareViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup Views
    private func prepareViews() {
        setupPastelView()
        setupScrollView()
        setupContentView()
        setupLoginButton()
        setupForgotPasswordButton()
        setupPasswordTextField()
        setupPasswordLogo()
        setupEmailTextField()
        setupEmailLogo()
        setupLogoSubtitleLabel()
        setupLogoImage()
        
    }
    override func layoutSubviews() {
        //Email Logo
        emailLogo.layer.cornerRadius = 5
        emailLogo.layer.masksToBounds = true
        //Password Logo
        passwordLogo.layer.cornerRadius = 5
        passwordLogo.layer.masksToBounds = true
        setupLowerButtonDetails()
    }
    //For login button - rounds the corners and gives it a shadow
    func setupLowerButtonDetails() {
        //button.titleLabel?.font = button.titleLabel?.font.withSize(12)
        
    }
    private func setupPastelView() {
        addSubview(pastelView)
        pastelView.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
    }
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
    }
    
    private func setupContentView(){
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView.snp.edges)
            make.center.equalTo(scrollView.snp.center)
        }
    }
    private func setupLoginButton(){
        contentView.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-UIScreen.main.bounds.height*0.25)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.6)
        }
    }
    private func setupForgotPasswordButton(){
        contentView.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(loginButton.snp.top).offset(-5)
        }
    }
    private func setupPasswordTextField() {
        contentView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(forgotPasswordButton.snp.top).offset(-10)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.6)
            make.height.equalTo(30)        }
    }
    private func setupPasswordLogo(){
        contentView.addSubview(passwordLogo)
        passwordLogo.snp.makeConstraints { (make) in
            make.centerY.equalTo(passwordTextField.snp.centerY)
            make.right.equalTo(passwordTextField.snp.left).offset(-5)
            make.width.height.equalTo(passwordTextField.snp.height)
        }
    }
    private func setupEmailTextField() {
        contentView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(passwordTextField.snp.top).offset(-10)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.6)
            make.height.equalTo(30)
        }
    }
    
    
    private func setupLogoSubtitleLabel() {
        contentView.addSubview(logoSubtitleLabel)
        logoSubtitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(emailTextField.snp.top).offset(-UIScreen.main.bounds.height*0.15)
            make.width.equalTo(snp.width).multipliedBy(0.85)
        }
    }
    
    
    private func setupEmailLogo(){
        contentView.addSubview(emailLogo)
        emailLogo.snp.makeConstraints { (make) in
            make.centerY.equalTo(emailTextField.snp.centerY)
            make.right.equalTo(emailTextField.snp.left).offset(-5)
            make.width.height.equalTo(emailTextField.snp.height)
        }
    }

    
    private func setupLogoImage() {
        contentView.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(logoSubtitleLabel.snp.top).offset(-30)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(snp.width).multipliedBy(0.80)
            make.height.equalTo(snp.height).multipliedBy(0.10)
        }
    }
    
    
    // MARK: Actions
    @objc private func dismissKeyboard() {
        signInViewDelegate?.dismissKeyBoard()
    }
    
    @objc func loginTapped(_ sender:UIButton){
        signInViewDelegate?.loginButtonClicked()
    }
    @objc func forgotPassword(_ sender:UIButton){
        signInViewDelegate?.forgotPasswordButtonClicked()
    }
    func handleKeyBoard(with rect: CGRect, and animationDuration: Double) {
        guard rect != CGRect.zero else {
            scrollView.contentInset = UIEdgeInsets.zero
            scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
            return
        }
        let hiddenAreaRect = rect.intersection(scrollView.bounds)
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: hiddenAreaRect.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var buttonRect = loginButton.frame
        buttonRect = scrollView.convert(buttonRect, from: loginButton.superview)
        buttonRect = buttonRect.insetBy(dx: 0.0, dy: -10)
        scrollView.scrollRectToVisible(buttonRect, animated: true)
    }
    
}



