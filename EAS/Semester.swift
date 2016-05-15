//
//  Semester.swift
//  EAS
//
//  Created by 李航 on 4/15/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//


enum Semester:Int {
    case 一 = 1,二,三,四,五,六,七,八
    func getString() -> String{
        var result = ""
        switch self {
        case .一:
            result = "一"
        case .二:
            result = "二"
        case .三:
            result = "三"
        case .四:
            result = "四"
        case .五:
            result = "五"
        case .六:
            result = "六"
        case .七:
            result = "七"
        case .八:
            result = "八"
        }
        return result
    }
    
    func description() -> String {
        return self.getString()
    }
    func getCurrentGrade() -> String {
        let dic = ["一":"大一上","二":"大一下","三":"大二上","四":"大二下","五":"大三上","六":"大三下","七":"大四上","八":"大四下"]
        return dic[self.getString()]!
        
    }
}
