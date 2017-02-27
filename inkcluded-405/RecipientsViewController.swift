/**
 * Controls the view for selecting recipients for a new message.
 *
 * RecipientsViewController.swift
 * inkcluded-405
 *
 * Created by Christopher on 1/30/17.
 * Copyright © 2017 Boba. All rights reserved.
 */

import Foundation
import UIKit

class RecipientsViewController: UIViewController, UITableViewDelegate,
                                UITableViewDataSource {
    @IBOutlet var friendsTableView: UITableView!
    
    var apiWrapper: APIWrapper? // The database interface
    var selectedRecipients = [User]()         // A list of selected recipients
    var friends : [User]?                     // A list of friends to select
    
    /**
     * Performs setup once the view loads.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Get the list of friends from the database.
        //apiWrapper = appDelegate.apiWrapper
        self.friends = [User]()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /**
     * Returns the number of cells required in the table.
     */
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return friends!.count;
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    /**
     * Sets the content of one cell in the table.
     */
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell from the table.
        let cell = self.friendsTableView.dequeueReusableCell(
                    withIdentifier: "friendCell") as! FriendTableViewCell
        // Get the corresponding friend from the list.
        let friend = self.friends?[indexPath.row];
        // Set the cell's text to be the friend's name.
        cell.textLabel?.text = friend!.firstName + " " + friend!.lastName
        
        return cell
    }
    
    /**
     * Responds to a cell's being selected.
     */
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        // Add the friend corresponding to the cell to the recipients list.
        let tempRecipient: User = (self.friends?[indexPath.row])!
        self.selectedRecipients.append(tempRecipient);
    }
    
    /**
     * Responds to a cell's being deselected.
     */
    func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath) {
        // Remove the friend corresponding to the cell from the recipients list.
        let tempRecipient: User = (self.friends?[indexPath.row])!
        //let tempIdx = 0//self.selectedRecipients.index(of: tempRecipient.id)
        self.selectedRecipients.remove(at: 0)
    }
    
    /**
     * Responds to the 'Select' button's being pressed.
     */
    @IBAction func selectPressed(_ sender: Any) {
        // If no recipients have been selected, do nothing.
        //if selectedRecipients.isEmpty {
        //    print("No recipients selected.")
        //}
        // Otherwise, create a new group using the selected recipients.
        //else {
            var members = [User]()
            
            print("Recipients:")
            for recipientIdx : User in selectedRecipients {
                let recipient = apiWrapper?.getFriendById(userId: recipientIdx.id)
                print("   \(recipient?.firstName) \(recipient?.lastName)")
            }
            // TODO: Pass this new group to the canvas view.
            apiWrapper?.createGroup(members: selectedRecipients, name: "New Group", closure: {(Group) -> Void in})
        
            // Segue to the canvas view.
            self.performSegue(withIdentifier: "newCanvasSegue", sender: self)
        //}
    }
}

