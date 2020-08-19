//
//  LoginViewController.swift
//  Messenger
//
//  Created by Леонид on 14.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpWithEmail(_ sender: UIButton) {
        let auth = AuthServices()
        auth.login(email: emailTextField.text,
                   password: passwordTextField.text) { (result) in
                    switch result {
                        
                    case .success(let user):
                        self.showAlert(with: "Success", message: "Authorisation completed!")
                    case .failure(let error):
                        self.showAlert(with: "Error", message: error.localizedDescription)
                    }
        }
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

extension LoginViewController{
    func showAlert(with title: String,message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
