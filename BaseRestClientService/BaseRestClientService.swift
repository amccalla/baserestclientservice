//
// BaseRestClientService.swift

//  Created by Andrew McCalla on 06/30/16.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

open class BaseRestClientService: NSObject {

    let defaultErrorMessage = "Unable to process your request. Please try again later."

    // creates GET request
    //
    func getRequest() -> DataRequest {
        return request(url(), method: .get, parameters: nil, encoding: URLEncoding.default, headers: requestHeader())
    }
    
    // create POST request with given body
    //
    func postRequestFor(_ body: [String: AnyObject]?) -> DataRequest {
        return  request(url(), method: .post, parameters: body, encoding: JSONEncoding.default, headers: requestHeader())
    }

    // returns url for which request should be made.
    //
    func url() -> String {
        return baseURL() + resourcePath()
    }

    // Must be override by sub classes
    open func resourcePath() -> String {
        assertionFailure("\(#file) \(#function), ERRORMESSAGE: This method must be override by a sub-class")
        return ""
    }

    // for every request we are sending time stamp and time zone
    // Override this method to pass custom req headers
    //
    open func requestHeader() -> [String: String] {
        let headers: [String: String] = ["UserTimeStamp":NSDate().description]
        return headers
    }
    
    // This method parse the given server error message 
    //
    open func errorMessageFromResponse(_ data: Data?) -> String {
        if let responseData = data {
            do {
                if let errorDictionary = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: String] {
                    let errorMessage = errorDictionary["errorMessage"] ?? ""
                    return errorMessage
                }
            } catch {
                print("Error in parsing error message from server response.")
            }
        }
       return defaultErrorMessage
    }
    
    // returns base url from plist
    //
    open func baseURL() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "HostUrl") as! String
    }
    
    //MARK: GET - methods
    
    // do the get request and try to parse the response json data and call proper closure based on request result
    //
    open func retrieveJSONDataWith(_ success: @escaping (_ data: [String : AnyObject]) -> Void, failure:((_ errorMessage: String, _ data: NSData?) -> Void)? ) {
        getRequest().validate().responseJSON { (response: DataResponse<Any>) in
            if response.result.isSuccess {
                if let jsonData = response.result.value as? [String : AnyObject] {
                    success(jsonData)
                } else {
                 failure?("unable to parse response", nil)
                }
            } else {
                let message = self.errorMessageFromResponse(response.data)
                failure?(message,response.data as NSData?)
            }
        }
    }
    
    // do the get request where expected response is an Array of object 
    //
    open func retriveArrayWith<T: BaseDataModel>(_ success: @escaping (([T]) -> Void), failure:@escaping (_ errorMessage: String, _ data: NSData?)-> Void ) {
        getRequest().validate().responseArray { (response: DataResponse<[T]>) in
            if response.result.isSuccess {
                if let responseData = response.result.value {
                    success(responseData)
                } else {
                    success([])
                }
            } else {
                let error = self.errorMessageFromResponse(response.data)
                failure(error, response.data as NSData?)
            }
            
        }
    }
    
    // do the get request and maps the response object
    //
    open func retriveObject<T: BaseDataModel>(_ success: @escaping ((T) -> Void), failure:@escaping (_ errorMessage: String, _ data: NSData?) -> Void) {
        getRequest().validate().responseObject { (response: DataResponse<T>) in
            if response.result.isSuccess {
                if let responseData = response.result.value {
                    success(responseData)
                } else {
                    failure(self.errorMessageFromResponse(nil), nil)
                }
            } else {
                let errorMessage = self.errorMessageFromResponse(response.data)
                failure(errorMessage, response.data as NSData?)
            }
        }
    }
    
    //MARK: POST methods
    
    // do the post requestion with given body and return mappable object if there is any
    //
    open func postWith<T: BaseDataModel>(_ body: [String : AnyObject]?, success: @escaping ((T?)-> Void), failure: @escaping (_ errorMessage: String, _ data: NSData?) -> Void) {
        let postRequest = postRequestFor(body)
        postRequest.validate().responseObject { (response: DataResponse<T>) -> Void in
            if response.result.isSuccess {
                success(response.result.value)
            } else {
                let errorMessage = self.errorMessageFromResponse(response.data)
                failure(errorMessage, response.data as NSData?)
            }
        }
    }
    
    
    // this method take any of the BaseDataModel and do a post 
    //
    open func postObjectWith<T: BaseDataModel>(_ object: T, success: @escaping ((T?)->Void), failure:@escaping (_ errorMessage: String, _ data: NSData?) -> Void) {
        let body = object.jsonFormat()
        postWith(body, success: success, failure: failure)
    }
}
