//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Alamofire

protocol ___FILEBASENAMEASIDENTIFIER___CompletionHandler: class {
    func handleSuccessFor(service: ___FILEBASENAMEASIDENTIFIER___)
    func handleFailureFor(service: ___FILEBASENAMEASIDENTIFIER___, errorMessage: String)
}

class ___FILEBASENAMEASIDENTIFIER___: JNJBaseRestClientService {
    
    weak var completionHanlder:___FILEBASENAMEASIDENTIFIER___CompletionHandler?
    
    init(handler: ___FILEBASENAMEASIDENTIFIER___CompletionHandler?) {
        super.init()
        self.completionHanlder = handler
    }
    
    override func resourcePath() -> String {
        //TODO: Must Update this
        //
        return ""
    }
}
