//
//  FeedBackViewController.swift
//  EAS
//
//  Created by 李航 on 5/6/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationItem()
        initView()
    }
    @IBAction func startFeedBack(sender: UIButton) {
        textView.hidden = false
        self.view.backgroundColor = UIColor.whiteColor()
        sender.hidden = true
        textView.becomeFirstResponder()
    }
    func customNavigationItem() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send"), style: .Plain, target: self, action: #selector(FeedBackViewController.post))
        self.navigationItem.title = "反馈"
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    func initView() {
        textView.hidden = true
    }
    func post() {
        var message = ""
        let isEmpty = textView.text.isEmpty
        
        var ok = UIAlertAction(title: "ok", style: .Default, handler: back)
        
        if isEmpty {
            message = "你还没有填写任何反馈"
            ok = UIAlertAction(title: "ok", style: .Default, handler: nil)
        }else {
            message = "感谢你的反馈,我们会及时处理"
            //post data to server
        }
        
        let alertThankYou = UIAlertController(title: "EAS", message: message, preferredStyle: .Alert)
        alertThankYou.addAction(ok)
        
        self.presentViewController(alertThankYou, animated: true, completion: nil)
    }
    func back(sender:UIAlertAction) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
