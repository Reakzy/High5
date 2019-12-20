//
//  UITableViewCell+CustomSeparator.swift
//  high5
//
//  Created by Arnaud Costa on 25/02/2019.
//  Copyright © 2019 Arnaud Costa. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Your separatorLineHeight with scalefactor
        let separatorLineHeight: CGFloat = 1/UIScreen.main.scale
        
        let separator = UIView()
        
        separator.frame = CGRect(x: self.frame.origin.x,
                                 y: self.frame.size.height - separatorLineHeight,
                                 width: self.frame.size.width,
                                 height: separatorLineHeight)
        
        separator.backgroundColor = .black
        
        self.addSubview(separator)
    }
    
}
