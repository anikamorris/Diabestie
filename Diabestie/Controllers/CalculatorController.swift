//
//  CalculatorController.swift
//  Diabestie
//
//  Created by Anika Morris on 10/13/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Motion

class CalculatorController: UIViewController {
    
    // MARK: Properties
    var coordinator: TabBarCoordinator!
    let question = Question(insulinDuration: 3)
    var allQuestions: [String]!
    var answer: Answer = Answer(anyCorrections: false,
                        eatingNow: false,
                        currentBG: 0,
                        numCarbs: 0,
                        hoursSince: 0,
                        lastCorrectionUnits: 0)
    var currentIndex: Int = 0
    var questionViews: [QuestionView]!
    var questionLabels: [UILabel]!
    
    // MARK: Views
    let questionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    let anyCorrectionsView = QuestionView(frame: .zero)
    let eatingNowView = QuestionView(frame: .zero)
    let currentBGView = QuestionView(frame: .zero)
    let numCarbsView = QuestionView(frame: .zero)
    let hoursSinceView = QuestionView(frame: .zero)
    let lastCorrectionUnitsView = QuestionView(frame: .zero)
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Yes", "No"])
        control.backgroundColor = UIColor(red: 1, green: 0.7411764706, blue: 0.6745098039, alpha: 1)
        control.selectedSegmentTintColor = .alertColor
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                          NSAttributedString.Key.font: UIFont(name: Constants.fontName, size: 20.0)!]
        control.setTitleTextAttributes(attributes, for: .normal)
        control.addTarget(self, action: #selector(selectedSegmentedDidChange), for: .valueChanged)
        return control
    }()
    let numberInputTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.setUnderlineColor(color: .alertColor)
        textField.font = UIFont(name: Constants.fontName, size: 30.0)
        textField.textColor = .darkGray
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.keyboardType = .decimalPad
        textField.doneAccessory = true
        return textField
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let rightArrow = UIImage(systemName: "arrow.right", withConfiguration: largeConfig)
        button.setImage(rightArrow, for: .normal)
        button.tintColor = .primaryColor
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    let backButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let leftArrow = UIImage(systemName: "arrow.left", withConfiguration: largeConfig)
        button.setImage(leftArrow, for: .normal)
        button.tintColor = .primaryColor
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    let totalUnitsView = TotalUnitsView()
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: 20.0)
        button.backgroundColor = .alertColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        allQuestions = question.allQuestions()
        questionViews = [anyCorrectionsView, eatingNowView, currentBGView]
        questionLabels = [anyCorrectionsView.questionLabel, eatingNowView.questionLabel, currentBGView.questionLabel]
        setQuestionText()
        setUpInitialView()
        numberInputTextField.delegate = self
    }
    
    // MARK: Methods
    func setUpInitialView() {
        view.backgroundColor = .backgroundColor
        // container for all question views
        view.addSubview(questionContainer)
        questionContainer.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        // constraints for anyCorrectionsView
        questionContainer.addSubview(anyCorrectionsView)
        anyCorrectionsView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        setQuestionViewConstraints(view: anyCorrectionsView)
        // constraints for eatingNowView
        questionContainer.addSubview(eatingNowView)
        setQuestionViewConstraints(view: eatingNowView)
        // constraints for currentBGView
        questionContainer.addSubview(currentBGView)
        setQuestionViewConstraints(view: currentBGView)
        // constraints for numCarbsView
        questionContainer.addSubview(numCarbsView)
        setQuestionViewConstraints(view: numCarbsView)
        // constraints for hoursSinceView
        questionContainer.addSubview(hoursSinceView)
        setQuestionViewConstraints(view: hoursSinceView)
        // constraints for lastCorrectionUnitsView
        questionContainer.addSubview(lastCorrectionUnitsView)
        setQuestionViewConstraints(view: lastCorrectionUnitsView)
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(questionContainer.snp_bottomMargin).offset(30)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        view.addSubview(numberInputTextField)
        numberInputTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(questionContainer.snp_bottomMargin).offset(10)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp_bottomMargin).offset(view.bounds.height * 0.1)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        buttonStackView.addArrangedSubview(backButton)
        buttonStackView.addArrangedSubview(nextButton)
        setTotalUnitsViewConstraints()
        hideAllViewsExceptFirst()
    }
    
    fileprivate func setQuestionViewConstraints(view: QuestionView) {
        view.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    fileprivate func setTotalUnitsViewConstraints() {
        view.addSubview(totalUnitsView)
        totalUnitsView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    fileprivate func hideAllViewsExceptFirst() {
        nextButton.isHidden = true
        backButton.isHidden = true
        numberInputTextField.isHidden = true
        eatingNowView.isHidden = true
        currentBGView.isHidden = true
        numCarbsView.isHidden = true
        hoursSinceView.isHidden = true
        lastCorrectionUnitsView.isHidden = true
        totalUnitsView.isHidden = true
        doneButton.isHidden = true
    }
    
    fileprivate func setQuestionText() {
        let lenQuestionLabels = questionLabels.count
        for i in 0..<lenQuestionLabels {
            if lenQuestionLabels == 4 {
                questionLabels[i].text = question.noYesQuestions()[i]
            } else if lenQuestionLabels == 5 {
                questionLabels[i].text = question.yesNoQuestions()[i]
            } else {
                questionLabels[i].text = allQuestions[i]
            }
        }
    }
    
    fileprivate func setQuestionViewsForAnswer() {
        if answer.anyCorrections && answer.eatingNow { // answered yes to first 2 questions
            questionViews.append(contentsOf: [numCarbsView,
                                              hoursSinceView,
                                              lastCorrectionUnitsView])
            questionLabels.append(contentsOf: [numCarbsView.questionLabel,
                                               hoursSinceView.questionLabel,
                                               lastCorrectionUnitsView.questionLabel])
        } else if answer.anyCorrections { // answered yes to only the first question
            questionViews.append(contentsOf: [hoursSinceView, lastCorrectionUnitsView])
            questionLabels.append(contentsOf: [hoursSinceView.questionLabel,
                                               lastCorrectionUnitsView.questionLabel])
        } else if answer.eatingNow { // answered yes to only the second question
            questionViews.append(contentsOf: [numCarbsView])
            questionLabels.append(contentsOf: [numCarbsView.questionLabel])
        }
        // if answered no to both questions, no more views are needed
    }
    
    fileprivate func hideViewsToShowUnits() {
        questionContainer.isHidden = true
        for i in 0..<questionViews.count {
            questionViews[i].isHidden = true
            questionLabels[i].isHidden = true
        }
        buttonStackView.isHidden = true
        numberInputTextField.isHidden = true
    }
    
    fileprivate func castResponseToDouble() -> Double {
        let response = numberInputTextField.text
        if response == "" {
            print("Please input a number.")
        }
        guard let num = Double(response!) else {
            print("Please input a number.")
            return 0.0
        }
        return num
    }
    
    fileprivate func saveNumber() {
        let num = castResponseToDouble()
        if questionViews.count == 3 { // there are 3 questions, user answered no to first two questions
            answer.currentBG = num
        } else if questionViews.count == 4 { // there are 4 questions, user answered yes to only the second question
            if currentIndex == 3 {
                answer.currentBG = num
            } else {
                answer.numCarbs = num
            }
        } else if questionViews.count == 5 { // there are 5 questions, user answered yes to only the first question
            if currentIndex == 3 {
                answer.currentBG = num
            } else if currentIndex == 4 {
                answer.hoursSince = num
            } else {
                answer.lastCorrectionUnits = num
            }
        } else { // there are 6 questions, user answered yes to first two questions
            if currentIndex == 3 {
                answer.currentBG = num
            } else if currentIndex == 4 {
                answer.numCarbs = num
            } else if currentIndex == 5 {
                answer.hoursSince = num
            } else {
                answer.lastCorrectionUnits = num
            }
        }
    }
    
    fileprivate func showNextQuestion() {
        animateFadeOut(questionViews[currentIndex])
        animateFadeOut(questionLabels[currentIndex])
        currentIndex += 1
        animateViewDropIn(questionViews[currentIndex])
        animateLabelDropIn(questionLabels[currentIndex])
    }
    
    fileprivate func showUnits() {
        let foodUnits = String(answer.calculateFoodUnits())
        let correctionUnits = String(answer.calculateCorrectionUnits())
        let totalUnits = String(answer.totalUnits())
        if foodUnits == "0.0" {
            totalUnitsView.numFoodUnitsLabel.text = "0"
        } else {
            totalUnitsView.numFoodUnitsLabel.text = String(foodUnits)
        }
        totalUnitsView.numCorrectionUnitsLabel.text = correctionUnits
        totalUnitsView.numTotalUnitsLabel.text = totalUnits
        hideViewsToShowUnits()
        doneButton.isHidden = false
        animateViewDropIn(totalUnitsView)
    }
    
    fileprivate func resetAnswer() {
        answer.anyCorrections = false
        answer.eatingNow = false
        answer.currentBG = 0
        answer.numCarbs = 0
        answer.hoursSince = 0
        answer.lastCorrectionUnits = 0
    }
    
    @objc func selectedSegmentedDidChange() {
        if currentIndex == 0 {
            buttonStackView.isHidden = false
            nextButton.isHidden = false
            backButton.isHidden = true
        }
        var response: Bool
        if segmentedControl.selectedSegmentIndex == 0 {
            response = true
        } else {
            response = false
        }
        if currentIndex == 0 && segmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment {
            answer.anyCorrections = response
        } else if segmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment {
            answer.eatingNow = response
        }
    }
    
    @objc func nextButtonTapped() {
        segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        if currentIndex < questionViews.count - 1 {
            showNextQuestion()
        } else {
            animateFadeOut(questionViews[currentIndex])
            currentIndex += 1
            saveNumber()
            showUnits()
            return
        }
        backButton.isHidden = false
        if currentIndex == 2 { // user is viewing currentBG question
            numberInputTextField.text = ""
            setQuestionViewsForAnswer()
            setQuestionText()
            segmentedControl.isHidden = true
            numberInputTextField.isHidden = false
        } else if currentIndex < 2 { // user is still on one of the first 2 questions
            segmentedControl.isHidden = false
            numberInputTextField.isHidden = true
        } else { // user is past currentBG question
            saveNumber()
            numberInputTextField.text = ""
        }
    }
    
    @objc func backButtonTapped() {
        animateQuestionAccelerateOut(questionViews[currentIndex])
        currentIndex -= 1
        animateFadeIn(questionViews[currentIndex])
        animateFadeIn(questionLabels[currentIndex])
        if currentIndex == 0 {
            backButton.isHidden = true
        } else if currentIndex < 2 {
            segmentedControl.isHidden = false
            numberInputTextField.isHidden = true
        }
    }
    
    @objc func doneButtonTapped() {
        resetAnswer()
        currentIndex = 0
        questionViews = [anyCorrectionsView, eatingNowView, currentBGView]
        questionLabels = [anyCorrectionsView.questionLabel, eatingNowView.questionLabel, currentBGView.questionLabel]
        animateFadeOut(totalUnitsView)
        totalUnitsView.isHidden = true
        doneButton.isHidden = true
        questionContainer.isHidden = false
        segmentedControl.isHidden = false
        animateViewDropIn(questionViews[currentIndex])
        animateLabelDropIn(questionLabels[currentIndex])
    }
}

// MARK: Animations
extension CalculatorController {
    fileprivate func animateFadeOut(_ animatedView: UIView) {
        animatedView.animate([.duration(0.2),
                              .fadeOut,
                              .background(color: .clear)
                            ], completion: { [weak self] in self?.animateQuestionAccelerateOut(animatedView)}
                            )
    }
    
    fileprivate func animateViewDropIn(_ animatedView: UIView) {
        animatedView.alpha = 1
        let windows = UIApplication.shared.windows
        let safeAreaTop = windows[0].safeAreaInsets.top
        let xPoint = view.bounds.width * 0.5
        let yPoint = CGFloat(0) - animatedView.bounds.height/2 + 30 + safeAreaTop
        let yDistance = animatedView.bounds.height
        
        animatedView.animate([.delay(0.1),
                              .duration(0.15),
                              .background(color: .primaryColor),
                              .position(CGPoint(x: xPoint, y: yPoint)),
                              .timingFunction(.deceleration)
                            ], completion: {
                                animatedView.isHidden = false
                                animatedView.animate([.duration(0.3),
                                                      .translate(x: 0,
                                                                 y: yDistance,
                                                                 z: 0),
                                                     .timingFunction(.deceleration)
                                                    ])
                            })
    }
    
    fileprivate func animateLabelDropIn(_ animatedLabel: UILabel) {
        animatedLabel.alpha = 1
        let xPoint = view.bounds.width * 0.425
        let yPoint = CGFloat(0) - animatedLabel.bounds.height/2
        let yDistance = animatedLabel.bounds.height
        
        animatedLabel.animate([.delay(0.1),
                               .duration(0.15),
                              .position(CGPoint(x: xPoint, y: yPoint)),
                              .timingFunction(.deceleration)
                            ], completion: {
                                animatedLabel.isHidden = false
                                animatedLabel.animate([.duration(0.3),
                                                      .translate(x: 0,
                                                                 y: yDistance,
                                                                 z: 1),
                                                     .timingFunction(.deceleration)
                                                    ])
                            })
    }
    
    fileprivate func animateFadeIn(_ animatedView: UIView) {
        animatedView.animate([.delay(0.2),
                              .duration(0.4),
                              .fadeIn,
                              .background(color: .primaryColor)
                            ])
    }
    
    fileprivate func animateQuestionAccelerateOut(_ animatedView: UIView) {
        let yDistance = animatedView.bounds.height
        animatedView.animate([.duration(0.4),
                              .translate(x: 0, y: -yDistance),
                              .timingFunction(.acceleration)
                            ])
    }
}

// MARK: UITextFieldDelegate
extension CalculatorController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == numberInputTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
