//
//  Date.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import Foundation

extension Date {
    
    func getString(formated by: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = by.rawValue
        return dateFormatter.string(from: self)
    }
    
}
