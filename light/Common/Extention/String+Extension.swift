//
//  String+Extension.swift
//  light
//
//  Created by LiangNing on 2023/06/22.
//

import Foundation
import UIKit

// MARK: - 常用功能
extension String {
    
    /// 去掉首尾空格
    var removeHeadAndTailSpace: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    /// 去掉首尾空格与换行
    var removeHeadAndTailSpaceNewLine: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 去掉所有空格
    var removeAllSpace: String {
        
        do {
            let regularExpression = try NSRegularExpression(pattern: "\\s*", options: .caseInsensitive)
            return regularExpression.stringByReplacingMatches(in: self, options: .withTransparentBounds, range: NSRange(location: 0, length: self.count), withTemplate: "")
            
        } catch _ {
            return self.replacingOccurrences(of: "　", with: "", options: .literal, range: nil).replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
    }
    
    static func random(_ count: Int, _ isLetter: Bool = false) -> String {
        
        var ch: [CChar] = Array(repeating: 0, count: count)
        for index in 0..<count {
            
            var num = isLetter ? arc4random_uniform(58)+65:arc4random_uniform(75)+48
            if num>57 && num<65 && isLetter==false { num = num%57+48 }
            else if num>90 && num<97 { num = num%90+65 }
            
            ch[index] = CChar(num)
        }
        
        return String(cString: ch)
    }
}



// MARK: - 验证
extension String {
    
    /// 邮箱验证
    func isValidateEmail() -> Bool {
        let emailRegex = "^[a-z0-9A-Z]+[- | a-z0-9A-Z . _]+@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:self)
    }
    
    /// 电话验证
    func isTelPhone() -> Bool {
        
        let telRegex1 = "^[0-9]{10}$";
        let telRegex2 = "^[0-9]{3}-[0-9]{3}-[0-9]{4}$";
        let telRegex3 = "^\\([0-9]{3}\\)[0-9]{3}-[0-9]{4}$";
        let telRegex4 = "^\\([0-9]{3}\\)[0-9]{7}$";
        let telRegex5 = "^[0-9]{3}-[0-9]{4}$";
        let telRegex6 = "^[0-9]{3}\\.[0-9]{3}\\.[0-9]{4}$";
        
        let telTest1 = NSPredicate(format: "SELF MATCHES %@", telRegex1)
        let telTest2 = NSPredicate(format: "SELF MATCHES %@", telRegex2)
        let telTest3 = NSPredicate(format: "SELF MATCHES %@", telRegex3)
        let telTest4 = NSPredicate(format: "SELF MATCHES %@", telRegex4)
        let telTest5 = NSPredicate(format: "SELF MATCHES %@", telRegex5)
        let telTest6 = NSPredicate(format: "SELF MATCHES %@", telRegex6)
        return telTest1.evaluate(with:self)||telTest2.evaluate(with:self)||telTest3.evaluate(with:self)||telTest4.evaluate(with:self)||telTest5.evaluate(with:self)||telTest6.evaluate(with:self)
    }
    
    /// 是否包含汉字
    func isIncludeChineseIn() -> Bool {
        
        for (_, value) in self.enumerated() {

            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        
        return false
    }
}


// MARK: - 时间相关
extension String {
    
    /// 获取当前时间戳（秒）
    static func getNowTimeStamp() -> String {
        //获取当前时间
        let now = Date()
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前时间戳（毫秒）
    static func getNowTimeMilliStamp() -> String {
        //获取当前时间
        let now = Date()
        //当前时间的时间戳
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// 获取当前时间
    /// - Parameter dateFormat: 时间格式（如：yyyy-MM-dd HH:mm:ss）
    static func getNowTimeString(dateFormat: String) -> String {
        //获取当前时间
        let now = Date()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        return dformatter.string(from: now)
    }
    
    /// 时间戳转格式化时间（秒）
    /// - Parameter dateFormat: 时间格式（如：yyyy-MM-dd HH:mm:ss）
    func getTimeString(dateFormat: String) -> String {
        guard let timeStamp = Double(self) else { return "" }
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        return dformatter.string(from: date)
        
    }
    
    /// 时间戳转格式化时间（毫秒）
    /// - Parameter dateFormat: 时间格式（如：yyyy-MM-dd HH:mm:ss）
    func getMilliTimeString(dateFormat: String) -> String {
        guard let timeStamp = Double(self) else { return "" }
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp/1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        return dformatter.string(from: date)
        
    }
    
}
