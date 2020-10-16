//
//  UIViewController+PresentAlert.swift
//  Diabestie
//
//  Created by Anika Morris on 10/16/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
