//
//  address.swift
//  EAS
//
//  Created by 李航 on 4/29/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import Foundation

//the keyword of option about file and networkpath
enum Path:String {
    case login = "login"
    case grade = "grade"
    case timetable = "timetable"
    
    
    //get the file path
    func getDebugFilePath() -> String {
        let filePath = NSBundle.mainBundle().pathForResource(self.rawValue, ofType: "json")
        if let _filePath = filePath {
            return _filePath
        }else {
            assert(false, "can't find file \(self.rawValue) Path")
        }
    }
    
    func getFileURL() -> NSURL {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(self.rawValue)
            return path
        }else {
            assert(false,"can't find file \(self.rawValue) URL")
        }
    }
}