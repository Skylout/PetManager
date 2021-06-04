//
//  Alerts.swift
//  Messenger
//
//  Created by Леонид on 31.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import UIKit

extension AuthViewController {
    func showAlert(with title: String,message: String){
       let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
       alertController.addAction(okAction)
       present(alertController, animated: true, completion: nil)
   }
}

extension RegistrationViewController {
    func showAlert(with title: String,message: String){
       let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
       alertController.addAction(okAction)
       present(alertController, animated: true, completion: nil)
   }
}

extension LoginViewController {
    func showAlert(with title: String,message: String){
       let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
       alertController.addAction(okAction)
       present(alertController, animated: true, completion: nil)
   }
}

extension ChatsViewController {
    func showSearchAlert( completion: @escaping (String)->Void){
       let alertController = UIAlertController(title: "Search", message: "Enter username", preferredStyle: .alert)
        alertController.addTextField { (_) in
            
        }
        let searchAction = UIAlertAction(title: "Search", style: .default) { (_) in
            guard let username = alertController.textFields![0].text else { return }
            completion(username)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
       alertController.addAction(searchAction)
        alertController.addAction(cancel)
       present(alertController, animated: true, completion: nil)
   }
    
    func showAlert(with title: String,message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
//        present(alertController, animated: true, completion: nitry
//
//        try
        
    }
}


