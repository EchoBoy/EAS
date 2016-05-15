//
//  LessonGrade.swift
//  EAS
//
//  Created by 李航 on 4/14/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import Foundation
import SwiftyJSON

class Grade {
    let name: String
    //最终成绩
    let score: String
    //期末成绩
    let finalScore: String
    let credit: Double
    let lessonID: String
    let nature: Int
    let percent: Double
    
    func getNumberScore() -> Double {
        
        let convertTable: [String:Double] = ["差":50,"及格":60,"合格":60,"中":70,"良":80,"优":90]
        
        var numberScore:Double = 0

        if let _numberScore = Double(score) {
            numberScore = _numberScore
        }else {
            if let __numberScore = convertTable[score] {
                numberScore = __numberScore
            }else {
                NSLog("Grade.score convert error.Can't convert \(score)")
            }
        }
        return numberScore
    }
//    
//    init(name:String, score:String, credit:Double, lessonID:String, nature:Int, percent:Double) {
//        self.name = name
//        self.score = score
//        self.credit = credit
//        self.lessonID = lessonID
//        self.nature = nature
//        self.percent = percent
//    }
    
    init(jsonData jd: JSON){
        name = jd["name"].stringValue
        score = jd["grade"].stringValue
        credit = Double(jd["credit"].stringValue)!
        lessonID = jd["id"].stringValue
        nature = Int(jd["nature"].stringValue)!
        percent = 0
        finalScore = jd["score"].stringValue
    }
    
    init(cdoer aDercoder: NSCoder) {
        self.name = aDercoder.decodeObjectForKey("name") as! String
        self.score = aDercoder.decodeObjectForKey("score") as! String
        self.credit = aDercoder.decodeObjectForKey("credit") as! Double
        self.lessonID = aDercoder.decodeObjectForKey("lessonID") as! String
        self.nature = aDercoder.decodeObjectForKey("nature") as! Int
        self.percent = aDercoder.decodeObjectForKey("percent") as! Double
        self.finalScore = aDercoder.decodeObjectForKey("finalScore") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(name,forKey: "name")
        aCoder.encodeObject(score,forKey: "score")
        aCoder.encodeObject(credit,forKey: "credit")
        aCoder.encodeObject(lessonID,forKey: "lessonID")
        aCoder.encodeObject(nature,forKey: "nature")
        aCoder.encodeObject(percent,forKey: "percent")
        aCoder.encodeObject(finalScore,forKey: "finalScore")
    }
    
    func description() -> String{
        return "name:\(name)"
    }
}