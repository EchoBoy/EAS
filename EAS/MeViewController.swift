//
//  Analyse.swift
//  EAS
//
//  Created by 李航 on 4/14/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, TotalAnalyseDataSource{
    
    @IBOutlet weak var contentView: UIScrollView!
    lazy var dataService = DataService.getInstance()
    
    let horizonValue = ["大一上","大一下","大二上","大二下","大三上","大三下","大四上","大四下"]
    var lessonsNumbersDataSource: MyUUCharDataSource!
    var averageScoresDataSource: MyUUCharDataSource!
    
    var lessonNumbers: [[Int]]?
    var averageScores: [[Double]]?
    var creditPoint: [[Double]]?
    
    var totalCredit: Double!
    var totalScore: Double!
    var totalGrades: Int!
    var currentCreditPoint:Double!
     
    //view
    var lessonNumberItem:AnalyseItemView!
    var averageScoresItem:AnalyseItemView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width,200*2+110)
        lessonNumbers = dataService?.getLessonNumber()
        initData()
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        reloadCharts()
    }
    
    //每次都有动画
    func reloadCharts() {
        lessonNumberItem.reloadChart()
        averageScoresItem.reloadChart()
    }

    func initView() {
        let standerHeight:CGFloat = 200
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        let totalAnalyse = AnalyseItemView(frame: CGRectMake(0, 0, screenWidth, 100), totalAnalyseDataSource: self, title: "分析")
        
        contentView.addSubview(totalAnalyse)
        /// 制表
        //每周课程平均数
        let startY:CGFloat = 100
        
        lessonNumberItem = AnalyseItemView(frame: CGRectMake(0,startY,screenWidth,standerHeight), chartDataSource: lessonsNumbersDataSource, charStyle: .Line, title: "每周课程数量")
        averageScoresItem = AnalyseItemView(frame: CGRectMake(0, standerHeight+startY,screenWidth,standerHeight), chartDataSource: averageScoresDataSource, charStyle: .Line, title: "平均分")
        
        contentView.addSubview(lessonNumberItem)
        contentView.addSubview(averageScoresItem)
    }
    
    func initData() {
        var _totalCredit: Double = 0
        var _totalScore: Double = 0
        var _totalGrades: Int = 0
        var _currentCreditPoint:Double = 0
        
        if let allArades = dataService?.getGrade() {
            var _averageScores = [Double]()
            var _creditPoints = [Double]()
            
            for i in 1...8{
                if let grades = allArades[Semester(rawValue:i)!] {
                    //某一学期的成绩
                    var singleCreditPoint:Double = 0
                    var singleCredit:Double = 0
                    var singleScore:Double = 0
                    
                    for grade in grades {
                        let numberScore = grade.getNumberScore()
                        let credit = grade.credit
                        
                        singleCredit += credit
                        singleScore += numberScore
                        singleCreditPoint += numberScore.scoreToCredit * credit
                    }
                    _averageScores.append(singleScore/Double(grades.count))
                    _creditPoints.append(singleCreditPoint/singleCredit)
                    _currentCreditPoint += singleCreditPoint
                    _totalCredit += singleCredit
                    _totalScore += singleScore
                    _totalGrades += grades.count
                }
            }
            self.averageScores = [_averageScores]
            self.creditPoint = [_creditPoints]
        }
        self.currentCreditPoint = _currentCreditPoint/_totalCredit
        self.totalCredit = _totalCredit
        self.totalScore = _totalScore
        self.totalGrades = _totalGrades
        
        lessonsNumbersDataSource = MyUUCharDataSource(horizonValue: horizonValue, range: CGRangeMake(20, 0), values: lessonNumbers)
        averageScoresDataSource = MyUUCharDataSource(horizonValue: horizonValue, range: CGRangeMake(100, 60), values: averageScores)
    }
    
    
    @IBAction func shareAnalyse(sender: UIBarButtonItem) {
        QQShare.shareImageWithUIViewContent(contentView)
    }
    
    //TotalAnalyseDataSource
    func getTotalAnalyse(totalAnalyse: TotalAnalyse) -> [String : String] {
        var data = [String:String]()
        data["comeYear"] = "13"
        var currentSemester = Semester(rawValue: 1)!
        if let _currentSemester = dataService?.getCurrentSemester() {
            currentSemester = _currentSemester
        }
        data["spend"] = String(currentSemester.rawValue - 1)
        data["totalLesson"] = String(totalGrades)
        data["totalCredit"] = String(totalCredit)
        data["creditPoint"] = currentCreditPoint.format(".1")
        return data
    }
}

extension Double {
    var scoreToCredit:Double {
        var credit = (self-50)/10
        if credit < 1 {
            credit = 1
        }
        if credit > 4 {
            credit = 4
        }
        return credit
    }
    //Double to String
    func format(f:String) -> String {
        return String(format: "%\(f)f",self)
    }
 }
class MyUUCharDataSource: NSObject, UUChartDataSource {
    
    var horizonValue: [AnyObject]
    var values:[AnyObject]?
    var showMaxMinAtIndex = true
    var range: CGRange
    var colors = [UIColor.redColor(),UIColor.blueColor()]
    
    init(horizonValue hv:[AnyObject], range:CGRange,values:[AnyObject]?) {
        self.horizonValue = hv
        self.range = range
        self.values = values
    }
    
    func chartConfigAxisXLabel(chart: UUChart!) -> [AnyObject]! {
        return horizonValue
    }
    
    func chartConfigAxisYValue(chart: UUChart!) -> [AnyObject]! {
        if self.values == nil {
            return [AnyObject]()
        }else {
            return values
        }
    }
    
    func chart(chart: UUChart!, showHorizonLineAtIndex index: Int) -> Bool {
        return true
    }
    
    func chart(chart: UUChart!, showMaxMinAtIndex index: Int) -> Bool {
        return showMaxMinAtIndex
    }
    
    func chartConfigColors(chart: UUChart!) -> [AnyObject]! {
        return colors
    }
    
    func chartRange(chart: UUChart!) -> CGRange {
        return range
    }
}





