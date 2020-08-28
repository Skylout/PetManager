//
//  LoginViewController.swift
//  Messenger
//
//  Created by Леонид on 14.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var authUser: MUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInWithEmail(_ sender: UIButton) {
        
        AuthServices.shared.login(email: emailTextField.text,
                   password: passwordTextField.text) { (result) in
                    switch result {
                    case .success(let user):
                        FirestoreService.shared.getUserData(user: user) { (result) in
                            switch result {
                                
                            case .success(let user):
                                self.authUser = user
                                self.performSegue(withIdentifier: "emailLogin", sender: nil)
                            case .failure(let error):
                                self.showAlert(with: "Error", message: error.localizedDescription)
                            }
                        }
                    case .failure(let error):
                        self.showAlert(with: "Error", message: error.localizedDescription)
                    }
        }
    }
    
    @IBAction func signUpGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        performSegue(withIdentifier: "googleLogin", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UINavigationController
        let chatVC = vc.topViewController as! ChatsViewController
        chatVC.currentUser = authUser
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController {
    func showAlert(with title: String,message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
