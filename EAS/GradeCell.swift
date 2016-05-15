//
//  GradeCell.swift
//  EAS
//
//  Created by 李航 on 4/30/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class GradeCell: UITableViewCell {
    var nameView: SingleItem!
    var scoreView: SingleItem!
    var creditView: SingleItem!
    var semesterView: SingleItem!
    var dataIsSet = false
    
    func setData(singleGrade sg:Grade,semester:Semester) {
        //init view
        if !dataIsSet {
            let leftEmptyWidth:CGFloat = 20
            
            var size = self.bounds.size
            size.width = UIScreen.mainScreen().bounds.width
            
            let leftwidth = size.width/2 - 20
            
            nameView = SingleItem(frame: CGRectMake(leftEmptyWidth,0,size.width/2-30,size.height))
            scoreView = SingleItem(frame: CGRectMake(
                leftwidth + leftEmptyWidth
                ,0
                ,leftwidth/3
                ,size.height))
            creditView = SingleItem(frame: CGRectMake(
                leftwidth+scoreView.bounds.size.width+leftEmptyWidth
                ,0
                ,leftwidth/3
                ,size.height))
            semesterView = SingleItem(frame: CGRectMake(
                leftwidth+scoreView.bounds.size.width+creditView.bounds.size.width+leftEmptyWidth
                ,0
                ,leftwidth/3
                ,size.height))
            
            self.addSubview(nameView)
            self.addSubview(scoreView)
            self.addSubview(creditView)
            self.addSubview(semesterView)
        }
        
        //init data
        nameView.text = sg.name
        scoreView.text = " "+sg.score
        creditView.text = " "+String(sg.credit)
        semesterView.text = semester.getCurrentGrade()
        
        setAllTextColor(MyColor.gradeDefaultTextColor)
        scoreView.textColor = MyColor.getGradeTextColor(sg)
        
        dataIsSet = true
    }
    
    func setAllTextColor(color: UIColor) {
        nameView.textColor = color
        scoreView.textColor = color
        creditView.textColor = color
        semesterView.textColor = color
    }
}
class SingleItem: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.custom()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom()
    }
    
    //custom paras
    func custom() {
        self.backgroundColor = UIColor.clearColor()
        self.font = UIFont.systemFontOfSize(13, weight: -0.3)
    }
}


class GradeCellHeader: UIView {
    var nameView: HeaderItem!
    var scoreView: HeaderItem!
    var creditView: HeaderItem!
    var semesterView: HeaderItem!
    
    let leftEmptyWidht:CGFloat = 20
    
    func setData(paras:[String],delegate: TapToSort) {
        var size = self.bounds.size
        size.width = UIScreen.mainScreen().bounds.width
        let leftwidth = size.width/2 - 20

        nameView = HeaderItem(frame: CGRectMake(leftEmptyWidht,0,size.width/2-20,size.height))
        scoreView = HeaderItem(frame: CGRectMake(
            leftwidth + leftEmptyWidht
            ,0
            ,leftwidth/3
            ,size.height))
        creditView = HeaderItem(frame: CGRectMake(
            leftwidth+scoreView.bounds.size.width+leftEmptyWidht
            ,0
            ,leftwidth/3
            ,size.height))
        semesterView = HeaderItem(frame: CGRectMake(
            leftwidth+scoreView.bounds.size.width+creditView.bounds.size.width+leftEmptyWidht
            ,0
            ,leftwidth/3
            ,size.height))
        self.backgroundColor = UIColor.whiteColor()
        nameView.text = paras[0]
        scoreView.text = paras[1]
        creditView.text = paras[2]
        semesterView.text = paras[3]
        
        self.addSubview(nameView)
        self.addSubview(scoreView)
        self.addSubview(creditView)
        self.addSubview(semesterView)
        self.backgroundColor = MyColor.gradeHeaderBackgroundColor
        
        //添加事件监听
        let aDelegate = delegate as? AnyObject
        let nameButton = BackGroundButton(frame: nameView.frame)
        nameButton.addTarget(aDelegate, action: #selector(GradeViewController.tapToSort(_:)), forControlEvents: .TouchUpInside)
        nameButton.tag = SortKind.name.rawValue
        
        let scoreButton = BackGroundButton(frame: scoreView.frame)
        scoreButton.addTarget(aDelegate, action: #selector(GradeViewController.tapToSort(_:)), forControlEvents: .TouchUpInside)
        scoreButton.tag = SortKind.grade.rawValue
        
        let creditButton = BackGroundButton(frame: creditView.frame)
        creditButton.addTarget(aDelegate, action: #selector(GradeViewController.tapToSort(_:)), forControlEvents: .TouchUpInside)
        creditButton.tag = SortKind.credit.rawValue
        
        let semesterButton = BackGroundButton(frame: semesterView.frame)
        semesterButton.addTarget(aDelegate, action: #selector(GradeViewController.tapToSort(_:)), forControlEvents: .TouchUpInside)
        semesterButton.tag = SortKind.semester.rawValue
        
        self.addSubview(nameButton)
        self.addSubview(scoreButton)
        self.addSubview(creditButton)
        self.addSubview(semesterButton)
    }
    
}
class HeaderItem: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.custom()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom()
    }
    
    //custom paras
    func custom() {
        self.backgroundColor = UIColor.clearColor()
        self.font = UIFont.systemFontOfSize(15, weight: -0.2)
        self.textColor = MyColor.gradeHeaderTextColor
    }

}

class BackGroundButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        custom()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom()
    }
    
    func custom() {
        self.backgroundColor = UIColor.clearColor()
        self.setTitle("", forState: .Normal)
    }
}

protocol TapToSort {
    func tapToSort(tgr:UIButton)
}

