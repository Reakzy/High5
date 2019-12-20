//
//  UIViewController+DisplayView.swift
//  high5
//
//  Created by Arnaud Costa on 18/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayView(viewId: String) {
        let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewId)
        navigationController?.show(newVC, sender: nil)
    }
}
