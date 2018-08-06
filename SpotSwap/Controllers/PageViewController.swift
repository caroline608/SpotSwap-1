
import UIKit
private var testGifLink = "https://media.giphy.com/media/KY3VnTOONvgxllVac0/giphy.gif"
private var reserveSpot = "ReserveSpot"
private var offerSpotGif = "OfferSpot"
class PageViewController: UIPageViewController {
    //some hard coded data for our walkthrough screens
    var walkthroughs = [Walkthrough(headerLabelText: "Reserve a parking spot", descriptionText: "On the map, tap the space you would like to reserve", tutorialImage: nil, pageControlIndex: 0, isLastWalkthrough: false, gifName: reserveSpot),
                        Walkthrough(headerLabelText: "Offer a parking spot", descriptionText: "Once you're ready to leave your parking spot, swipe the leaving button", tutorialImage: nil, pageControlIndex: 1, isLastWalkthrough: false, gifName: offerSpotGif),
                        Walkthrough(headerLabelText: "Earn points!", descriptionText: "Offer more spots gain more points! At 100 points you'll get access to parking spots before anyone else", tutorialImage: #imageLiteral(resourceName: "Points"), pageControlIndex: 2, isLastWalkthrough: false, gifName: nil),
                        Walkthrough(headerLabelText: "Find a spot!", descriptionText: "", tutorialImage: #imageLiteral(resourceName: "SpotsAvailable"), pageControlIndex: 3, isLastWalkthrough: false, gifName: nil),
                        Walkthrough(headerLabelText: "Community Guidelines", descriptionText: "Here at SpotSwap, we want to create a positive parking experience.", tutorialImage: #imageLiteral(resourceName: "Guidelines"), pageControlIndex: 4, isLastWalkthrough: false, gifName: nil),
                        Walkthrough(headerLabelText: "Community Guidelines", descriptionText: "Here at SpotSwap, we want to create a positive parking experience.", tutorialImage: #imageLiteral(resourceName: "Top2"), pageControlIndex: 5, isLastWalkthrough: true, gifName: nil)

                        
    ]
    
    
    //    private var colors = [UIColor.red, UIColor.blue, UIColor.orange]
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Stylesheet.Colors.GrayMain
        self.dataSource = self
        self.delegate = self
        //create the first walkthrough VC
        if let startWalkthroughVC = self.viewControllerAtIndex(index: 0) {
            setViewControllers([startWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK - Navigate
    public func nextPageWithIndex(index: Int) {
        //if we do have the next page ...
        if let nextWalkthroughVC = self.viewControllerAtIndex(index: index + 1) {
            setViewControllers([nextWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func viewControllerAtIndex(index: Int) -> WalkthroughViewController? {
        guard index < walkthroughs.count else {return nil}
        guard index >= 0 else {return nil}
        return  WalkthroughViewController(walkthrough: walkthroughs[index])
        
    }
    
}


//MARK: - UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let walkthroughViewController =  viewController as? WalkthroughViewController else{return nil}
        var index = walkthroughViewController.walkthrough.pageControlIndex
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let walkthroughViewController =  viewController as? WalkthroughViewController else{return nil}
        var index = walkthroughViewController.walkthrough.pageControlIndex
        index += 1
        return viewControllerAtIndex(index: index)//self.viewControllers?.index(of: index)
    }
    
}

//MARK: - UIPageViewControllerDelegates
extension PageViewController: UIPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: PageViewController,
                                    didUpdatePageCount count: Int) {
        //        walkthroughVC.walkthroughView.pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(tutorialPageViewController: PageViewController,
                                    didUpdatePageIndex index: Int) {
        //        walkthroughVC.walkthroughView.pageControl.currentPage = index
    }
    
    
    
}

