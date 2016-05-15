//
//  QQShare.swift
//  EAS
//
//  Created by 李航 on 5/11/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import Foundation

class QQShare:NSObject {
    static let appid = "1105212016"
    
    static let appName = "轻助手"
    
    static var _tencentOAuth:TencentOAuth!
    
    class func login() {
        _tencentOAuth = TencentOAuth(appId: appid, andDelegate: nil)
    }
    
    
    class func shareImageWithUIViewContent(view:UIView) {
        let image = getImageWithUIViewConent(view)
        shareImage(image)
    }
    
    class func shareApp() {
        let appIcon = UIImage(named:"appicon")!
        let url = NSURL(string: "http:www.hangge.com")!
        shareNews(url, image: appIcon, title: appName, description: "大轻工,轻助手")
    }
    
    class func shareImage(image:UIImage) {
        login()
        let imageData = UIImagePNGRepresentation(image)
        let imgObj = QQApiImageObject(data: imageData, previewImageData: imageData, title: "轻助手", description: "分享")
        QQApiInterface.sendReq(SendMessageToQQReq(content: imgObj))
    }
    
    class func shareNews(url:NSURL,image:UIImage,title:String,description:String) {
        login()
        let imageData = UIImagePNGRepresentation(image)
        let newsObj = QQApiNewsObject(URL: url, title: title, description: description, previewImageData: imageData, targetContentType: QQApiURLTargetTypeNews)
        QQApiInterface.sendReq(SendMessageToQQReq(content: newsObj))
    }
    
    class func getImageWithUIViewConent(view:UIView) -> UIImage{
        var contentView = view
        //对view的frame备份,后面可能会改变view的frame,以便还原
        let oldFrame = contentView.frame
        if let scorllView = view as? UIScrollView {
            NSLog("coming scorllview")
            var frame = scorllView.frame
            frame.size.height = scorllView.contentSize.height
            scorllView.frame = frame
            contentView = scorllView
        }
        
        UIGraphicsBeginImageContextWithOptions(contentView.bounds.size, true, 0)
        contentView.drawViewHierarchyInRect(contentView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //还原frame
        view.frame = oldFrame
        return image
    }
}
