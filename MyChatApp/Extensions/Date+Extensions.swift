//
//  Date+HHmm.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import Foundation

extension Date {
    
    func lastMessageDateFormat() -> String {
        let returningDate = self.yearMonthDayOfMessage()
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        var dateFormat = ""
        
        if calendar.isDateInToday(returningDate) {
            dateFormat = "HH:mm"
            formatter.dateFormat = dateFormat
            return "Today " + formatter.string(from: self)
        } else {
            dateFormat = "dd MMM HH:mm"
            formatter.dateFormat = dateFormat
            return formatter.string(from: self)
        }
    }
    
    func yearMonthDayOfMessage() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? Date()
    }
    
}
