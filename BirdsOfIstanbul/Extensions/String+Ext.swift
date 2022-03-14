//
//  String+Ext.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 4.03.2022.
//

import Foundation

extension String {

    func  getCurrentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
    
        let realTime = "\(year).\(month).\(day)-\(hour):\(minutes):\(seconds)"
    
        return realTime
    }
}
