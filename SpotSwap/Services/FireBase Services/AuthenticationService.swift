//
//  AuthenticationService.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/14/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation
import FirebaseAuth

// MARK: - AuthenticationService Errors
public enum AuthenticationServiceErrors: Error{
    case signInError
    case invalidEmail
    case weakPassword
    case signOutError
    case noSignedInUser
    public var errorDescription: String? {
        switch self {
        case .signInError:
            return NSLocalizedString("There was an error in signing in ", comment: "My error")
        case .invalidEmail:
            return NSLocalizedString("A user-friendly description of the error.", comment: "My error")
        case .weakPassword:
            return NSLocalizedString("A user-friendly description of the error.", comment: "My error")
        case .signOutError:
            return NSLocalizedString("A user-friendly description of the error.", comment: "My error")
        case .noSignedInUser:
            return NSLocalizedString("A user-friendly description of the error.", comment: "My error")
        }
    }
}

class AuthenticationService {
    static let manager = AuthenticationService()
    private init(){}
    //MARK: - Public Functions
    
    //This function will get the current user
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    //This function will create a new user
    public func createUser(email: String, password: String, completion: @escaping (User)->Void, errorHandler: @escaping (Error)->Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                //TODO  handle the error
                print(#function, error)
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .emailAlreadyInUse:
                        print(#function, AuthenticationServiceErrors.invalidEmail)
                        errorHandler(error)
                    case .weakPassword:
                        print(#function, AuthenticationServiceErrors.weakPassword)
                        errorHandler(error)
                    default:
                        errorHandler(error)
                    }
                }
                errorHandler(error)
            }
            if let user = user{
                completion(user)
                user.sendEmailVerification(completion: { (error) in
                    if let error = error{
                        errorHandler(error)
                    }
                })
            }
        }
    }
    //This function will let you sign in
    public func signIn(email: String, password: String, completion: @escaping (User) -> Void, errorHandler: @escaping(Error)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(#function, AuthenticationServiceErrors.signInError)
                errorHandler(error)
            } else if let user = user {
                completion(user)
            }
        }
    }
    
    //This function will sign the user out
    public func signOut(errorHandler: @escaping(Error)->Void) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(#function, AuthenticationServiceErrors.signOutError)
            errorHandler(error)
        }
    }
    //This function will send the password reset email to the user
    public func resertPassword(userEmail: String,completionHandler: @escaping(Bool)->Void, errorHandler: @escaping(Error)->Void){
        Auth.auth().sendPasswordReset(withEmail: userEmail) { (error) in
            guard let error  = error else{return}
            errorHandler(error)
        }
        Auth.auth().sendPasswordReset(withEmail: userEmail, actionCodeSettings: ActionCodeSettings.init()) { (error) in
            guard let error  = error else{
                completionHandler(true)
                return
            }
            errorHandler(error)
        }
    }
    //This function will update the user email you should prompt another sign in before updating user credentials
    public func updateUserEmail(newEmail: String, errorHandler: @escaping(Error)->Void){
        let currentUser = self.getCurrentUser()
        guard let safeUser = currentUser else{
            errorHandler(AuthenticationServiceErrors.noSignedInUser)
            return
        }
        safeUser.updateEmail(to: newEmail, completion: { (error) in
            guard let error  = error else{return}
            errorHandler(error)
        })
    }
    //This function will update the user Password you should prompt another sign in before updating user credentials
    public func updateUserPassword(email: String, oldPassword: String, newPassword: String, errorHandler: @escaping(Error)->Void){
        let currentUser = self.getCurrentUser()
        guard let safeUser = currentUser else{
            errorHandler(AuthenticationServiceErrors.noSignedInUser)
            return
        }
        safeUser.updatePassword(to: newPassword, completion: { (error) in
            guard let error  = error else{return}
            errorHandler(error)
        })
    }
}
