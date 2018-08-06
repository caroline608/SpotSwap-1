import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //view instance
    let loginView = LoginView()
    
    var keyboardHeight: CGFloat = 0

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        configureNavBar()
        self.loginView.pastelView.startAnimation()
        self.loginView.signInViewDelegate = self
        self.loginView.emailTextField.delegate = self
        self.loginView.passwordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    func setupLoginView() {
        view.addSubview(loginView)
        loginView.snp.makeConstraints { (constraint) in
            constraint.edges.equalTo(view.snp.edges)
        }
    }
    
    func configureNavBar(){
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: - Setup Button Action
    private func loginTapped() {
        guard let emailText = loginView.emailTextField.text, let passwordText = loginView.passwordTextField.text, loginView.emailTextField.text != "", loginView.passwordTextField.text != "" else{
            Alert.present(from: Alert.AlertType.emptyTextFields)
            return
        }
        AuthenticationService.manager.signIn(email: emailText, password: passwordText, completion: { (user) in
            //present alert
            let containerViewController = ContainerViewController.storyBoardInstance()
            self.present(containerViewController, animated: true, completion: nil)
            
        }) { (error) in
            Alert.present(title: "Login Error!", message: "\(error.localizedDescription)")
        }
        
    }
    
    //MARK: - Setup Keyboard Handling
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let infoDict = notification.userInfo else { return }
        guard let rectFrame = infoDict[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let duration = infoDict[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        loginView.handleKeyBoard(with: rectFrame, and: duration)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let infoDict = notification.userInfo else { return }
        guard let duration = infoDict[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        loginView.handleKeyBoard(with: CGRect.zero, and: duration)
    }
}
//MARK: - LoginViewDelegates
extension LoginViewController: SignInViewDelegate{
    func forgotPasswordButtonClicked() {
        let alertController = UIAlertController(title: "Please enter your email address", message: "a reset email will be sent to your email", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Please enter your email here ..."
            textField.layer.cornerRadius = 2
        }
        let sendAction = UIAlertAction(title: "Send", style: .default) { (sendAction) in
            //TODO do the reset password
            guard let email = alertController.textFields?.first?.text else{return}
            AuthenticationService.manager.resertPassword(userEmail: email, completionHandler: {completed in
                Alert.present(title: "Great", message: "Your reset password email is on the way")
            }, errorHandler: { (error) in
                Alert.present(title: "there was an error sending the reset email", message: "Please try again")
            })
        }
        alertController.addAction(sendAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func dismissKeyBoard() {
          view.endEditing(true)
    }
    func loginButtonClicked() {
        loginTapped()
    }
}

//MARK: - textFieldDelegate
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard textField.text != nil else {
            return false
        }
        return true
    }
}
