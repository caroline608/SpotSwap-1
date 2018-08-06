import UIKit
import Firebase

class LaunchViewController: UIViewController {
    
    //view instance
    let launchView = LaunchView()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        launchView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        launchView.signUpButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
                launchView.tutorialButton.addTarget(self, action: #selector(tutorialTapped), for: .touchUpInside)
        configureNavBar()
        view.backgroundColor = .white
        setupLaunchView()
    }
    override func viewDidAppear(_ animated: Bool) {
        launchView.layerMask.startAnimation()
    }
    
    private func configureNavBar(){
        self.navigationController?.isNavigationBarHidden = true
    }
    private func setupLaunchView(){
        view.addSubview(launchView)
        launchView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        configureNavBar()
    }
    
    //MARK: - Button Actions
    @objc func loginTapped(_ sender: UIButton!) {
        print("login tapped!")
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc func signupTapped(_ sender: UIButton!) {
        print("signup tapped!")
        let signupVC = SignUpViewController()
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @objc func tutorialTapped(_ sender: UIButton!) {
        print("tutorial tapped")
        let pageVC = PageViewController()
        //present(pageVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(pageVC, animated: true)
    }
    
}



