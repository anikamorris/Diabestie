//
//  UnderlinedTextField+NumberPadDoneButton.swift
//  Diabestie
//
//  Created by Anika Morris on 10/16/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit

///https://stuartmcintosh.com/2018/05/17/how-to-add-a-done-button-to-a-numberpad-in-swift/

extension UnderlinedTextField {
    var doneAccessory: Bool {
        get { // will never be called
            return true
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard(with: #selector(doneButtonAction))
            }
        }
    }

    func addDoneButtonOnKeyboard(with action: Selector) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: action)
        done.tintColor = .alertColor
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
