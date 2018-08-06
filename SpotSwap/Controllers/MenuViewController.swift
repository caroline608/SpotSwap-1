//
//  MenuViewController.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/27/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    private var menuView: MenuView!
    private var vehicleOwnerService: VehicleOwnerService!
    override func viewDidLoad() {
        super.viewDidLoad()
        vehicleOwnerService = VehicleOwnerService(self)
        view.backgroundColor = Stylesheet.Colors.OrangeMain
    }
    func setupMenuView() {
        guard let vehicleOwner = vehicleOwnerService.getVehicleOwner() else {return}
        menuView = MenuView(vehicleOwner)
        self.menuView.delegate = self
        view.addSubview(menuView)
        menuView.snp.makeConstraints { (constraint) in
            constraint.edges.equalTo(view.snp.edges)
        }
    }
}
extension MenuViewController: MenuDelegate {
    // This will handle the signout from the menu
    func signOutButtonClicked(_ sender: MenuView) {
        AuthenticationService.manager.signOut { (error) in
            print(error)
            self.dismiss(animated: true, completion: nil)
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loadLaunchViewController()
    }
    
    func profileButtonClicked(_ sender: MenuView) {
//        Alert.present(from: .reserveSpotConfirmation)
        present(ProfileViewControleller(), animated: true, completion: nil)
    }
    
}
extension MenuViewController: VehicleOwnerServiceDelegate{
    func vehicleOwnerRetrieved() {
        setupMenuView()
    }
    
    func vehicleOwnerSpotReserved(reservationId: String, currentVehicleOwner: VehicleOwner) {
        
    }
    
    func vehiclOwnerRemoveReservation(_ reservationId: Reservation) {
        
    }
    
    func vehiclOwnerHasNoReservation() {
        
    }
    
    
}
