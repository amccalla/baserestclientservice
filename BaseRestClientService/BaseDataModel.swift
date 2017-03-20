//
//  BaseDataModel.swift
//  RestClientExample
//
//  Created by Andrew McCalla on 6/30/16.

//

import ObjectMapper

open class BaseDataModel: StaticMappable {
    
    public class func objectForMapping(map: Map) -> BaseMappable? {
        return BaseDataModel()
    }
    
    public func mapping(map: Map) {
        // override in subclass
        //
    }
    
    public func jsonFormat() -> [String: AnyObject] {
        return self.toJSON() as [String : AnyObject]
    }
}
