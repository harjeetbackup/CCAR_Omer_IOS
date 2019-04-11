//
//  Server.swift
//  Omer_Flash_Card
//
//  Created by Mahadev Prasad on 10/16/18.

import Foundation
import Alamofire

class Server: NSObject{
    
    @objc static let shared = Server()
    var array = [AllItems]()

    private func request(_ url: String, method: HTTPMethod, parameters: [String: Any]?, completion: @escaping ([String: Any]?, Error?)-> Void) {
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            print("**************************\n")
            print("********Request***********\n")
            print(url)
            print("**** Response *****")
            if let json = response.result.value {
                print(json) // serialized json response
            }
            print("**************************\n")
            guard let json = response.result.value as? [String: Any] else {
                print("**error** \(response.result.error) *****")
                completion(nil, response.result.error)
                return
            }
            completion(json , response.result.error)
        }
    }
    
    func post(_ url: String, parameters: [String: Any],headers:[String:String]?,completion: @escaping ([String: Any]?, Error?)-> Void) {
        self.request(url, method: .post, parameters: parameters, completion: completion)
    }
    
    func get(_ url: String, completion: @escaping ([String: Any]?, Error?)-> Void) {
        self.request(url, method: .get, parameters: nil, completion: completion)
    }
    
    func delete(_ url: String,parameters: [String: Any],headers:[String:String]?,completion: @escaping ([String: Any]?, Error?)-> Void) {
        self.request(url, method: .delete, parameters: parameters, completion: completion)
    }
    
    func put(_ url: String, headers:[String:String]?, completion: @escaping ([String: Any]?, Error?)-> Void) {
        self.request(url, method: .put, parameters: nil, completion: completion)
    }
    
    
}
