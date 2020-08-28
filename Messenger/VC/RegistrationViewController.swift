//
//  RegistrationViewController.swift
//  Messenger
//
//  Created by Леонид on 31.07.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    var newUser: MUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        AuthServices.shared.register(email: emailTextField.text,
                      name: nicknameTextField.text,
                      password: passwordTextField.text,
                      confirmPassword: confirmPasswordTextField.text) { (result) in
                        switch result {
                            
                        case .success(let user):
                            
                            FirestoreService.shared.saveProfileWith(id: user.uid,
                                                      email: user.email!,
                                                      username: self.nicknameTextField.text!) { (result) in
                                switch result {
                                    
                                case .success(let user):
                                    self.newUser = user
                                    self.performSegue(withIdentifier: "signUpWithEmail", sender: self)
                                case .failure(let error):
                                    self.showAlert(with: "Error", message: error.localizedDescription)
                                }
                            }
                        case .failure(let error):
                            self.showAlert(with: "Error", message: error.localizedDescription)
                        }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UINavigationController
        let chatVC = vc.topViewController as! ChatsViewController
        chatVC.currentUser = newUser
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

extension RegistrationViewController {
    func showAlert(with title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
