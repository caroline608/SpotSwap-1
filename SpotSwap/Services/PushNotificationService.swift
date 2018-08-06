//
//  PushNotificationService.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 4/5/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//


import Foundation
import UIKit
import UserNotifications

public enum PushNotificationServiceErrors: Error {
    case errorConvertingLogoImage
    public var errorDescription: String? {
        switch self {
        case .errorConvertingLogoImage:
            return NSLocalizedString("ther was an error converting the logo", comment: "")
        }
    }
    
}

class PushNotificationService {
    
    private let unNotificationCenter: UNUserNotificationCenter!
    private var unNotificationCenterDelegate: UNUserNotificationCenterDelegate!
    init(viewControllerConformsToUNUserNotificationCenterDelegate: UNUserNotificationCenterDelegate) {
        self.unNotificationCenter = UNUserNotificationCenter.current()
        unNotificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            guard error != nil else{return}
            Alert.present(title: "Notifications Service Error: \(error?.localizedDescription ?? "Authorization error")", message: nil)
            print("Notification authorization granted")
        }
        self.unNotificationCenterDelegate = viewControllerConformsToUNUserNotificationCenterDelegate
        self.unNotificationCenter.delegate = unNotificationCenterDelegate
    }
    public func triggerCompletedNotification(trigerDuration: Double, errorHandler: @escaping(Error)->Void){
        let content = UNMutableNotificationContent()
        content.title = "Hey there, Your Swap is completed"
        content.body = "Spot Swap will make your life easier in finding parking spots"
        //configure trige
        //adding an image to our notification message ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        //we need to write to disk, so we are writing to the documents folder
        let documentrDirecotry = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageIdentifier = "image.png"
        let filePath = documentrDirecotry.appendingPathComponent(imageIdentifier)
        //this will converts an image to data to write to disk
        guard let imageData  = UIImagePNGRepresentation(#imageLiteral(resourceName: "SpotSwapIcon")) else{
            print("can't make an image data")
            return
        }
        do {
            try imageData.write(to: filePath)
            let attachment = try UNNotificationAttachment.init(identifier: imageIdentifier, url: filePath, options: nil)
            content.attachments = [attachment]
        } catch let error {
            print("Dev: write error\(error)")
        }
        let triger = UNTimeIntervalNotificationTrigger.init(timeInterval: trigerDuration, repeats: false)
        content.sound = UNNotificationSound.default()
        //create request
        let request = UNNotificationRequest(identifier: "testingNotification", content: content, trigger: triger)
        
        unNotificationCenter.add(request) { (error) in
            guard let error = error else {return}
            errorHandler(error)
        }
    }
    public func triggerReservationNotification(vehicleOwner: VehicleOwner, trigerDuration: Double, reservation: Reservation ,errorHandler: @escaping(Error)->Void){
        let content = UNMutableNotificationContent()
        content.title = "Hey there, you have got a swap !!"
        content.body = "\(vehicleOwner.userName) is swapping with you"
        let documentrDirecotry = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageIdentifier = "image.png"
        let filePath = documentrDirecotry.appendingPathComponent(imageIdentifier)
        //this will converts an image to data to write to disk
        if let image = vehicleOwner.userImage{
            StorageService.manager.retrieveImage(imgURL: image, completionHandler: { (userImage) in
                guard let imageData  = UIImagePNGRepresentation(userImage) else{
                    print("can't make an image data")
                    return
                }
                do {
                    try imageData.write(to: filePath)
                    let attachment = try UNNotificationAttachment.init(identifier: imageIdentifier, url: filePath, options: nil)
                    content.attachments = [attachment]
                } catch let error {
                    print("Dev: write error\(error)")
                }
                let triger = UNTimeIntervalNotificationTrigger.init(timeInterval: trigerDuration, repeats: false)
                content.sound = UNNotificationSound.default()
                //create request
                let request = UNNotificationRequest(identifier: "testingNotification", content: content, trigger: triger)
                
                self.unNotificationCenter.add(request) { (error) in
                    guard let error = error else {return}
                    errorHandler(error)
                }
            }, errorHandler: { (error) in
                errorHandler(error)
            })
        }
    }
    public func triggerExpiredSpotNotification(trigerDuration: Double, errorHandler: @escaping(Error)->Void, spot: Spot){
        let content = UNMutableNotificationContent()
        content.title = "Hey there, your Spot is expired"
        content.body = "Thanks for choosing Spot Swap"
        let documentrDirecotry = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageIdentifier = "image.png"
        let filePath = documentrDirecotry.appendingPathComponent(imageIdentifier)
        //this will converts an image to data to write to disk
        guard let imageData  = UIImagePNGRepresentation(#imageLiteral(resourceName: "SpotSwapIcon")) else{
            print("can't make an image data")
            return
        }
        do {
            try imageData.write(to: filePath)
            let attachment = try UNNotificationAttachment.init(identifier: imageIdentifier, url: filePath, options: nil)
            content.attachments = [attachment]
        } catch let error {
            print("Dev: write error\(error)")
        }
        let triger = UNTimeIntervalNotificationTrigger.init(timeInterval: trigerDuration, repeats: false)
        content.sound = UNNotificationSound.default()
        //create request
        let request = UNNotificationRequest(identifier: "testingNotification", content: content, trigger: triger)
        unNotificationCenter.add(request) { (error) in
            guard let error = error else {
                return
            }
            errorHandler(error)
        }
    }
}
