//
//  DataService.swift
//  EAS
//
//  Created by 李航 on 4/14/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataService: DataServiceProtocol {
    
    ///single pattern
    static var instance: DataServiceProtocol?
    
    class func getInstance() -> DataServiceProtocol? {
        return instance
    }
    
    class func setInstance(networkService: NetworkServiceProtocol) {
        instance = DataService(networkSevice: networkService)
    }
    
    //json文件的路径
    let loginJson: NSURL
    let gradeJson: NSURL
    let timeTableJson: NSURL
    
    var observing: DataObserving?
    var loginObserving: LoginObserving?
    var networkService: NetworkServiceProtocol
    
    //登录信息
    var key: String? {
        didSet{
            //当key改变的时候自动更新grade和timetable
            if let _key = key {
                loginObserving?.keyChange(_key)
                loadGrade()
                loadTimeTable()
            }
        }
    }
    var errorInfo: String? {
        didSet{
            if let _errorInfo = errorInfo { loginObserving?.loginError(_errorInfo) }
        }
    }
    
    //课表信息
    var timeTable:([Semester:[Lesson]])? {
        didSet{
            if let _timeTable = timeTable {
                observing?.timeTableChange(_timeTable)
                updateLessonNumber()
            }
        }
    }
    //成绩信息
    var grade:([Semester:[Grade]])? {
        didSet{
            if let _grade = grade { observing?.gradeChange(_grade) }
        }
    }
    
    //每一周上的课数
    var lesssonNumber: [[Int]]? {
        didSet{
            if let _lessonNumber = lesssonNumber { observing?.lessonNumberChange(_lessonNumber) }
        }
    }
    //课程在每一天不同时间段的分布
    var lessonDistributing: [[Int]]? {
        didSet{
            if let _lessonDistributing = lessonDistributing { observing?.lessonDistributingChange(_lessonDistributing) }
        }
    }
    //学分
    var creditPoint: (creditPoint:Double, percent:Double?)? {
        didSet{
            if let _creditPoint = creditPoint { observing?.creditPointChange(_creditPoint) }
        }
    }
    
    
    
    init(networkSevice: NetworkServiceProtocol){
        self.networkService = networkSevice
        loginJson = Path.login.getFileURL()
        gradeJson = Path.grade.getFileURL()
        timeTableJson = Path.timetable.getFileURL()
    }
    
    ///设置观察者
    func setObserving(observing: DataObserving?) {
        self.observing = observing
    }
    
    func setLoginObserving(loginObserving: LoginObserving?) {
        self.loginObserving = loginObserving
    }
    
    
    
    //resolving the login.json info
    func loadKey() {
        NSLog("Start loadKey")
        let content = _readFileContent(loginJson)
        let json = JSON.parse(content)
        if json["LoginSucceed"].string == "yes" {
            key = json["Key"].string
            NSLog("loadKey succeed the key is \(key)")
        }else {
            errorInfo = json["ErrorInfo"].string
            NSLog("loadKey  error ")
        }
        NSLog("end loadKey")
    }
    
    //从json文件中解析timetable
    func loadTimeTable() {
        NSLog("Start loadTimeTable")
        let content = _readFileContent(timeTableJson)
        let json = JSON.parse(content)
        
        if content.isEmpty {
            assert(key != nil, "load timetable from network,key can't be nil")
            networkService.getTimeTable(key!, callBack: self.loadTimeTable)
        }else {
            
            var _timeTable = [Semester:[Lesson]]()
            
            //只有json不为空才进行解析
            
            //一到八学期循环
            for i in 1...8 {
                let key = String(i)
                
                var timetables = [Lesson]()
                if let oneSemesterTimeTable = json[key].array {
                    for singleTimeTableJson in oneSemesterTimeTable {
                        
                        let singleTimeTable = Lesson(jsonData: singleTimeTableJson)
                        
                        timetables.append(singleTimeTable)
                    }
                    _timeTable[Semester(rawValue: i)!] = timetables
                }
            }
            timeTable = _timeTable
            NSLog("loadTimeTable succeed")
        }
        NSLog("end loadTimeTable")
    }
    
    //resolving the grade.json info
    func loadGrade() {
        NSLog("Start loadGrade")
        let content = _readFileContent(gradeJson)
        let json = JSON.parse(content)
        
        if content.isEmpty {
            assert(key != nil, "load grade from network,key can't be nil")
            networkService.getGrade(key!, callBack: self.loadGrade)
        }else {
            
            var _grade = [Semester:[Grade]]()

            //只有json不为空才进行解析
            
            //一到八学期循环
            for i in 1...8 {
                let key = String(i)
                
                var grades = [Grade]()
                if let oneSemesterGrade = json[key].array {
                    for singleGradeJson in oneSemesterGrade {
                        
                        let singleGrade = Grade(jsonData: singleGradeJson)
                        
                        grades.append(singleGrade)
                    }
                    _grade[Semester(rawValue: i)!] = grades
                }
            }
            grade = _grade
            NSLog("loadGrade succeed")
        }
        NSLog("end loadGrade")
    }
    
    //返回key,如何loadkey之后key还是为nil,表示需要登录
    func getKey() -> String? {
        if key == nil {
            loadKey()
        }
        return key
    }
    
    //get timetable
    func getTimeTable() -> [Semester:[Lesson]]? {
        if getKey() == nil {
            return nil
        }
        if timeTable == nil {
            loadTimeTable()
        }
        return timeTable
    }
    
    func getTimeTable(semester: Semester) -> [Lesson]? {
        let timeTable = getTimeTable()
        return timeTable?[semester]
    }
    
    func getCurrentSemester() -> Semester? {
        let keys = getTimeTable()?.keys
        let max = keys?.maxElement{$0.0.rawValue<$0.1.rawValue}
        return max
    }
    
    //get grade
    func getGrade() -> [Semester:[Grade]]? {
        if getKey() == nil {
            return nil
        }
        if grade == nil {
            loadGrade()
        }
        return grade
    }
    func getGrade(semester: Semester) -> [Grade]? {
        let grade = getGrade()
        return grade?[semester]
    }
    
    //每一周课程上的课数
    func getLessonNumber() -> [[Int]]? {
        if lesssonNumber == nil {
            updateLessonNumber()
        }
        return lesssonNumber
    }
    func updateLessonNumber() {
        if let _timeTables = timeTable {
            var _lessonNumbers = [Int]()
            for i in 1...8 {
                if let lesssons = _timeTables[Semester(rawValue: i)!] {
                    _lessonNumbers.append(lesssons.count)
                }
            }
            if lesssonNumber == nil {
                lesssonNumber = [[Int]]()
            }
            lesssonNumber?.append(_lessonNumbers)
        }
    }
    
    func getLessonDistributing() -> [[Int]]? {
        return lessonDistributing
    }
    func getCreditPoint(semester:Semester) -> (creditPoint: Double, percent: Double?)? {
        return creditPoint
    }
    
    func login(no: String, pwd: String) {
        networkService.login(no, password: pwd, callBack: self.loadKey)
    }
    func clearAllData(){
        //删除文件
        _saveToFile("", URL: Path.login.getFileURL())
        _saveToFile("", URL: Path.grade.getFileURL())
        _saveToFile("", URL: Path.timetable.getFileURL())
        //清除数据
        key = nil
        errorInfo = nil
        timeTable = nil
        grade = nil
        lesssonNumber = nil
        lessonDistributing = nil
        creditPoint = nil
    }
   
    func _redFileDebugFileContent(path: String) -> String{
        var content = NSString()
        do {
            try content = NSString(contentsOfFile: path, encoding:NSUTF8StringEncoding)
        }catch {
            NSLog("read \(path) failed! with debug mode")
        }
        return content as String
    }
    
    func _readFileContent(URL: NSURL) -> String {
        var content = NSString()
        do {
            try content = NSString(contentsOfURL: URL, encoding: NSUTF8StringEncoding)
            NSLog("read \(URL.description) succeed")
        }catch {
            NSLog("read \(URL.description) fail")
        }

        return content as String
    }
    
    func _saveToFile(content: String, URL: NSURL) {
        do {
            try content.writeToURL(URL, atomically: false, encoding: NSUTF8StringEncoding)
            NSLog("write \(URL.description) file succeed")
        }catch {
            NSLog("write \(URL.description) file faile!")
        }
    }
    
    func debugCopyData() {
        let loginContent = _redFileDebugFileContent(Path.login.getDebugFilePath())
        _saveToFile(loginContent, URL: Path.login.getFileURL())
        
        let gradeContent = _redFileDebugFileContent(Path.grade.getDebugFilePath())
        _saveToFile(gradeContent, URL: Path.grade.getFileURL())
        
        let timeTable = _redFileDebugFileContent(Path.timetable.getDebugFilePath())
        _saveToFile(timeTable, URL: Path.timetable.getFileURL())
    }
}




