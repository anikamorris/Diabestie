//
//  StackviewWithLabel+TextField.swift
//  Diabestie
//
//  Created by Anika Morris on 10/14/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class StackViewWithLabelAndTextField: UIStackView {
    
    // MARK: Properties
    let label: UILabel!
    let textField: UITextField!
    
    // MARK: Init
    init(frame: CGRect, label: UILabel, textField: UITextField) {
        self.label = label
        self.textField = textField
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        setUpStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpStackView() {
        self.backgroundColor = .primaryColor
        self.addArrangedSubview(label)
        self.addArrangedSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }
}
