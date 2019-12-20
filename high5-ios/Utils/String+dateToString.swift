//
//  String+stringToDate.swift
//  high5
//
//  Created by Arnaud Costa on 25/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit

extension String {
    func dateToString(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date);
    }
}
