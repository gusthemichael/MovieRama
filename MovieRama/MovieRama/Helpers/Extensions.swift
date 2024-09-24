//
//  Extensions.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 21/9/24.
//

import Foundation
extension String {
    func formatRating() -> String {
        if let doubleValue = Double(self) {
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 1
                formatter.maximumFractionDigits = 1
                return formatter.string(from: NSNumber(value: doubleValue)) ?? "0.0"
            
        } else {
            return ""
        }
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        
        // Set the format of the input string
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Convert the string into a Date object
        if let date = dateFormatter.date(from: self) {
            // Set the desired output format
            dateFormatter.dateFormat = "d MMMM yyyy"
            // Convert the Date object back to a string
            return dateFormatter.string(from: date)
        }
        
        // Return the original string if the conversion fails
        return self
    }
}
