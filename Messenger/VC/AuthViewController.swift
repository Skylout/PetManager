//
//  ViewController.swift
//  Messenger
//
//  Created by Леонид on 31.07.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class AuthViewController: UIViewController {

    var authUser: MUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "googleSignUp" {
            let vc = segue.destination as! UINavigationController
            let chatVC = vc.topViewController as! ChatsViewController
            chatVC.currentUser = authUser
        }
    }
    
    //Использую вместо доступной кнопки GIDSignInButton свою. 
    @IBAction func googleLoginButtonPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
}

//MARK: Google SDK

extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        AuthServices.shared.googleLogin(user: user, error: error) { (result) in
            switch result {
                
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { (result) in
                    switch result {
                        
                    case .success(let muser):
                        self.authUser = muser
                        self.performSegue(withIdentifier: "googleSignUp", sender: nil)
                    case .failure(_):
                        FirestoreService.shared.saveProfileWith(id: user.uid, email: user.email!, username: user.displayName!) { (result) in
                            switch result {
                                
                            case .success(let authMuser):
                                self.authUser = authMuser
                                self.performSegue(withIdentifier: "googleSignUp", sender: nil)
                            case .failure(let error):
                                self.showAlert(with: "Error", message: error.localizedDescription)
                            }
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Error!", message: error.localizedDescription)
            }
        }
    }
    
}
