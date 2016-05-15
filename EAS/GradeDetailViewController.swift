//
//  GradeDetailViewController.swift
//  EAS
//
//  Created by 李航 on 5/8/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class GradeDetailViewController: UITableViewController{
    var data = [(String,String)]()
    
    var grade: Grade!
    
    var semester: Semester!
    
    lazy var dataService = DataService.getInstance()
    
    func setGrade(grade: Grade,semester: Semester){
        self.grade = grade
        self.semester = semester
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        initData()
        tableView.registerClass(GradeDetailCell.self, forCellReuseIdentifier: "cell")
    }
    
    func initData() {
        var sameLessonWithGrade:Lesson? = nil
        if let lessons = dataService?.getTimeTable()![semester]{
            for lesson in lessons{
                if lesson.name == grade.name {
                    sameLessonWithGrade = lesson
                    break
                }
            }
        }
        if let lesson = sameLessonWithGrade {
            data.append(("课程名称",grade.name))
            data.append(("上课老师",lesson.teacher))
            data.append(("期末分数",grade.finalScore))
            data.append(("最终分数",grade.score))
            data.append(("学分",String(grade.credit)))
            data.append(("学期",semester.getCurrentGrade()))
            let durationString = "\(lesson.duration.0)-\(lesson.duration.1)"
            data.append(("周次",durationString))
            data.append(("时间","周\(lesson.day.getChineseWeek())  "+lesson.time+"节"))
            data.append(("地点",lesson.location))
        }else {
            data.append(("课程名称",grade.name))
            data.append(("上课老师",""))
            data.append(("期末分数",grade.finalScore))
            data.append(("最终分数",grade.score))
            data.append(("学分",String(grade.credit)))
            data.append(("学期",semester.getCurrentGrade()))
            data.append(("周次",""))
            data.append(("时间",""))
            data.append(("地点",""))
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GradeDetailCell
        let (key,value) = data[indexPath.row]
        cell.setData(key,value: value)
        return cell
    }
}
extension Int{
    func getChineseWeek() -> String{
        let data = ["一","二","三","四","五","六","日"]
        return data[self-1]
    }
}
