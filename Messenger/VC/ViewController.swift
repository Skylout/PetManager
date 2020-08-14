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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    
    
    //Использую вместо доступной кнопки GIDSignInButton свою. 
    @IBAction func googleLoginButtonPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
}

//MARK: Google SDK

extension ViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            let alert = UIAlertController(title: "Error!", message: "Sorry, we've got some errors here, we can't log into Google! \nError: \(error)", preferredStyle: .alert)
            self.present(alert, animated: true) {
                return
            }
        }
        
        let alert = UIAlertController(title: "Succes", message: "Successfully logged into Google!", preferredStyle: .alert)
        self.present(alert, animated: true)
        
        guard let authentification = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentification.idToken, accessToken: authentification.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error!", message: "Sorry, we've got some errors here, it's some problems with Google user! \nError: \(error)", preferredStyle: .alert)
                self.present(alert, animated: true) {
                    return
                }
            }
            
            
        }
    }
    
    
}
