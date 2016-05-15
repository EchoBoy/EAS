//
//  MyColor.swift
//  EAS
//
//  Created by 李航 on 5/3/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import Foundation
import UIKit

struct MyColor {
    static let _lessColors:[UInt32] = [
        0xFF6666,
        0xFFCC33,
        0x006699,
        0xFF9966,
        0x339933,
        0xFF9900,
        0xCC6600,
        0x99CC33,
        0x0099CC,
        0x33CC99,
        0xCC0066,
    ]
    
    static let gradeHeaderTextColor = UIColor(r: 2, g: 123, b: 255)
    
    static let gradeHeaderBackgroundColor = UIColor(hexColor: 0xfafafa)
    
    static let gradeDefaultTextColor = UIColor.blackColor()
    
    static let gradeGoodTextColor = UIColor.greenColor()
    
    static let gradeBadTextColor = UIColor.redColor()
    
    static let currentDayLessonTextColor = UIColor.whiteColor()
    
    static let defaultLessonTextColor = UIColor.blackColor()
    
    static func lesssonColor(lessons:[Lesson]) -> [Lesson:UIColor]{
        //让课程重复的课程颜色一样
        var haveColor = [String:UIColor]()
        var result = [Lesson:UIColor]()
        var i = 0
        for le in lessons {
            if let color = haveColor[le.name]{
                result[le] = color
            }else {
                let newColor = UIColor(hexColor: _lessColors[i])
                
                result[le] = newColor
                haveColor[le.name] = newColor
                i += 1
                if i == _lessColors.count {
                    i = 0
                }
            }
        }
        return result
    }
    
    static func getGradeTextColor(grade:Grade) ->UIColor {
        let score = grade.getNumberScore()
        var color = gradeDefaultTextColor
        
        if score < 60 {
            color = gradeBadTextColor
        }else if score >= 90 {
            color = gradeGoodTextColor
        }
        return color
    }
}

extension UIColor {
    convenience init(hexColor: UInt32) {
        let redComponent = CGFloat((hexColor & 0xFF_00_00) >> 16) / CGFloat(255)
        let greenComponent = CGFloat((hexColor & 0x00_FF_00) >> 8) / CGFloat(255)
        let blueComponent = CGFloat((hexColor & 0x00_00_FF)) / CGFloat(255)
        self.init(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1)
    }
    convenience init(r:Int,g:Int,b:Int) {
        let redComponent = CGFloat(r) / CGFloat(255)
        let greenComponent = CGFloat(g) / CGFloat(255)
        let blueComponent = CGFloat(b) / CGFloat(255)
        self.init(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1)
    }
}