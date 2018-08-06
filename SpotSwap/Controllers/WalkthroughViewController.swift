
import UIKit

class WalkthroughViewController: UIViewController {
    
    //MARK: Properties
    let walkthrough: Walkthrough
    private let walkthroughView = WalkthroughView()
    
    //MARK - Inits
    init(walkthrough: Walkthrough) {
        self.walkthrough = walkthrough
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWalkthroughView()
        walkthroughView.startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        walkthroughView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        walkthroughView.exitButton.addTarget(self, action: #selector(startTapped(_:)), for: .touchUpInside)
    }
    
    private func setupWalkthroughView(){
        view.addSubview(walkthroughView)
        walkthroughView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        walkthroughView.setupWalkthrough(walkThrough: self.walkthrough)
    }
    
    @objc func startTapped(_ sender: UIButton!) {
        navigationController?.popViewController(animated: true)
    }
    //If the user clicks the next button, we will show the next page view controller
    @objc func nextTapped(sender: AnyObject) {
        let pageViewController = self.parent as! PageViewController //@28:43
        pageViewController.nextPageWithIndex(index: walkthrough.pageControlIndex)
    }
    
}

