//
//  String+dateToString.swift
//  high5
//
//  Created by Arnaud Costa on 26/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit

extension Date {
    func stringToDate(date: String, format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format;
        return formatter.date(from: date) ?? Date()
    }
}
