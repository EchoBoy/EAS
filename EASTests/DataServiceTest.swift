import XCTest

@testable import EAS

class DataServiceTest: XCTestCase {
    let timeout:NSTimeInterval = 60
    var dataService:DataServiceProtocol = DataService(networkSevice: NetworkSever(serverIp: "52.38.238.245", serverPort: "3172"))
    
    func _testGetGrade() {
        let expectation = expectationWithDescription("login url")
        func call() {
            expectation.fulfill()
        }
        if let _ = dataService.getKey() {
            dataService.getGrade()
        }else {
           // dataService.login("1305110115", pwd: "HANGLI19951009")
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testTimeTable() {
        let expectation = expectationWithDescription("login url")
        func call() {
            expectation.fulfill()
        }
        if let _ = dataService.getKey() {
            dataService.getTimeTable()
        }else {
            dataService.login("1308070303", pwd: "fy04js0019")
        }
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    
}

class observing: DataObserving {
    
    func keyChange(key: String) {
        NSLog("new key \(key)")
    }
    
    func loginError(errorInfo:String) {
        NSLog("new errorInfo \(errorInfo)")
    }
    
    func gradeChange(grade:[Semester:[Grade]]) {
        NSLog("new grade \(grade)")
    }
    
    func timeTableChange(timeTable: [Semester:[Lesson]]) {
        NSLog("new timetable \(timeTable)")
    }
    
    func lessonNumberChange(lessonNumber:[[Int]]) {
        NSLog("new grade \(lessonNumber)")
    }
    
    func lessonDistributingChange(lessonDistributing:[[Int]]) {
        NSLog("new grade \(lessonDistributing)")
    }
    
    func creditPointChange(creditPoint:(creditPoint:Double,percent:Double?)) {
        NSLog("new grade \(creditPoint)")
    }
}