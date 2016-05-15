//
//  GradeViewCtroller.swift
//  EAS
//
//  Created by 李航 on 4/14/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class GradeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TapToSort{
    
    lazy var dataService = DataService.getInstance()!
    
    let tableCellIdentify = "gradeTableViewCell"
    
    let paras = ["课程名字","分数","学分","学期"]
    
    var grade = [Semester:[Grade]]()
    
    var gradeWithSort = [(Grade,Semester)]() {
        didSet { tableView.reloadData() }
    }
    
    var currentSortKind:SortKind = .semester
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init the data
        let _grade  = dataService.getGrade()
        if _grade != nil {
            grade = _grade!
            sortBySemester()
        }
        
        //init views
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(GradeCell.self, forCellReuseIdentifier: tableCellIdentify)
        tableView.rowHeight = 37
        tableView.sectionHeaderHeight = 40
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
        
    }
    
    //分享
    @IBAction func shareGrade(sender: UIBarButtonItem) {
        QQShare.shareImageWithUIViewContent(tableView)
    }
    
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var i = 0
        for _grade in grade.values {
            i += _grade.count
        }
        return i
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableCellIdentify, forIndexPath: indexPath) as! GradeCell
        let (grade,semester) = gradeWithSort[indexPath.row]
        cell.setData(singleGrade: grade, semester: semester)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = GradeCellHeader(frame: CGRectMake(0,0,tableView.bounds.size.width,tableView.sectionHeaderHeight))
        headerView.setData(paras,delegate: self)
        return headerView
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let gradeDetailViewController = GradeDetailViewController(style: .Plain)
        let (grade,semester) = gradeWithSort[indexPath.row]
        //设置数据(grade),进行跳转
        gradeDetailViewController.setGrade(grade,semester: semester)
        self.navigationController?.pushViewController(gradeDetailViewController, animated: true)
        
    }
    
    
    func tapToSort(tgr: UIButton){

        let newSort = SortKind(rawValue:tgr.tag)!
        //新的排序方式跟老的一样,这将数据反向
        if newSort == currentSortKind {
            gradeWithSort = gradeWithSort.reverse()
        }else {
            switch newSort {
            case .credit:
                sortByCredit()
            case .name:
                sortByName()
            case .grade:
                sortByGrade()
            case .semester:
                sortBySemester()
            }
        }
    }
    
    
    //按名字排序
    func sortByName() {
        //gradeWithSort = gradeWithSort.sort{$0.0.0.name > $0.1.0.name}
    }
    
    //按成绩排序
    func sortByGrade() {
        gradeWithSort = gradeWithSort.sort{$0.0.0.getNumberScore() > $0.1.0.getNumberScore()}
        currentSortKind = .grade
    }
    
    //按学分排序
    func sortByCredit() {
        gradeWithSort = gradeWithSort.sort{$0.0.0.credit > $0.1.0.credit}
        currentSortKind = .credit
    }
    //按学期排序,默认的排序方式
    func sortBySemester() {

        var _gradeWithSort = [(Grade,Semester)]()
        var range = Array(1...8)
        range = range.reverse()
        for i in range {
            let currentSemester = Semester(rawValue: i)!
            if var grades = grade[currentSemester] {
                grades = grades.sort{$0.0.credit > $0.1.credit}
                for g in grades {
                    _gradeWithSort.append((g,currentSemester))
                }
            }
        }
        gradeWithSort = _gradeWithSort
        currentSortKind = .semester
    }

}
enum SortKind:Int {
    case name,grade,credit,semester
}
