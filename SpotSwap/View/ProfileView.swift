import UIKit
import SnapKit

final class ProfileView: UIView {
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    lazy var profileNameLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    lazy var carImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    lazy var settingsTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
}
