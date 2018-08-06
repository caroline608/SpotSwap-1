
import UIKit
import SnapKit
class WalkthroughView: UIView {
    // MARK: - Properties
    lazy var mainContentView:UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var bottomView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 212/255, alpha: 0.80)//UIColor.lightGray
        //view.alpha = 0.80
        return view
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont(name: Stylesheet.Fonts.Bold, size: 20)
        label.textColor = Stylesheet.Colors.White
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Stylesheet.Fonts.Regular, size: 14)
        label.textAlignment = .center
        label.textColor = Stylesheet.Colors.White
        return label
    }()
    
    lazy var tutorialImageView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        //style details
        logo.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        logo.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        logo.layer.shadowOpacity = 1.0
        logo.layer.shadowRadius = 0.0
        return logo
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 6 //TODO This should be fixed to an input for setup not a constant
        pc.pageIndicatorTintColor = Stylesheet.Colors.PinkMain
        pc.currentPageIndicatorTintColor = Stylesheet.Colors.OrangeMain
        pc.transform = CGAffineTransform(scaleX: 2, y: 2) //1.3// set dot scale of pageControl
        //pc.backgroundColor = UIColor.darkGray //optional to use
        return pc
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = nil
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton() //frame: CGRect(x: 100, y: 100, width: 100, height: 50)
        button.backgroundColor = Stylesheet.Colors.BlueMain
        button.setTitle("Start", for: .normal)
        //set button design
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup Views
    private func prepareMainView() {
        setupExitButton()
        setupImageView()
        setupBottomView()
        setupBottomHeaderLabel()
        setupBottomDescriptionLabel()
        setupPageControl()
    }
    
    private func setupBottomView() {
        addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.30)
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    private func setupImageView() {
        addSubview(tutorialImageView)
        tutorialImageView.snp.makeConstraints { (make) in
            make.height.equalTo(snp.height).multipliedBy(0.85)
            make.width.equalTo(snp.width).multipliedBy(0.80)
            make.center.equalTo(snp.center)
        }
    }
    
    private func setupBottomHeaderLabel() {
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top).offset(5)
            make.width.equalTo(bottomView.snp.width)
            make.centerX.equalTo(bottomView.snp.centerX)
        }
    }
    
    private func setupBottomDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.width.equalTo(bottomView.snp.width).multipliedBy(0.85)
            make.centerX.equalTo(bottomView.snp.centerX)
        }
    }
    
    private func setupPageControl() {
        addSubview(pageControl) //delete bottomview.
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.width.equalTo(snp.width)
            //make.height.equalTo(bottomView.snp.height).multipliedBy(0.05)
        }
    }
    
    private func setupNextButton() {
        self.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-10)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
        }
    }
    private func setupExitButton(){
        self.addSubview(exitButton)
        exitButton.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(snp.left).offset(10)
        }
    }
    
    private func setupStartButton() {
        self.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(pageControl.snp.bottom).offset(5)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(bottomView.snp.width).multipliedBy(0.65)
            make.height.equalTo(45)
        }
    }
    public func setupWalkthrough(walkThrough: Walkthrough){
        self.headerLabel.text = walkThrough.headerLabelText
        self.descriptionLabel.text = walkThrough.descriptionText
        self.tutorialImageView.image = walkThrough.tutorialImage
        self.pageControl.currentPage = walkThrough.pageControlIndex
        if let safeGifName = walkThrough.gifName {
            self.tutorialImageView.loadGif(asset: safeGifName)
        }
        guard walkThrough.isLastWalkthrough else {
            setupNextButton()
            return
        }
        setupStartButton()
        
    }
    
    
}

