//
//  Sever.swift
//  EAS
//
//  Created by 李航 on 4/11/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//


import Foundation
import Alamofire

class NetworkSever: NetworkServiceProtocol {
    
    let server_ip:String
    let server_port:String
    
    init(serverIp ip:String, serverPort port:String) {
        self.server_ip = ip
        self.server_port = port
    }
    
    //save login info to info.json
    func login(studentno: String, password: String, callBack: (() -> Void)?) {
        NSLog("Start network login")
        let op = Path.login
        let para = ["sid":studentno,"pwd":password]
        let method = Method.POST
        
        Alamofire.request(method, _getURL(op.rawValue),parameters: para)
            .responseString { response in
                let result = response.result.value!
                NSLog("\(op.rawValue) connect succeed result is: \(result)")
                self._saveToFile(result, URL: op.getFileURL())
                if let _callBack = callBack {
                    _callBack()
                }
        }
    }
    
    //save grade info to grade.json
    func getGrade(key: String, callBack: (() -> Void)?) {
        NSLog("start network getGrade")
        let op = Path.grade
        let para = ["Key":key]
        let method = Method.GET
        
        Alamofire.request(method, _getURL(op.rawValue),parameters: para)
            .responseString { response in
                let result = response.result.value!
                NSLog("\(op.rawValue) connect succeed result is: \(result)")
                self._saveToFile(result, URL: op.getFileURL())
                if let _callBack = callBack {
                    _callBack()
                }
        }
    }
    
    func getTimeTable(key: String, callBack: (() -> Void)?) {
        NSLog("start network getTimeTable")
        let op = Path.timetable
        let para = ["Key":key]
        let method = Method.GET
        
        Alamofire.request(method, _getURL(op.rawValue),parameters: para)
            .responseString { response in
                let result = response.result.value!
                NSLog("\(op.rawValue) connect succeed result is: \(result)")
                self._saveToFile(result, URL: op.getFileURL())
                if let _callBack = callBack {
                    _callBack()
                }
        }

    }
    
    func getAnalyse(key: String, callBack: (() -> Void)?) {

    }
    

    
    //save string to file accroding address
    func _saveToFile(content: String, URL: NSURL) {
        do {
            
            try content.writeToURL(URL, atomically: false, encoding: NSUTF8StringEncoding)
        }catch {
            NSLog("write \(URL.description) file faile!")
        }
    }
    
    //get requtest url accroding keyword
    func _getURL(keyWord:String) -> String {
        return "http://\(server_ip):\(server_port)/\(keyWord)"
    }
}