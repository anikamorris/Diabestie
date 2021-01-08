//
//  CloseButton.swift
//  Diabestie
//
//  Created by Anika Morris on 1/8/21.
//  Copyright © 2021 Anika Morris. All rights reserved.
//

import Foundation
import UIKit

class CloseButton: UIButton {
    
    //MARK: Views
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 22.0)
        label.textColor = .white
        return label
    }()
    
    //MARK: Init
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.label.text = title
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    private func setUpViews() {
        self.backgroundColor = .alertColor
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.tintColor = .white
        self.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

