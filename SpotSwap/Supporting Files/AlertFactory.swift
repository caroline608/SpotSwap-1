import UIKit
extension UIApplication {
    static func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
}

struct Alert {
    enum AlertType {
        case reserveSpotConfirmation
        case emptyTextFields
        case userHasSpot
    }
    
    let title: String
    let message: String?
    let actions: [String]
    
    private init(error: NSError) {
        title = error.localizedFailureReason ?? "Error"
        message = error.localizedDescription
        actions = ["OK"]
    }
    
    private init(type: AlertType) {
        switch type {
        case .reserveSpotConfirmation:
            title = "Swap Spots?"
            message = "Are you sure you want to reserve this Spot?"
            actions = ["YES", "NO"]
        case .emptyTextFields:
            title = "Please have a valid entry in the input fields"
            message = nil
            actions = ["OK"]
        case .userHasSpot:
            title = "You already have a spot on the map."
            message = "Please cancel first spot before making more."
            actions = ["OK"]
        }
    }
    
    static func present(from error: NSError) {
        let alert = Alert(error: error)
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        let dismissAlert = UIAlertAction(title: alert.actions.first!, style: .default, handler: nil)
        let actions = [dismissAlert]
        actions.forEach({alertController.addAction($0)})
        if let topView = UIApplication.getTopViewController() {
            topView.present(alertController, animated: true, completion: nil)
        }
        
    }
    static func present(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        if let topView = UIApplication.getTopViewController() {
            topView.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func present(from type: AlertType) {
        let alert = Alert(type: type)
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        var actions = [UIAlertAction]()
        for actionTitle in alert.actions {
            let newAlert = UIAlertAction(title: actionTitle, style: .default, handler: nil)
            actions.append(newAlert)
        }
        actions.forEach({alertController.addAction($0)})
        if let topView = UIApplication.getTopViewController() {
            topView.present(alertController, animated: true, completion: nil)
        }
    }
}


