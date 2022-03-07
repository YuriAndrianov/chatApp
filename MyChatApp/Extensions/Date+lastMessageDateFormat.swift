//
//  Date+HHmm.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import Foundation

extension Date {
    
    func lastMessageDateFormat() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let returningDate = calendar.date(from: components) ?? Date()
        
        let formatter = DateFormatter()
        var dateFormat = ""
        
        if calendar.isDateInToday(returningDate) {
            dateFormat = "HH:mm"
        } else {
            dateFormat = "dd MMM"
        }
        
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: self)
    }
    
}
