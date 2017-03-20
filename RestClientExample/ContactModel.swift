//
//  ContactModel.swift
//  RestClientExample
//
//  Created by Andrew McCalla on 7/8/16.

//

import ObjectMapper

class ContactModel: BaseDataModel {
    var name: String!
    var number: String!
    var email: String!
    var company: String!
    
    public override class func objectForMapping(map: Map) -> BaseMappable? {
        return ContactModel()
    }
    
    //Set up backend to object mappings
    //
    override func mapping(map: Map) {
        name <- map["name"]
        number <- map["number"]
        email <- map["email"]
        company <- map["company"]
    }
}
