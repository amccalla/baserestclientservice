//
//  RestClientDemoService.swift
//  RestClientExample
//
//  Created by Andrew McCalla on 7/8/16.

//

protocol RestClientDemoServiceCompletionHandler: class {
    func handleSuccessFor(_ service: RestClientDemoService, contacts: [ContactModel])
    func handleFailureFor(_ service: RestClientDemoService, errorMessage: String)
}

class RestClientDemoService: BaseRestClientService {
    
    weak var completionHandler: RestClientDemoServiceCompletionHandler?
    
    init(handler: RestClientDemoServiceCompletionHandler?) {
        super.init()
        self.completionHandler = handler
    }
    
    func retriveContacts() {
        
        retriveArrayWith({ (contacts: [ContactModel]) in
            // do any additional operations here like save the context for core data/ some business logic etc.
            //
            self.completionHandler?.handleSuccessFor(self, contacts: contacts)
            }) { (errorMessage, data) in
                self.completionHandler?.handleFailureFor(self, errorMessage: errorMessage)
        }
    }
    
    func addContact(_ contact: ContactModel, successHandler: (()->Void)?) {
        postObjectWith(contact, success: { (contact) in
            successHandler?()
        }) { (errorMessage, data) in
            self.completionHandler?.handleFailureFor(self, errorMessage: errorMessage)
        }
    }
    
    override func resourcePath() -> String {
        return "/contacts"
    }
}
