//
//  DictionaryEncodable.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import Foundation
import Foundation
import SwiftUI
import UIKit
import AVFoundation

//converting struct to dictionary
protocol DictionaryEncodable: Encodable {}
extension DictionaryEncodable {
    func dictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let json = try? encoder.encode(self),
              let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return [String: Any]()
        }
        return dict
    }
    
    func jsonString() -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        if let jsonData = try? encoder.encode(self), let jsonToString = String(data: jsonData, encoding: .utf8) {
            return jsonToString
       }
        return ""
    }
}



extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
            var dates: [Date] = []
            var date = fromDate
            
            while date <= toDate {
                dates.append(date)
                guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
                date = newDate
            }
            return dates
    }
    
    func nextWeekday(after date: Date,
                     in calendar: Calendar) -> Date {
        var components = calendar.dateComponents([.year, .month, .day],
                                                 from: date)
        var nextDate: Date!
        repeat {
            components.day! += 1
            nextDate = calendar.date(from: components)
        } while calendar.isDateInWeekend(nextDate)
        
        return nextDate
    }
    
    func roundToHourFloor() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = -minute
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    func roundToHourCeil() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute > 0 ? 60 - minute : 0
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    func roundToClosestHour() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute >= 30 ? 60 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    func numberOfDaysInCurrentMonth() -> Int{
        return getAllDaysInMonth().count
    }
    
    func getAllDaysInMonth() -> [Date]{
        var days = [Date]()
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        var day = startOfMonth()
        for _ in 1...range.count
        {
            days.append(day)
            day.getDateFor(days: 1)
        }
        return days
    }
    
    func getDateFor(days:Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
    
    func getMonthFor(month:Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: month, to: self)
    }

    
    var startOfWeek: Date? {
        let calendar = Calendar(identifier: .gregorian)
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return calendar.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var startingSaturdayOfWeek: Date? {
        let calendar = Calendar(identifier: .gregorian)
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return calendar.date(byAdding: .day, value: 6, to: sunday)
    }
    
    var startMondayOfWeek: Date? {
        let calendar = Calendar(identifier: .gregorian)
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return calendar.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let calendar = Calendar(identifier: .gregorian)
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return calendar.date(byAdding: .day, value: 6, to: sunday)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    func lastSixMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: -6), to: self.startOfMonth())!
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }

    
    // Returns millisecondsSince1970
    //Usage: Date().millisecondsSince1970
    var millisecondsSince1970: Int64 {
            Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    //Usage: Date(milliseconds: 1666932010000)
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    func customFormattedDate(myFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = myFormat
        return formatter.string(from: self)
    }
    var hour: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: self)
        return components.hour ?? 0
    }
    
    var minute: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: self)
        return components.minute ?? 0
    }
    
    var second: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: self)
        return components.second ?? 0
    }
    
    var millisecond: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.nanosecond], from: self)
        return (components.nanosecond ?? 0) / 1_000_000
    }
    func set( hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil) -> Date {
            let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
            components.hour = hour ?? components.hour
            components.minute = minute ?? components.minute
            components.second = second ?? components.second
            components.nanosecond = nanosecond ?? components.nanosecond
            return calendar.date(from: components) ?? self
        }

}


