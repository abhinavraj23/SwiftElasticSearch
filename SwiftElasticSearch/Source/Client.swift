//
//  SwiftElasticSearch.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel And Abhinav Raj
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit

/// Entry point in the SwiftElasticSearch library
///
public class Client : NSObject {
    
    // MARK: - Properties
    
    public var url : String
    public var app : String
    public var credentials : String
    var APIkey : Request?
    let util = Utils()
    
    // MARK: - Initializer
    
/// Creates an Elastic Search class object for Appbase
///
/// - parameter url: URL of the server (If application is hosted on Appbase, url should be scalr.api.appbase.io)
/// - parameter appID: Name of the application
/// - parameter credentials: User credentials for authentication (Read Key)
///
/// - returns: SwiftElasticSearch class Object
///
    public init(url : String, app : String, credentials : String) {
        self.url = url
        self.app = app
        self.credentials = credentials
        self.APIkey = Request(credentials : credentials)
    }
    
    // MARK: - Operations
    
/// Adds given JSON data to the database (POST/PUT request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query (Can be nil)
/// - parameter body: Data that needs to indexed. The data must be in valid JSON format. Eg :
///                     let updateParameters:[String:Any] = [
///                         "doc": [
///                            "year": 2018
///                        ]
///                 ]
///                For more information : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document)
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func index(type: String, id : String? = nil, body : [String : Any], completionHandler: @escaping (Any?, Error?) -> ()) {
  
        var method = "POST"
        if id != nil {
            method = "PUT"
        }
            
        APIkey!.postData(url: url, method: method, app: app, type: type, id: id, body: body) { ( JSON, error ) in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
    
    
/// Fetches data from the database for the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func get(type: String, id: String, completionHandler: @escaping (Any?, Error?) -> ()) {
        
        APIkey?.getData(url: url, app: app, type: type, id: id) {
            JSON, error in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
    
    
/// Deletes data from the database for the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func delete(type: String, id : String, completionHandler: @escaping (Any?, Error?) -> ()) {
        
        APIkey!.deleteData(url: url, app: app, type: type, id: id) {
            JSON, error in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
    
    
/// Update data of the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
/// - parameter body: JSON structured data parameter that has to be passed for updating, Note: For updating data, the JSON
///                must be of the format doc{ JSON FOR THE PARAMETER TO BE UPDATED }. Eg :
///                let updateParameters:[String:Any] = [
///                        "doc": [
///                            "year": 2018
///                            ]
///                        ]
///                For more information : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document)
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func update(type: String, id : String, body : [String : Any], completionHandler: @escaping (Any?, Error?) -> ()) {
        
        let method = "POST"
        let updateID = id + "/_update"
        
        APIkey!.postData(url: url, method: method, app: app, type: type, id: updateID, body: body) { ( JSON, error ) in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
    
}
