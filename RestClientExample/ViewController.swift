//
//  ViewController.swift
//  RestClientExample
//
//  Created by Andrew McCalla on 6/30/16.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var contactsTableView: UITableView!
    var contacts:[ContactModel] = []
    lazy var contactsService: RestClientDemoService = RestClientDemoService(handler: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        contactsService.retriveContacts()
    }

    @IBAction func refrestContacts(_ sender: AnyObject) {
        contactsService.retriveContacts()
    }
    
    @IBAction func addContact(_ sender: AnyObject) {
        let dummyContact = ContactModel()
        dummyContact.name = "Test"
        dummyContact.company = ""
        dummyContact.email = "test@its..com"
        dummyContact.number = "9081231234"
        contactsService.addContact(dummyContact, successHandler: { () -> Void  in
            self.contacts.append(dummyContact)
            let messageAlert = UIAlertController(title: "Success!", message: "Contact added to Directory", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            messageAlert.addAction(cancelAction)
            DispatchQueue.main.async {
                self.present(messageAlert, animated: true, completion: nil)
                self.contactsTableView.reloadData()
            }
        })
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCellId", for: indexPath)
        let contact = contacts[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(contact.name)  (\(contact.company))"
        cell.detailTextLabel?.text = contact.number
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[(indexPath as NSIndexPath).row]
        if let telephone = URL(string: "tel://\(contact.number)") {
            UIApplication.shared.openURL(telephone)
        }
    }

}

extension ViewController: RestClientDemoServiceCompletionHandler {
    func handleFailureFor(_ service: RestClientDemoService, errorMessage: String) {
        let errorAlert = UIAlertController(title: "Sorry!", message: errorMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.contactsService.retriveContacts()
        }
        errorAlert.addAction(cancelAction)
        errorAlert.addAction(retryAction)
        DispatchQueue.main.async { 
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func handleSuccessFor(_ service: RestClientDemoService, contacts: [ContactModel]) {
        self.contacts = contacts
        DispatchQueue.main.async { 
            self.contactsTableView.reloadData()
        }
    }
}

