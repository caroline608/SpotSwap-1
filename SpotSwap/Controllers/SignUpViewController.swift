//
//  SignUpViewController.swift
//  SpotSwap
//
//  Created by C4Q on 3/19/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import UIKit
import ImagePicker
import Firebase

class SignUpViewController: UIViewController{
    // MARK: - Properties
    private let signUpView = SignUpView()
    var keyboardHeight: CGFloat = 0
    private var imagePickerController: ImagePickerController!
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.pastelView.startAnimation()
        self.signUpView.signUpViewDelegate = self
        setupNavBar()
        setupSignUpView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        setupImagePicker()
    }
    private func setupImagePicker() {
        imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
    }
    
    // MARK: - Setup NavigationBar
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(goToNextView))
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = Stylesheet.Contexts.NavigationController.BarColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.isNavigationBarHidden = false
    }
    private func setupSignUpView(){
        view.addSubview(signUpView)
        signUpView.snp.makeConstraints { (constraint) in
            constraint.edges.equalTo(self.view.snp.edges)
        }
    }

    
    //MARK:  Acitons
    @objc private func goToNextView() {
        guard let username = signUpView.usernameTextField.text, let email = signUpView.emailTextField.text, let password = signUpView.passwordTextField.text else{
            Alert.present(title: "Please enter a valid email, username, and password", message: nil)
            return
        }
        guard username != "", email != "",  password != "" else {
            Alert.present(title: "Please enter a valid email, username, and password", message: nil)
            return
        }
        guard email.contains("@"), email.contains(".") else {
            Alert.present(title: "Please enter a valid email", message: nil)
            return
        }
        guard let image = signUpView.profileImage.image else{
            Alert.present(title: "Please select a valid picture", message: nil)
            return
        }
        let registerCarVC = RegisterCarViewController(userName: username, email: email, password: password, profileImage: image)
        self.navigationController?.pushViewController(registerCarVC, animated: true)
        
        
    }

    
    //MARK: - Setup Keyboard Handling
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let infoDict = notification.userInfo else { return }
        guard let rectFrame = infoDict[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let duration = infoDict[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        signUpView.handleKeyBoard(with: rectFrame, and: duration)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let infoDict = notification.userInfo else { return }
        guard let duration = infoDict[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        signUpView.handleKeyBoard(with: CGRect.zero, and: duration)
    }
    

    
}

//MARK: ImagePickerDelegate
extension SignUpViewController: UIImagePickerControllerDelegate, ImagePickerDelegate{
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.signUpView.profileImage.image = images.first
        dismiss(animated: true, completion: nil)
        return
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.resetAssets()
        return
    }
    
}


//MARK: SignUpViewDelegate
extension SignUpViewController: SignUpViewDelegate{
    func nextButton() {
        goToNextView()
    }
    func profileImageTapGesture() {
        print("ProfileImage gesture fired")
        //        open up camera and photo gallery
        present(imagePickerController, animated: true, completion: {
            self.imagePickerController.collapseGalleryView({
            })
        })
    }
    func dismissKeyBoard() {
        view.endEditing(true)
    }
    
}




