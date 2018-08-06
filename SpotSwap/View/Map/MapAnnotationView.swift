import UIKit
import MapKit

class MapAnnotationView: MKMarkerAnnotationView {
    
    // MARK: - Properties
    weak var calloutView: MapCalloutView?
    override var annotation: MKAnnotation? {
        willSet {
            preparePin(newValue)
            calloutView?.removeFromSuperview()
        }
    }
    
    // Animation duration in seconds
    let animationDuration: TimeInterval = 0.25
    
    // MARK: - Inits
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        preparePin(annotation)
        canShowCallout = false
        animatesWhenAdded = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func preparePin(_ annotation: MKAnnotation?) {
        guard let spot = annotation as? Spot else { return }
        if spot.reservationId != nil {
            markerTintColor = Stylesheet.Colors.BlueMain
        } else {
            markerTintColor = Stylesheet.Colors.OrangeMain
        }
    }
    
    // MARK: - User Actions
    // If the annotation is selected, show the callout; if unselected, remove it
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.calloutView?.removeFromSuperview()
            
            let calloutView = MapCalloutView(annotation: annotation!)
            calloutView.add(to: self)
            self.calloutView = calloutView
            
            if animated {
                calloutView.alpha = 0
                UIView.animate(withDuration: animationDuration) {
                    calloutView.alpha = 1
                }
            }
        } else {
            guard let calloutView = calloutView else { return }
            
            if animated {
                UIView.animate(withDuration: animationDuration, animations: {
                    calloutView.alpha = 0
                }, completion: { finished in
                    calloutView.removeFromSuperview()
                    self.calloutView?.calloutTimer = nil
                    self.calloutView = nil
                })
            } else {
                calloutView.removeFromSuperview()
                self.calloutView?.calloutTimer = nil
                self.calloutView = nil
            }
        }
    }
    
    // Make sure that if the cell is reused that we remove it from the super view.
    override func prepareForReuse() {
        super.prepareForReuse()
        calloutView?.removeFromSuperview()
    }
    
    // MARK: - Detect taps on callout
    // Per the Location and Maps Programming Guide, if you want to detect taps on callout,
    // you have to expand the hitTest for the annotation itself.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) { return hitView }
        
        if let calloutView = calloutView {
            let pointInCalloutView = convert(point, to: calloutView)
            return calloutView.hitTest(pointInCalloutView, with: event)
        }
        
        return nil
    }
    
}

