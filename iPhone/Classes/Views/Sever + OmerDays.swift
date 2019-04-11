//
//  Sever + OmerDays.swift
//  Omer_Flash_Card
//
//  Created by Mahadev Prasad on 10/22/18.
//

import Foundation
import AVKit

extension Server {
    
    @objc func getOmerDatesByYear(id:String , completion: @escaping (NSArray?, Error?) -> Void) {
        let url = "https://www.hebcal.com/hebcal/?v=1&cfg=json&maj=off&min=off&mod=off&nx=off&year=\(id)&month=x&ss=off&mf=off&c=off&geo=none&m=0&s=off&o=on"
        self.get(url) { (response, error) in
            if let res = response  {
                if let data = res["items"] as? NSArray {
                    print(res)
                    Server.shared.array = AllItems.modelsFromDictionaryArray(array: data)
                    completion(data as NSArray,nil)
                }
            }
        }
    }
}

extension String {
    
    func startDateDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    func startDateMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    func startDateYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
}
