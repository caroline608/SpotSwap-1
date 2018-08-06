//
//  SignUpView.swift
//  SpotSwap
//
//  Created by C4Q on 3/16/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import UIKit
import SnapKit
import Pastel
protocol SignUpViewDelegate: class {
    func dismissKeyBoard()
    func profileImageTapGesture()
    func nextButton()
}
class SignUpView: UIView, UIGestureRecognizerDelegate {
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
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "defaultProfileImage")
        imageView.backgroundColor = Stylesheet.Colors.White
        imageView.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfileImage))
        tapGesture.delegate = self
        imageView.isUserInteractionEnabled = true //essential for the tapGesture to work
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    lazy var backButton: UIBarButtonItem = {
        var button = UIBarButtonItem()
        return button
    }()
    
    lazy var nextButton: UIBarButtonItem = {
        var button = UIBarButtonItem()
        return button
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
    
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        textField.placeholder = "Username"
        textField.layer.cornerRadius = 5
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    lazy var userNameLogo: UIImageView = {
        let iView = UIImageView()
        iView.image = #imageLiteral(resourceName: "user-name white")
        iView.contentMode = .scaleToFill
        return iView
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        textField.placeholder = "Email"
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
    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus-button"), for: .normal)
        button.addTarget(self, action: #selector(changeProfileImage), for: .touchUpInside)
        return button
    }()
    lazy var lowerNextButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = Stylesheet.Colors.GrayMain
        button.setTitle("Next", for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Delegates
    weak var signUpViewDelegate: SignUpViewDelegate?
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
        commonInit()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Stylesheet.Colors.OrangeMain
        setupViews()
    }
    
    // MARK: - LayoutSubViews
    
    override func layoutSubviews() {
        // here you get the actual frame size of the elements before getting laid out on screen
        super.layoutSubviews()
        setupProfileImageLayout()
        //Email Logo
        emailLogo.layer.cornerRadius = 5
        emailLogo.layer.masksToBounds = true
        //Password Logo
        passwordLogo.layer.cornerRadius = 5
        passwordLogo.layer.masksToBounds = true
        //UserName Logo
        userNameLogo.layer.cornerRadius = 5
        userNameLogo.layer.masksToBounds = true
    }
    private func setupProfileImageLayout() {
        profileImage.layer.cornerRadius = profileImage.bounds.width/2.0
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = Stylesheet.Colors.PinkMain.cgColor
        profileImage.layer.borderWidth = 4
    }
    // MARK: - Setup Views
    
    private func setupViews() {
        setupPastelView()
        setupScrollView()
        setupContentView()
        setupLowerNextButton()
        setupPasswordTF()
        setupPasswordLogo()
        setupEmailTF()
        setupEmailLogo()
        setupUsernameTF()
        setupUserNameLogo()
        setupProfileImage()
        setupAddImageButton()
        setupLogoSubtitleLabel()
        setupLogoImage()
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
    private func setupLowerNextButton(){
        contentView.addSubview(lowerNextButton)
        lowerNextButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-UIScreen.main.bounds.height*0.20)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.6)
        }
    }
    private func setupPasswordTF() {
        addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(lowerNextButton.snp.top).offset(-5)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.6)
            make.height.equalTo(30)
        }
    }
    private func setupPasswordLogo(){
        addSubview(passwordLogo)
        passwordLogo.snp.makeConstraints { (make) in
            make.centerY.equalTo(passwordTextField.snp.centerY)
            make.right.equalTo(passwordTextField.snp.left).offset(-10)
            make.width.height.equalTo(passwordTextField.snp.height)
        }
    }
    private func setupEmailTF() {
        addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(passwordTextField.snp.top).offset(-10)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.6)
            make.height.equalTo(30)
        }
    }
    private func setupEmailLogo(){
        addSubview(emailLogo)
        emailLogo.snp.makeConstraints { (make) in
            make.centerY.equalTo(emailTextField.snp.centerY)
            make.right.equalTo(emailTextField.snp.left).offset(-10)
            make.width.height.equalTo(emailTextField.snp.height)
        }
    }
    private func setupUsernameTF() {
        addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(emailTextField.snp.top).offset(-10)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.6)
            make.height.equalTo(30)
        }
    }
    private func setupUserNameLogo(){
        addSubview(userNameLogo)
        userNameLogo.snp.makeConstraints { (make) in
            make.centerY.equalTo(usernameTextField.snp.centerY)
            make.right.equalTo(usernameTextField.snp.left).offset(-10)
            make.width.height.equalTo(usernameTextField.snp.height)
        }
    }
    private func setupProfileImage(){
        addSubview(profileImage)
        profileImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(usernameTextField.snp.top).offset(-25)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(snp.width).multipliedBy(0.40)
            make.height.equalTo(profileImage.snp.width)
        }
    }
    private func setupAddImageButton(){
        addSubview(addImageButton)
        addImageButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(profileImage.snp.right)
            make.top.equalTo(profileImage.snp.top).offset(5)
            make.width.height.equalTo(profileImage.snp.width).multipliedBy(0.20)
        }
    }
    private func setupLogoSubtitleLabel() {
        contentView.addSubview(logoSubtitleLabel)
        logoSubtitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(profileImage.snp.top).offset(-30)
            make.width.equalTo(snp.width).multipliedBy(0.85)
        }
    }
    
    private func setupLogoImage() {
        contentView.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(logoSubtitleLabel.snp.top).offset(-10)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(snp.width).multipliedBy(0.80)
            make.height.equalTo(snp.height).multipliedBy(0.10)
        }
    }
    
    //MARK: Actions
    @objc private func dismissKeyboard() {
        signUpViewDelegate?.dismissKeyBoard()
    }
    @objc private func changeProfileImage() {
        signUpViewDelegate?.profileImageTapGesture()
    }
    @objc private func nextButtonClicked() {
        signUpViewDelegate?.nextButton()
    }
    func handleKeyBoard(with rect: CGRect, and animationDuration: Double) {
        guard rect != CGRect.zero else {
            scrollView.contentInset = UIEdgeInsets.zero
            scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
            return
        }
        // this will get the hidden area by the keyboard which is the intersection of the scroll view and the keyboard
        let hiddenAreaRec = rect.intersection(scrollView.bounds)
        // this will make an inset of the scrollView depending on the keyboard hight
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: hiddenAreaRec.height, right: 0.0)
        // this will update the content inset of the scroll view to accomodate the keyboard
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        // this will move the next button up when the keyboard will come up
        var buttonRect = lowerNextButton.frame
        buttonRect = scrollView.convert(buttonRect, from: lowerNextButton.superview)
        buttonRect = buttonRect.insetBy(dx: 0.0, dy: -10)
        scrollView.scrollRectToVisible(buttonRect, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
}
