//
//  DateBarViewModel.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import Foundation
class DateBarViewModel: ObservableObject {
    @Published var currentDate: Date = Date()
    @Published var isNextAvailble: Bool = false
    @Published var isPreviousAvailble: Bool = true
    private let calendar = Calendar.current
    
    func setCurrentDate(date: Date) {
        currentDate = date
        isNextAvailble = (currentDate.startOfDay == Date().startOfDay) ? false : true
        isPreviousAvailble = Date.daysDifference(between: currentDate, and: Date()) >= 7 ? false : true
    }
    
    func previousButtonTapped() {
        if let newDate = calendar.date(byAdding: .day, value: -1, to: currentDate) {
            setCurrentDate(date: newDate)
        }
    }
    
    func nextButtonTapped() {
        if let newDate = calendar.date(byAdding: .day, value: 1, to: currentDate),
           newDate <= Date(){
            setCurrentDate(date: newDate)
        }
    }
    
    func formattedDate() -> String {
        let currentDate = self.currentDate.startOfDay
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        if currentDate == today {
            return "TODAY"
        } else if currentDate == yesterday {
            return "YESTERDAY"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d"
            return dateFormatter.string(from: currentDate)
        }
    }
}
