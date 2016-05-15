//
//  TimeTable.swift
//  EAS
//
//  Created by 李航 on 4/13/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class TimeTableViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let identifier = "timetablecell"
    
    //data
    lazy var dataService = DataService.getInstance()!
    
    let defaultCellColor = UIColor.clearColor()
    
    var currentWeek: Int!
    
    //所有的课程
    var timetables = [Semester:[Lesson]]()
    
    //当前学期课程所对应的显示颜色
    var colors = [Lesson:UIColor]()
    
    //当前学期的课程数据
    var currentTimeTables = [String:Lesson](){
        didSet{
            updateColors()
            contentView.reloadData()
        }
    }
    
    //当前学期
    var currentSemester:Semester?{
        didSet{
            if currentSemester != nil {
                updateCurrentTimeTables()
            }
        }
    }
    
    //view
    @IBOutlet weak var contentView: UICollectionView!
    
    @IBOutlet weak var setSemesterButton: UIBarButtonItem!
    
    var semesterPickView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initView()
    }
    
    func initData() {
        let _timeTables = dataService.getTimeTable()
        if _timeTables != nil {
            timetables = _timeTables!
            currentSemester = dataService.getCurrentSemester()
        }
        currentWeek = getCurrentWeekDay()
    }
    func initView() {
        contentView.delegate = self
        contentView.dataSource = self
        contentView.registerClass(TimeTableCell.self, forCellWithReuseIdentifier: identifier)
        //定制CollectionViewLayout
        let layout:UICollectionViewFlowLayout = self.contentView.collectionViewLayout
            as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let widthScreen = UIScreen.mainScreen().bounds.width - 32
        let width = widthScreen/5
        let height = contentView.bounds.height/5
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSizeMake(width, height)

        
        semesterPickView = UIPickerView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        semesterPickView.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.8)
        semesterPickView.delegate = self
        semesterPickView.dataSource = self
        semesterPickView.hidden = true
        self.view.addSubview(semesterPickView)
    }
    
    
    //学期选择
    @IBAction func setSemester(sender: UIBarButtonItem) {
        if semesterPickView.hidden == true {
            semesterPickView.hidden = false
            sender.title = "确定"
        }else {
            semesterPickView.hidden = true
            //更新当前学期
            let selected = semesterPickView.selectedRowInComponent(0)
            currentSemester = Semester(rawValue: selected+1)
            sender.title = currentSemester?.getCurrentGrade()
        }
    }
  
    
    //UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = contentView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! TimeTableCell
        let lesson = currentTimeTables[String(indexPath.row)]
        cell.setData(lesson)
        cell.backgroundColor = getCellBackgroundColor(lesson)
        cell.setTextColor(getCellTextColor(lesson))
        return cell
    }
    //UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("\(indexPath.row) be selected")
    }
    
    
    //UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentSemester == nil{
            return 0
        }else {
            return currentSemester!.rawValue
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Semester(rawValue: row+1)?.getCurrentGrade()
    }
    
    //UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setSemester(setSemesterButton)
    }
    
    //更新当前学期的课程数据
    func updateCurrentTimeTables(){
        let _currentTimeTables = timetables[currentSemester!]
        if _currentTimeTables != nil {
            var _currentTimeTabelsBySort = [String:Lesson]()
            for lesson in _currentTimeTables! {
                let key = String(getPosition(lesson))
                _currentTimeTabelsBySort[key] = lesson
            }
            currentTimeTables = _currentTimeTabelsBySort
        }
    }
    
    //更新课程颜色对应信息
    func updateColors() {
        var lessons = [Lesson]()
        //按序获取lesson
        for i in 0...24 {
            if let lesson = currentTimeTables[String(i)] {
                lessons.append(lesson)
            }
        }
        colors = MyColor.lesssonColor(lessons)
    }
    
    //根据课程在课表中的定位,计算课程在collectionview中的位置,以0开始
    func getPosition(lesson: Lesson) -> Int{
        let day = lesson.day
        //第几节课开始("7-8"),第3节课开始
        var timeStart = Int(String(lesson.time[lesson.time.startIndex.advancedBy(0)]))!
        //(7-1)/2+1 = 2 第4
        timeStart = (timeStart-1)/2 + 1
        //该课程在view中的位置
        let indexInView = (timeStart-1)*5 + day - 1
        return indexInView
    }
    
    //获取课程背景色
    func getCellBackgroundColor(lesson: Lesson?) -> UIColor{
        if lesson == nil{
            return defaultCellColor
        }else {
            return colors[lesson!]!
        }
    }
    //获取课程的前景色(字体显示颜色)
    func getCellTextColor(lesson: Lesson?) -> UIColor{
        //减1是因为currentWeek是按照星期天当成一周的开始
        if lesson?.day == currentWeek - 1{
            return MyColor.currentDayLessonTextColor
        }else {
            return MyColor.defaultLessonTextColor
        }
    }
    
    //返回从以星期天开始的星期标号,星期一 -> 2
    func getCurrentWeekDay() -> Int {
        let today = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        return calendar.component(.Weekday, fromDate: today)
    }

}


