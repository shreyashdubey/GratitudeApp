//
//  Date.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import Foundation
extension Date{
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    static func daysDifference(between startDate: Date, and endDate: Date) -> Int {
            let calendar = Calendar.current
            let startOfDayStartDate = calendar.startOfDay(for: startDate)
            let startOfDayEndDate = calendar.startOfDay(for: endDate)
            let components = calendar.dateComponents([.day], from: startOfDayStartDate, to: startOfDayEndDate)
            
            return components.day ?? 0
        }
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
