BaseRestClientService
===============

BaseRestClientService is a wrapper class for handling Rest services api calls. It abstracts most of the common functionalities so that we can easily constructer network service layer in application just subclassing this and adding minimal override functions.

This pod also have template attached to it which can be easily adding to your local template directory and create service class with rep skeleton.

<br/>

##Requirements
BaseRestClientService works on iOS 8.0 and greater. It requires Xcode 7.0 or greater, as it uses Swift 2.0.

<br/>
##Usage

###Step 1: Installing templates to your xcode
After installing pod you will have BaseRestService.xctemplates. Copy BaseRestService.xctemplates and paste it in ~/Library/Developer/xcode/templates/

<br/>
###Step 2: Setup Host url
In  your project info.plist file please added property row with key "HostUrl" and value as base url for your rest service. Here in Demo we are using apiary so we added HostUrl as "http://private-3cc05-contactsdemo1.apiary-mock.com".

<br/>
###Step 3: Create need service classes base on BaseRestClientService.swift

Add a new file by selecting BaseRestService under iOS/Templates as shown in figure below


Complete the `resourcePath()` by returning proper path for this service.

create appropriate method based on service actions (POST/GET)

use
<br/>
    `retriveArrayWith(success: ([T] -> Void), failure:(errorMessage: String, data: NSData?)-> Void)`
or
<br/>
    `retrieveJSONDataWith(success: (data: [String : AnyObject]) -> Void, failure:((errorMessage: String, data: NSData?) -> Void)?)`

methods to GET data from service.

simillar you can you proper post method to do post.

For example in RestClientDemoService.swift we have `retriveContacts()` which do GET all contact

    retriveArrayWith({ (contacts: [ContactModel]) in
        // do any additional operations here like save the context for core data/ some business logic etc.
        //
        self.completionHanlder?.handleSuccessFor(self, contacts: contacts)
    }) { (errorMessage, data) in
        self.completionHanlder?.handleFailureFor(self, errorMessage: errorMessage)
    }

here completionHandler is delegate which is invokes success and failure call back to particular controllers to handle the updates based on service response.

now you have create service layer. To use the services you just created please create a lazy loading property like

    lazy var contactsService: RestClientDemoService = RestClientDemoService(handler: self)

This property can be used in appropiate please to retrive/post object to API services. Also implement protocol methods in controller to handle success/failure cases.

### Step 4: Creating Data models
When creating datamodel objects Please override mapping(map: Map)
`name <- map["name"] 
 number <- map["number"]
 email <- map["email"]
 company <- map["company"]`
