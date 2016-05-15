//
//  AnalyseItemView.swift
//  EAS
//
//  Created by 李航 on 5/4/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit
class AnalyseItemView: UIView {
    
    let labelHeight:CGFloat = 40
    
    var label:AnalyseLabel
    var chart:UUChart!
    var csd:UUChartDataSource!
    var charStyle: UUChartStyle!
    var totalAnalyse:TotalAnalyse!
    
    init(frame: CGRect,title: String) {
        label = AnalyseLabel(frame: CGRectMake(0,0,frame.width,labelHeight))
        label.text = title
        super.init(frame:frame)
        self.addSubview(label)
    }
    
    convenience init(frame: CGRect,chartDataSource csd:UUChartDataSource,charStyle:UUChartStyle,title:String) {
        self.init(frame:frame,title:title)
        self.csd = csd
        self.charStyle = charStyle
    }
    
    convenience init(frame: CGRect,totalAnalyseDataSource ads:TotalAnalyseDataSource,title:String) {
        self.init(frame:frame,title:title)
        totalAnalyse = TotalAnalyse(frame: CGRectMake(0, labelHeight, frame.width, frame.height-labelHeight), dataSource: ads)
        totalAnalyse.showInView(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadChart() {
        NSLog("reloadChart")
        if chart != nil{
            chart.removeFromSuperview()
        }
        chart = UUChart(frame: CGRectMake(0, labelHeight, self.frame.width, self.frame.height-labelHeight),dataSource: csd,style: charStyle)
        chart.showInView(self)
    }
}

class TotalAnalyse: UILabel {
    
    var dataSource: TotalAnalyseDataSource
    
    init(frame: CGRect,dataSource ds:TotalAnalyseDataSource) {
        self.dataSource = ds
        super.init(frame:frame)
    }
    
    func perpareToShow() {
        let data = dataSource.getTotalAnalyse(self)
        text = "   你在 \(data["comeYear"]!) 年跳进轻工大坑.目前你混了 \(data["spend"]!) 个学期,睡完了 \(data["totalLesson"]!) 课程,捡了 \(data["totalCredit"]!) 个学分,平均绩点: \(data["creditPoint"]!)"
        self.font = UIFont.systemFontOfSize(14, weight: -0.2)
        self.textColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        numberOfLines = 0
        backgroundColor = UIColor.whiteColor()
        //行间距
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes = [NSParagraphStyleAttributeName : style]
        self.attributedText = NSAttributedString(string: text!, attributes:attributes)
    }
    func showInView(view:UIView) {
        perpareToShow()
        view.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol TotalAnalyseDataSource {
    func getTotalAnalyse(totalAnalyse:TotalAnalyse) -> [String:String]
}

//Label的自定义
class AnalyseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        custom()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom()
    }
    
    func custom() {
        textAlignment = .Center
        font = UIFont.systemFontOfSize(15, weight: -0.2)
        textColor = UIColor.grayColor()
    }
}