//
//  UnderlinedTextField.swift
//  Diabestie
//
//  Created by Anika Morris on 10/14/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit

class UnderlinedTextField: UITextField {

    private let defaultUnderlineColor = UIColor.label
    private let bottomLine = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    required init() { //with initializer
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        borderStyle = .none
        contentVerticalAlignment = .center //added
        clearButtonMode = .unlessEditing //added
        tintColor = defaultUnderlineColor
        font = UIFont.boldSystemFont(ofSize: 18) //added
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = defaultUnderlineColor
        self.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true //updated to make the line closer to the text
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    //Setters
    public func setUnderlineColor(color: UIColor = .red) {
        bottomLine.backgroundColor = color
    }
    
    public func setDefaultUnderlineColor() {
        bottomLine.backgroundColor = defaultUnderlineColor
    }
    
    //Helpers
    public func hasError() {
        self.setUnderlineColor(color: .accentColor)
    }
    
    public func hasNoError() {
        self.setDefaultUnderlineColor()
    }
}

