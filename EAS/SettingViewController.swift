//
//  SettingViewController.swift
//  EAS
//
//  Created by 李航 on 5/6/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit
class SettingViewController: UITableViewController{
    
    let identifier = "cell"
    let settingItems = [["分享","反馈","关于"],["一键评教","公选抢课","四六级报名","四六级成绩查询"],["退出登录"]]
    let settingHeader = ["","即将到来",""]
    let logoutIndex = NSIndexPath(forRow: 0, inSection: 2)
    let feedBackIndex = NSIndexPath(forRow: 1, inSection: 0)
    let shareIndex = NSIndexPath(forItem: 0, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initView()
        self.tabBarController?.tabBar.hidden = true
        self.clearsSelectionOnViewWillAppear = true
    }
    func initData() {
        
    }
    func initView() {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems[section].count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settingItems.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        let section = indexPath.section
        let row = indexPath.row
        let title = settingItems[section][row]
        if section == 0 {
            cell.accessoryType = .DisclosureIndicator
        }
        if indexPath == logoutIndex {
            customLogoutCell(cell)
        }
        cell.textLabel?.text = title
        return cell
    }
    //定制"退出登录"
    func customLogoutCell(cell:UITableViewCell) {
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.textColor = UIColor.redColor()
    }
    //自定义header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingHeader[section]
    }
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.grayColor()
        header.textLabel?.font = UIFont.systemFontOfSize(12, weight: -0.2)
        header.textLabel?.frame = header.frame
    }
    
    //响应
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath {
        //反馈
        case feedBackIndex:
            let feedBackViewController = UIStoryboard(name: "Support", bundle: nil).instantiateViewControllerWithIdentifier("feedback") as! FeedBackViewController
            self.navigationController?.pushViewController(feedBackViewController, animated: true)
        //取消登录
        case logoutIndex:
            let alert = UIAlertController(title: "EAS", message: "确定要退出当前账号吗?", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            let ok = UIAlertAction(title: "确定", style: .Default, handler: logout)
            alert.addAction(cancel)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        case shareIndex:
            QQShare.shareApp()
        default:
            NSLog("unknow setting")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    func logout(action:UIAlertAction) {
        //删除数据
        if let dataService = DataService.getInstance() {
            dataService.clearAllData()
        }
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("login") as! LoginViewController
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
}