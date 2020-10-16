//
//  TotalUnitsView.swift
//  Diabestie
//
//  Created by Anika Morris on 10/16/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TotalUnitsView: UIView {
    
    // MARK: Subviews
    let foodUnitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Units for carbs"
        label.font = UIFont(name: Constants.fontName, size: 25.0)
        return label
    }()
    let numFoodUnitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        return label
    }()
    let correctionUnitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Units for correction"
        label.font = UIFont(name: Constants.fontName, size: 25.0)
        return label
    }()
    let numCorrectionUnitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        return label
    }()
    let totalUnitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Total units"
        label.font = UIFont(name: Constants.fontName, size: 30.0)
        return label
    }()
    let numTotalUnitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.fontName, size: 35.0)
        return label
    }()
    let unitsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = .primaryColor
        self.addSubview(unitsStackView)
        unitsStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        unitsStackView.addArrangedSubview(foodUnitsLabel)
        unitsStackView.addArrangedSubview(numFoodUnitsLabel)
        unitsStackView.addArrangedSubview(correctionUnitsLabel)
        unitsStackView.addArrangedSubview(numCorrectionUnitsLabel)
        unitsStackView.addArrangedSubview(totalUnitsLabel)
        unitsStackView.addArrangedSubview(numTotalUnitsLabel)
    }
}
