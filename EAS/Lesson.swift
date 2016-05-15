//
//  Lesson.swift
//  EAS
//
//  Created by 李航 on 4/14/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import Foundation
import SwiftyJSON

class Lesson: NSObject {
    let name: String
    let day: Int
    let nature: String
    let time: String
    let teacher: String
    let location: String
    let duration: (start: Int,end: Int)
    let singleWeek:Bool
    
    
    init(day:Int,name:String, nature:String, time:String, teacher:String, location:String, duration:(Int,Int), singleWeek:Bool) {
        self.day = day
        self.name = name
        self.nature = nature
        self.time = time
        self.teacher = teacher
        self.location = location
        self.duration = duration
        self.singleWeek = singleWeek
    }
    
    init(jsonData jd:JSON) {
        name = jd["name"].stringValue
        nature = jd["nature"].stringValue
        time = jd["period"].stringValue
        teacher = jd["teacher"].stringValue
        location = jd["location"].stringValue
        day = Int(jd["day"].stringValue)!
        let jd_duration = jd["duration"].stringValue
        let duration_list = jd_duration.componentsSeparatedByString("-")
        let duration_start = Int(duration_list[0])!
        let duraton_end = Int(duration_list[1])!
        duration = (duration_start,duraton_end)
        singleWeek = false
        
    }
    
    init(coder aDercoder: NSCoder) {
        self.name = aDercoder.decodeObjectForKey("name") as! String
        self.nature = aDercoder.decodeObjectForKey("nature") as! String
        self.time = aDercoder.decodeObjectForKey("time") as! String
        self.teacher = aDercoder.decodeObjectForKey("teacher") as! String
        self.location = aDercoder.decodeObjectForKey("location") as! String
        let start = aDercoder.decodeObjectForKey("durationStart") as! Int
        let end = aDercoder.decodeObjectForKey("durationEnd") as! Int
        self.singleWeek = aDercoder.decodeObjectForKey("singleWeek") as! Bool
        self.duration = (start,end)
        day = aDercoder.decodeObjectForKey("day") as! Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        let (start,end) = duration
        aCoder.encodeObject(name,forKey: "name")
        aCoder.encodeObject(nature,forKey: "nature")
        aCoder.encodeObject(time,forKey: "time")
        aCoder.encodeObject(teacher,forKey: "teacher")
        aCoder.encodeObject(location,forKey: "location")
        aCoder.encodeObject(start,forKey: "durationStart")
        aCoder.encodeObject(end,forKey: "durationEnd")
        aCoder.encodeObject(singleWeek,forKey: "singleWeek")
        aCoder.encodeObject(day,forKey: "day")
    }
}


