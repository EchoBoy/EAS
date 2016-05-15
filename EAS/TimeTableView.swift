//
//  ClassTableView.swift
//  EAS
//
//  Created by 李航 on 4/14/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class TimeTableCell:UICollectionViewCell {
    var nameLabel: UILabel!
    var teacherLabel: UILabel!
    var locationLabel: UILabel!
    var dataIsSet = false
    
    func setData(lesson: Lesson?) {
        if !dataIsSet {
            let x_postion:CGFloat = 5
            let width = bounds.width-10
            let nameLabelHeight = bounds.height/2
            let leftHeight = bounds.height - nameLabelHeight
            
            nameLabel = UILabel(frame: CGRectMake(x_postion,0,width,nameLabelHeight))
            nameLabel.numberOfLines = 0
            nameLabel.backgroundColor = UIColor.clearColor()
            nameLabel.font = UIFont.systemFontOfSize(12, weight: -0.2)
            
            teacherLabel = UILabel(frame: CGRectMake(x_postion,nameLabelHeight,width,leftHeight/2))
            teacherLabel.numberOfLines = 0
            teacherLabel.backgroundColor = UIColor.clearColor()
            teacherLabel.font = UIFont.systemFontOfSize(10, weight: -0.3)
            
            locationLabel = UILabel(frame: CGRectMake(x_postion,nameLabelHeight+teacherLabel.bounds.height,width,leftHeight-teacherLabel.bounds.height))
            locationLabel.numberOfLines = 0
            locationLabel.backgroundColor = UIColor.clearColor()
            locationLabel.font = UIFont.systemFontOfSize(10, weight: -0.3)
            
            self.addSubview(nameLabel)
            self.addSubview(teacherLabel)
            self.addSubview(locationLabel)
    
            dataIsSet = true
        }
        nameLabel.text = lesson?.name
        if lesson != nil{
            teacherLabel.text = "#" + lesson!.teacher
            locationLabel.text = "@" + lesson!.location
        }else {
            teacherLabel.text = nil
            locationLabel.text = nil
        }
    }
    
    func setTextColor(textColor:UIColor) {
        nameLabel.textColor = textColor
        teacherLabel.textColor = textColor
        locationLabel.textColor = textColor
    }
}
