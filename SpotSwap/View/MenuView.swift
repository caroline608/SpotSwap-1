//
//  MenuView.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/20/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import UIKit
//MARK: - Delegate protocols
protocol MenuDelegate {
    func signOutButtonClicked(_ sender: MenuView)
    func profileButtonClicked(_ sender: MenuView)
}

class MenuView: UIView {
    //MARK: - Properties
    
    var delegate: MenuDelegate?
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "defaultProfileImage")
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: Stylesheet.Fonts.Bold, size: 20)
        label.textColor = Stylesheet.Colors.White
        label.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        label.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        label.layer.shadowOpacity = 0.5
        label.layer.borderColor = Stylesheet.Colors.GrayMain.cgColor
        label.layer.shadowColor = Stylesheet.Colors.GrayMain.cgColor
        label.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        label.layer.shadowOpacity = 1.0
        return label
    }()
    lazy var userPointsLogo: UIImageView = {
        let iView = UIImageView()
        iView.image = #imageLiteral(resourceName: "rewardPointsImage")
        return iView
    }()
    lazy var userPointsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont(name: Stylesheet.Fonts.Bold, size: 15)
        label.textColor = Stylesheet.Colors.White
        label.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        label.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        label.layer.shadowOpacity = 0.5
        label.layer.borderColor = Stylesheet.Colors.GrayMain.cgColor
        label.layer.shadowColor = Stylesheet.Colors.GrayMain.cgColor
        label.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        label.layer.shadowOpacity = 1.0
        label.font = UIFont(name: Stylesheet.Fonts.Bold, size: 15)
        return label
    }()
    lazy var signOutLogo: UIImageView = {
        let iView = UIImageView()
        iView.image = #imageLiteral(resourceName: "signOutImage")
        return iView
    }()

    lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Stylesheet.Fonts.Bold, size: 15)
        button.titleLabel?.textColor = Stylesheet.Colors.LightGray
        button.titleLabel?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.titleLabel?.layer.shadowOpacity = 0.5
        button.layer.borderColor = Stylesheet.Colors.GrayMain.cgColor
        button.layer.shadowColor = Stylesheet.Colors.GrayMain.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        button.setTitle("Sign out", for: .normal)
        button.addTarget(self, action: #selector(signOutButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    lazy var profileLogo: UIImageView = {
        let iView = UIImageView()
        iView.image = #imageLiteral(resourceName: "user-name white")
        return iView
    }()
    lazy var profileButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Stylesheet.Fonts.Bold, size: 15)
        button.titleLabel?.textColor = Stylesheet.Colors.LightGray
        button.titleLabel?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.titleLabel?.layer.shadowOpacity = 0.5
        button.layer.borderColor = Stylesheet.Colors.GrayMain.cgColor
        button.layer.shadowColor = Stylesheet.Colors.GrayMain.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        button.setTitle("Profile", for: .normal)
        button.addTarget(self, action: #selector(profileButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    lazy var tutorialLogo: UIImageView = {
        let iView = UIImageView()
        iView.image = #imageLiteral(resourceName: "tutorialButton")
        return iView
    }()
    lazy var tutorialButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Stylesheet.Fonts.Bold, size: 15)
        button.titleLabel?.textColor = Stylesheet.Colors.LightGray
        button.titleLabel?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.titleLabel?.layer.shadowOpacity = 0.5
        button.layer.borderColor = Stylesheet.Colors.GrayMain.cgColor
        button.layer.shadowColor = Stylesheet.Colors.GrayMain.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        button.setTitle("Tutorial", for: .normal)
        return button
    }()
    lazy var stackView: UIStackView = {
        let sView = UIStackView(arrangedSubviews: [userPointsLabel, signOutButton, tutorialButton])
        sView.spacing = 5
        sView.axis = .vertical
        sView.backgroundColor = .yellow
        sView.distribution = .fillEqually
        return sView
    }()
    //MARK: - Inits
    init(_ vehicleOwner: VehicleOwner){
        self.init()
        userNameLabel.text = vehicleOwner.userName
        userPointsLabel.text = "Reward Points: " + vehicleOwner.rewardPoints.description
        guard let imageUrl = vehicleOwner.userImage else{
            return
        }
        StorageService.manager.retrieveImage(imgURL: imageUrl, completionHandler: { (profileImage) in
            self.profileImage.image = profileImage
        }) { (error) in
            print(error)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Stylesheet.Colors.LightGray
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Layout subViews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
        profileImage.layer.cornerRadius = profileImage.bounds.size.width / 2.0
        profileImage.layer.masksToBounds = true
    }
    private func setupViews(){
        setupProfileImage()
        setupUserNameLabel()
        setupUserPointsLogo()
        setupUserPoints()
        setupProfileLogo()
        setupProfileButton()
        setupSignOutLogo()
        setupSignOutButton()
        setupTutorialLogo()
        setuptutorialButton()
//        setupStackView()
    }
    private func setupProfileImage(){
        addSubview(profileImage)
        profileImage.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(snp.centerX)
            make.width.height.equalTo(snp.width).multipliedBy(0.65)
        }
    }
    private func setupStackView(){
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(snp.leading).offset(5)
            make.trailing.equalTo(snp.trailing)
            make.height.equalTo(snp.height).multipliedBy(0.45)
        }
    }


    private func setupUserNameLabel(){
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.centerX.equalTo(profileImage.snp.centerX)
            make.width.equalTo(snp.width).multipliedBy(0.85)
        }
    }
    private func setupUserPointsLogo(){
        addSubview(userPointsLogo)
        userPointsLogo.snp.makeConstraints { (make) in
            make.width.height.equalTo(snp.width).multipliedBy(0.15)
            make.top.equalTo(userNameLabel.snp.bottom).offset(UIScreen.main.bounds.height*0.15)
            make.left.equalTo(snp.left).offset(5)
        }
    }
    private func setupUserPoints(){
        addSubview(userPointsLabel)
        userPointsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userPointsLogo.snp.right).offset(5)
            make.centerY.equalTo(userPointsLogo.snp.centerY)
        }
    }
    private func setupProfileLogo(){
        addSubview(profileLogo)
        profileLogo.snp.makeConstraints { (make) in
            make.top.equalTo(userPointsLogo.snp.bottom).offset(10)
            make.width.height.equalTo(snp.width).multipliedBy(0.15)
            make.left.equalTo(snp.left).offset(5)
        }
    }
    private func setupProfileButton(){
        addSubview(profileButton)
        profileButton.snp.makeConstraints { (make) in
            make.left.equalTo(profileLogo.snp.right).offset(5)
            make.centerY.equalTo(profileLogo.snp.centerY)
        }
    }
    private func setupSignOutLogo(){
        addSubview(signOutLogo)
        signOutLogo.snp.makeConstraints { (make) in
            make.top.equalTo(profileLogo.snp.bottom).offset(10)
            make.width.height.equalTo(snp.width).multipliedBy(0.15)
            make.left.equalTo(snp.left).offset(5)
        }
    }
    private func  setupSignOutButton(){
        addSubview(signOutButton)
        signOutButton.snp.makeConstraints { (make) in
            make.left.equalTo(signOutLogo.snp.right).offset(5)
            make.centerY.equalTo(signOutLogo.snp.centerY)
        }
    }
    private func setupTutorialLogo(){
        addSubview(tutorialLogo)
        tutorialLogo.snp.makeConstraints { (make) in
            make.top.equalTo(signOutLogo.snp.bottom).offset(10)
            make.width.height.equalTo(snp.width).multipliedBy(0.15)
            make.left.equalTo(snp.left).offset(5)
        }
    }
    private func  setuptutorialButton(){
        addSubview(tutorialButton)
        tutorialButton.snp.makeConstraints { (make) in
            make.left.equalTo(tutorialLogo.snp.right).offset(5)
            make.centerY.equalTo(tutorialLogo.snp.centerY)
        }
    }

    //MARK: - Button Actions
    
    @objc func signOutButtonAction(_ sender: UIButton){
        delegate?.signOutButtonClicked(self)
    }
    
    @objc func profileButtonAction(_ sender: UIButton) {
        delegate?.profileButtonClicked(self)
    }
    

}

extension MenuView {
    
}
