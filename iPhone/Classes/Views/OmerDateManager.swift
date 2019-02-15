//
//  OmerDayUpdates.swift
//  Omer_Flash_Card
//
//  Created by Mahadev Prasad on 10/22/18.
//
import Foundation
import UIKit
import Alamofire

@objc class OmerDateManager: NSObject {
    
    static let shared: OmerDateManager = {
        let object = OmerDateManager()
        if let dict = UserDefaults.standard.value(forKey: "omedDayDetails") as? NSDictionary {
            object.setWith(dictionary: dict)
        }
        return object
    }()
    
    public var day: Int?
    public var month : Int?
    public var year : Int?
    
    
    public func setWith(dictionary: NSDictionary) {
        day = dictionary["day"] as? Int
        month = dictionary["month"] as? Int
        year = dictionary["year"] as? Int
        
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.day, forKey: "day")
        dictionary.setValue(self.month, forKey: "month")
        dictionary.setValue(self.year, forKey: "year")
        return dictionary
    }
    
    public func saveWith(dictionary: NSDictionary) {
        self.setWith(dictionary: dictionary)
        UserDefaults.standard.setValue(dictionary, forKey: "omedDayDetails")
        UserDefaults.standard.synchronize()
    }
    
}
