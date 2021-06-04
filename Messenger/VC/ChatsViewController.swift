//
//  ChatsViewController.swift
//  Messenger
//
//  Created by Леонид on 22.08.2020.
//  Copyright © 2020 LSDevStudy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatsViewController: UITableViewController {
    @IBOutlet weak var NavigationBar: UINavigationItem!
    
    var currentUser: MUser?
    var chats = [MChat]()
    var selectedChat: MChat?
    
    private var chatsListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationBar.title = currentUser?.username
        self.tableView.dataSource = self
        
        chatsListener = ListenerService.shared.chatsObserve(chats: chats, completion: { (result) in
            switch result {

            case .success(let chats):
                self.chats = chats
                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(with: "Error", message: error.localizedDescription)
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //MARK: - Bar button Actions
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            chatsListener?.remove()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            UIApplication.shared.windows.first?.rootViewController = storyboard.instantiateViewController(identifier: "AuthController")
        } catch {
            
        }
    }
    
    @IBAction func addNewChat(_ sender: UIBarButtonItem) {
        showSearchAlert { (username) in
            FirestoreService.shared.searchUser(searchingUser: username) { (result) in
                switch result {
                    
                case .success(let muser):
                    FirestoreService.shared.createChat(reciever: muser) { (result) in
                        switch result {
                            
                        case .success(let chat):
                            self.selectedChat = chat
                            self.performSegue(withIdentifier: "newChat", sender: nil)
                        case .failure(let error):
                            self.showAlert(with: "Error", message: error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    self.showAlert(with: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChat = chats[indexPath.row]
        performSegue(withIdentifier: "selectedChat", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        cell.nameLabel.text = chats[indexPath.row].username
        cell.lastMessageLabel.text = chats[indexPath.row].lastMessage
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MessageViewController
        vc.currentUser = currentUser
        vc.chat = selectedChat
    }
    

}
