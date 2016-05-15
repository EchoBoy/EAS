//
//  EASTests.swift
//  EASTests
//
//  Created by 李航 on 4/7/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import XCTest
import Alamofire

@testable import EAS

class EASTests: XCTestCase {
    
    func testAlamofire() {
        NSLog(Path.grade.getFilePath())
        NSLog(Path.grade.getFileURL().description)
    }
    
}
