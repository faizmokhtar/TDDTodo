//
//  APIClient.swift
//  TDDTodo
//
//  Created by Faiz Mokhtar on 22/12/2016.
//  Copyright © 2016 faizmokhtar. All rights reserved.
//

import Foundation

protocol ToDoURLSession {
    func dataTaskWithURL(url: NSURL,
                         completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
}

class APIClient {
    lazy var session: ToDoURLSession = NSURLSession.sharedSession()
    
    var keychainManager: KeychainAccessible?
    
    func loginUserWithName(username: String, password: String,
                           completion: (ErrorType?) -> Void) {
        let allowedCharacters = NSCharacterSet(charactersInString: "/%&=?$#+-~@<>|\\*,.()[]{}^!").invertedSet
        guard let encodedUsername = username.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) else {
            fatalError()
        }
        guard let encodedPassword = password.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) else {
            fatalError()
        }
        
        guard let url = NSURL(string: "https://awesometodos.com/login?username=\(encodedUsername)&password=\(encodedPassword)") else {
            fatalError()
        }
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            if error != nil {
                completion(WebServiceError.ResponseError)
            }
            if let theData = data {
                do {
                    let responseDict = try NSJSONSerialization.JSONObjectWithData(theData, options: [])
                    let token = responseDict["token"] as! String
                    self.keychainManager?.setPassword(token, account: "token")
                } catch {
                    completion(error)
                }
            } else {
                completion(WebServiceError.DataEmptyError)
            }
        }
        task.resume()
    }
}

extension NSURLSession: ToDoURLSession {
    
}

enum WebServiceError: ErrorType {
    case DataEmptyError
    case ResponseError
}