//
//  ServiceProtocol.swift
//  EAS
//
//  Created by 李航 on 4/14/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

protocol NetworkServiceProtocol {
    
    func login(studentno: String, password: String, callBack: (() -> Void)? )
    
    func getTimeTable(key: String, callBack: (() -> Void)? )
    
    func getGrade(key: String, callBack: (() -> Void)? )
    
    func getAnalyse(key: String, callBack: (() -> Void)? )
}

protocol DataServiceProtocol {
    //return login key
    func getKey() -> String?
    
    //return now semester lesssons
    func getTimeTable() -> [Semester:[Lesson]]?
    
    //return the semester lessons. semester: 1-8
    func getTimeTable(semester: Semester) -> [Lesson]?
    
    //return all grade
    func getGrade() -> [Semester:[Grade]]?
    
    //return the semester grade
    func getGrade(semester: Semester) -> [Grade]?
    
    //return user each semester lesson numbers
    func getLessonNumber() -> [[Int]]?
    
    //return user lesson distributing
    func getLessonDistributing() -> [[Int]]?
    
    func getCurrentSemester() -> Semester?

    //return credit point
    func getCreditPoint(semester:Semester) -> (creditPoint:Double,percent:Double?)?
    
    func setObserving(observing: DataObserving?)
    
    func setLoginObserving(loginObserving: LoginObserving?)
    
    func login(no:String, pwd:String)
    
    func clearAllData()
    
    func debugCopyData()
    
}
protocol LoginObserving {
    
    func keyChange(key: String)
    
    func loginError(errorInfo:String)
}

protocol DataObserving {
    
    func gradeChange(grade:[Semester:[Grade]])
    
    func timeTableChange(timeTable: [Semester:[Lesson]])
    
    func lessonNumberChange(lessonNumber:[[Int]])
    
    func lessonDistributingChange(lessonDistributing:[[Int]])
    
    func creditPointChange(creditPoint:(creditPoint:Double,percent:Double?))
}