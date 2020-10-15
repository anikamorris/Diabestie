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
//        textField.backgroundColor = .white
//        textField.layer.cornerRadius = 5
//        textField.clipsToBounds = true
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
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        allQuestions = question.allQuestions()
        questionViews = [anyCorrectionsView, eatingNowView, currentBGView]
        questionLabels = [anyCorrectionsView.questionLabel, eatingNowView.questionLabel, currentBGView.questionLabel]
        setQuestionText()
        setUpInitialView()
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
            make.top.equalTo(questionContainer.snp_bottomMargin).offset(30)
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
        hideAllViewsExceptFirst()
    }
    
    fileprivate func setQuestionViewConstraints(view: QuestionView) {
        view.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.8)
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
    
    fileprivate func saveNumber() {
        let response = numberInputTextField.text
        if currentIndex == 4 {
            guard let hoursSince = Double(response!) else {
                print("couldn't turn hoursSince into a double")
                return
            }
            answer.hoursSince = hoursSince
        } else {
            if currentIndex == 2 {
                guard let currentBG = Int(response!) else {
                    print("couldn't turn currentBG into an int")
                    return
                }
                answer.currentBG = currentBG
            } else if currentIndex == 3 {
                guard let numCarbs = Int(response!) else {
                    print("couldn't turn numCarbs into an int")
                    return
                }
                answer.numCarbs = numCarbs
            } else {
                guard let lastCorrectionUnits = Int(response!) else {
                    print("couldn't turn lastCorrectionUnits into an int")
                    return
                }
                answer.lastCorrectionUnits = lastCorrectionUnits
            }
        }
    }
    
    @objc func selectedSegmentedDidChange() {
        nextButton.isHidden = false
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
        if currentIndex == questionLabels.count - 1 {
            print("finished questions")
            return
        }
        segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        animateFadeOut(questionViews[currentIndex])
        animateFadeOut(questionLabels[currentIndex])
        currentIndex += 1
        animateQuestionViewDropIn(questionViews[currentIndex])
        animateQuestionLabelDropIn(questionLabels[currentIndex])
        backButton.isHidden = false
        if currentIndex == 2 {
            setQuestionViewsForAnswer()
            setQuestionText()
            segmentedControl.isHidden = true
            numberInputTextField.isHidden = false
        } else if currentIndex < 2 {
            segmentedControl.isHidden = false
            numberInputTextField.isHidden = true
        } else {
            segmentedControl.isHidden = true
            numberInputTextField.isHidden = false
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
}

// MARK: Animations
extension CalculatorController {
    fileprivate func animateFadeOut(_ animatedView: UIView) {
        animatedView.animate([.duration(0.2),
                              .fadeOut,
                              .background(color: .clear)
                            ])
    }
    
    fileprivate func animateQuestionViewDropIn(_ animatedView: UIView) {
        let windows = UIApplication.shared.windows
        let safeAreaTop = windows[0].safeAreaInsets.top
        let xPoint = view.bounds.width * 0.5
        let yPoint = CGFloat(0) - animatedView.bounds.height/2 + 30 + safeAreaTop
        let yDistance = animatedView.bounds.height
        
        animatedView.animate([.delay(0.1),
                              .duration(0.15),
                              .position(CGPoint(x: xPoint, y: yPoint)),
                              .timingFunction(.deceleration)
                            ], completion: {
                                animatedView.isHidden = false
                                animatedView.animate([.duration(0.5),
                                                      .translate(x: 0,
                                                                 y: yDistance,
                                                                 z: 1),
                                                     .timingFunction(.deceleration)
                                                    ])
                            })
    }
    
    fileprivate func animateQuestionLabelDropIn(_ animatedLabel: UILabel) {
        let xPoint = view.bounds.width * 0.425
        let yPoint = CGFloat(0) - animatedLabel.bounds.height/2
        let yDistance = animatedLabel.bounds.height
        
        animatedLabel.animate([.delay(0.1),
                               .duration(0.15),
                              .position(CGPoint(x: xPoint, y: yPoint)),
                              .timingFunction(.deceleration)
                            ], completion: {
                                animatedLabel.isHidden = false
                                animatedLabel.animate([.duration(0.5),
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
