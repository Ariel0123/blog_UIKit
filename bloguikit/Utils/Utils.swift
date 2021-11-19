//
//  Utils.swift
//  bloguikit
//
//  Created by Ariel Ortiz on 10/18/21.
//

import Foundation

public class Utils{
    
    static public func convertDateFormat(inputDate: String) ->String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let theDate = dateFormatter.date(from: inputDate)!
        let newDateFormater = DateFormatter()
        newDateFormater.dateFormat = "dd-MMM-yyyy"
        return newDateFormater.string(from: theDate)
    }
}
