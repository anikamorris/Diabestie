//
//  QuestionView.swift
//  Diabestie
//
//  Created by Anika Morris on 10/15/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class QuestionView: UIView {
    
    // MARK: Views
    let questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpQuestionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    fileprivate func setUpQuestionView() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = .primaryColor
        self.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { (make) in
            make.center.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
}
