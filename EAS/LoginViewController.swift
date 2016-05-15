//
//  ViewController.swift
//  EAS
//
//  Created by 李航 on 4/7/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, LoginObserving,DataObserving {

    @IBOutlet weak var numTextField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var loadingView: UIActivityIndicatorView!
    var remindView: UILabel!
    var loadingPage: UIView!
    
    var gradeLoad = false
    var timetableLoad = false
    
    
    var alert:UIAlertController = {
        let tmp = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "ok", style: .Default, handler: nil)
        tmp.addAction(ok)
        return tmp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remindView = UILabel()
        remindView.frame = CGRectMake(0, 0, 200, 20)
        remindView.backgroundColor = UIColor.clearColor()
        remindView.textColor = UIColor.grayColor()
        remindView.textAlignment = .Center
        remindView.center = self.view.center
        remindView.font = UIFont.systemFontOfSize(15, weight: -0.2)
        
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loadingView.center.x = self.view.center.x
        loadingView.center.y = self.view.center.y - loadingView.frame.height/2 - remindView.frame.height/2 - 10
        
        loadingPage = UIView()
        loadingPage.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.3)
        loadingPage.layer.zPosition = 1
        loadingPage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        loadingPage.hidden = true
        loadingPage.addSubview(loadingView)
        loadingPage.addSubview(remindView)
        
        self.view.addSubview(loadingPage)
        
        numTextField.delegate = self
        passwordField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func login(sender: UIButton) {
        //收起键盘
        numTextField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        var remind:String? = nil
        //学号不为空
        if let no = numTextField.text {
            //学号为十位
            if no.characters.count == 10 {
                //密码不为空
                if let passWord = passwordField.text {
                    //login
                    loadingPage.hidden = false
                    loadingView.startAnimating()
                    remindView.text = "正在登录..."
                    
                    //禁止再次登录
                    loginButton.enabled = false
                    
                    let dataService = DataService.getInstance()!
                    dataService.setLoginObserving(self)
                    dataService.setObserving(self)
                    dataService.login(no, pwd: passWord)
                }else {
                    remind = "请输入密码"
                }
            }else {
                remind = "学号为10位！"
            }
        }else {
            remind = "请输入学号"
        }
        //登录参数错误
        if remind != nil {
            alert.message = remind
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func keyChange(key: String) {
        NSLog("login succeed in LoginViewController.keyChange \(key)")
        remindView.text = "登录成功,正在加载数据..."
    }

    func loginError(errorInfo: String) {
        NSLog("login error \(errorInfo)")
        alert.message = errorInfo
        alert.message = "账号或密码错误"
        self.presentViewController(alert, animated: true, completion: nil)
        loginEnd()
    }
    
    func gradeChange(grade:[Semester:[Grade]]) {
        NSLog("LoginViewController.gradekey")
        gradeLoad = true
        checkEnd()
    }
    
    func timeTableChange(timeTable: [Semester:[Lesson]]) {
        NSLog("LoginViewController.timeTableChagne")
        timetableLoad = true
        checkEnd()
    }
    
    func lessonNumberChange(lessonNumber:[[Int]]) {
        
    }
    
    func lessonDistributingChange(lessonDistributing:[[Int]]) {
        
    }
    
    func creditPointChange(creditPoint:(creditPoint:Double,percent:Double?)) {
        
    }
    
    func checkEnd() {
        if gradeLoad && timetableLoad {
            loginEnd()
            let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("main") as! MainViewController
            self.presentViewController(mainViewController, animated: true, completion: nil)
        }
    }
    
    func loginEnd() {
        loadingPage.hidden = true
        loginButton.enabled = true
    }
}

