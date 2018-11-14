//
//  SwiftElasticSearchTests.swift
//  SwiftElasticSearchTests
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import XCTest
@testable import SwiftElasticSearch

class SwiftElasticSearchTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }

    func testGetMethod() {
        
        guard let getURL = URL(string: "https://1YSEaFnBn:c0f90a88-771d-4f92-a9b4-6fe82d17cc72@scalr.api.appbase.io/SwiftClientES/SwiftClientES/AWbvtQKGUHDq8oqypAHx") else { return }
        let promise = expectation(description: "Simple Request")
        
        URLSession.shared.dataTask(with: getURL) { (data, response
            , error) in
            guard let data = data else { return }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                if let result = json as? NSDictionary {
                    
                    guard let type = result["_type"] else {
                        print("Result: Test failed")
                        return
                    }
                    
                    XCTAssertTrue(type as! String == "SwiftClientES")
                    print("Result: Test passed")
                    promise.fulfill()
                    
                }
            } catch let err {
                print("Err", err)
            }
            }.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testIndexMethod() {
        
        guard let indexURL = URL(string: "https://scalr.api.appbase.io/mysearchapp/aaaaa") else { return }
        
        let parameterDictionary = ["title" : "Sacred Games", "year" : "2017"]
        var request = URLRequest(url: indexURL)
        request.httpMethod = "POST"
        let credential : String = "jXvc5mwpF:4550125e-d34d-450a-8f20-01c504d20f4d"
        let data = (credential).data(using: String.Encoding.utf8)
        let credentials64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
        print(request)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let promise = expectation(description: "Simple Request")
        
        URLSession.shared.dataTask(with: indexURL) { (data, response
            , error) in
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                print(json)
                promise.fulfill()
            } catch let err {
                print("Err", err)
            }
            }.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
