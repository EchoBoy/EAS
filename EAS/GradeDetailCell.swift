//
//  GradeDetailCell.swift
//  EAS
//
//  Created by 李航 on 5/8/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

class GradeDetailCell: UITableViewCell {
    var keyLabel: UILabel!
    var valueLabel: UILabel!
    var dataIsSet = false
    
    func setData(key:String ,value:String ){
        if !dataIsSet {
            let leftEmpty:CGFloat = 15
            
            var size = self.bounds.size
            size.width = UIScreen.mainScreen().bounds.width
            
            keyLabel = UILabel(frame: CGRectMake(leftEmpty,0,size.width/5,self.bounds.height))
            keyLabel.text = key
            keyLabel.textColor = UIColor.grayColor()
            keyLabel.textAlignment = .Right
            keyLabel.font = UIFont.systemFontOfSize(15, weight: -0.2)
            
            valueLabel = UILabel(frame: CGRectMake(leftEmpty+keyLabel.bounds.width+20,0,size.width/4*3-30,self.bounds.height))
            valueLabel.font = UIFont.systemFontOfSize(15, weight: 0)
            valueLabel.text = value
            
            self.addSubview(keyLabel)
            self.addSubview(valueLabel)
            dataIsSet = true
        }
    }
}
