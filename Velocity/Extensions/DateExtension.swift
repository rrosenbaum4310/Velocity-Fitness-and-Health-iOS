//
//  DateExtension.swift
//  MMS
//
//  Created by iOS3 on 11/07/17.
//  Copyright © 2017 iOS3. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    //MARK:-
    /**
        Convert Date into time Stamp (in millies)
        - Returns: String value of time stamp
     */
    func convertIntoTimeStampMilies() -> String {
        
        let timeInterval = self.timeIntervalSince1970 * 1000
        return String(format: "%.0f", timeInterval)
    }
    
    func convertIntoUTCTimeStampMilies() -> String {
        
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        let date = Date(timeInterval: seconds, since: self)
        let timeInterval = date.timeIntervalSince1970 * 1000
        return String(format: "%.0f", timeInterval)
    }

    /**
        Convert Date into time Stamp (in millies)
        - Returns: Double value of time stamp
     */
    func convertIntoTimeStampMilies() -> Double {
        return self.timeIntervalSince1970 * 1000
    }
    
    //MARK:-
    /**
     Convert Date into String
     - Parameter format: format of date
     - Returns: Date into string format
     */
    func convertDateIntoLocalTimeZone(format strFormat:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        let strDate = dateFormatter.string(from: self)
        
        dateFormatter.timeZone = TimeZone.current
        let dt = dateFormatter.date(from: strDate)
        
        return dt ?? self
    }
    
    
    //MARK:-
    /**
        Convert Date into String
        - Parameter format: format of date
        - Returns: Date into string format
     */
    func convertIntoString(format strFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = strFormat
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
    func convertIntoLocalTimeZoneString(format strFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = strFormat
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
    
    func convertIntoUTCString(format strFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = strFormat
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
    func convertIntoLocalTimeZoneUTCString(format strFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = strFormat
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
    
    //MARK:- Date to time ago convert
    /**
     Convert Date into String
     - Parameter format: format of date
     - Returns: Date into string format
     */
    
    func timeAgoSinceDate(numericDates:Bool) -> String {
       
        
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(self)
        let latest = (earliest == now as Date) ? self : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
 
        
    }
    func getShortElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return "\(year)" + "y"
        } else if let month = interval.month, month > 0 {
            return "\(month)" + "m"
        } else if let day = interval.day, day > 0 {
            return "\(day)" + "d"
        } else if let hour = interval.hour, hour > 0 {
            return (hour == 1) ? "\(hour)" + "hr" : "\(hour)" + "hrs"
        } else if let minute = interval.minute, minute > 0 {
            return (minute == 1) ? "\(minute)" + "min" : "\(minute)" + "mins"
        } else if let second = interval.second, second > 0 {
            return (second == 1) ? "\(second)" + "sec" : "\(second)" + "secs"
        } else {
            return "now"
        }
        
    }
    
    func getShortElapsedTimeDifferenceInterval(endDate: Date) -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: endDate)
        
        if let year = interval.year, year > 0 {
            return "\(year)" + "y"
        } else if let month = interval.month, month > 0 {
            return "\(month)" + "m"
        } else if let day = interval.day, day > 0 {
            return "\(day)" + "d"
        } else if let hour = interval.hour, hour > 0 {
            return (hour == 1) ? "\(hour)" + "hr" : "\(hour)" + "hrs"
        } else if let minute = interval.minute, minute > 0 {
            return (minute == 1) ? "\(minute)" + "min" : "\(minute)" + "mins"
        } else if let second = interval.second, second > 0 {
            return (second == 1) ? "\(second)" + "sec" : "\(second)" + "secs"
        } else {
            return "now"
        }
        
    }
    
    
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
                "\(year)" + " " + "years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" :
                "\(month)" + " " + "months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" :
                "\(day)" + " " + "days"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour" :
                "\(hour)" + " " + "hours"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute" :
                "\(minute)" + " " + "minutes"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second" :
                "\(second)" + " " + "seconds"
        } else {
            return "a moment ago"
        }
        
    }
}
extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.hour = 24
        //components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
        
        //return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
