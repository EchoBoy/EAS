//
//  AppDelegate.swift
//  EAS
//
//  Created by 李航 on 4/7/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let server_ip = "52.38.238.245"
    let server_port = "3172"
    let debugMode = true
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let networkService = NetworkSever(serverIp: server_ip, serverPort: server_port)
        
        DataService.setInstance(networkService)
        
        let dataService = DataService.getInstance()!
        
        //将测试文件考到目的文件
        if debugMode {
            dataService.debugCopyData()
        }
        
        //Key不存在的,需要登录
        if dataService.getKey() == nil {
            let rootController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("login") as! LoginViewController
            window?.rootViewController = rootController
        }
        //Key存在,直接加载数据
        else {
            //main UI
            let rootController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("main") as! MainViewController
            window?.rootViewController = rootController
        }
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return TencentOAuth.HandleOpenURL(url)
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return TencentOAuth.HandleOpenURL(url)
    }
}