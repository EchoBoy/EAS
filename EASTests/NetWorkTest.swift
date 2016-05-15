//
//  NetWorkTest.swift
//  EAS
//
//  Created by 李航 on 4/26/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import XCTest
import Alamofire
@testable import EAS

class NetWorkTest: XCTestCase {
    
    let timeout:NSTimeInterval = 30
    let network = NetworkSever(serverIp: "52.38.238.245", serverPort: "3172")
    
    func _testLogin() {
        let expectation = expectationWithDescription("login url")
        
        func call() {
            expectation.fulfill()
        }
        
        network.login("1305110115", password: "HANGLI19951009", callBack: call)
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func _testGrade() {
        let expectation = expectationWithDescription("login url")
        
        func call() {
            expectation.fulfill()
        }
        
        network.getGrade("2bb47040602afddc8c0783f4a22d489d746e553d4063c258d797aee47ee2d8dd", callBack: call)
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
}
