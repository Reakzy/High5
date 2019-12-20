//
//  UITableView+ScrollToBottom.swift
//  high5
//
//  Created by High5 on 11/12/18.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToBottom() {
        let rows = self.numberOfRows(inSection: 0)
        
        if rows > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: rows - 1, section: 0)
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
}
