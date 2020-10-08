//
//  InputView.swift
//  Tracker
//
//  Created by Michal Miko on 05/10/2020.
//

import Foundation
import UIKit

protocol InputViewDelegate: class {
    func dateDidChanged(inputView: InputView, date: Date)
    func textDidChange(inputView: InputView, text: String)
}

class InputView: UIView {
    weak var delegate: InputViewDelegate?
    
    enum InputType: Equatable {
        case datePicker
        case durationPicker
        case textfield
        case segmentedControl([String])
    }
    
    var text: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.textField.text = self.text
                self.delegate?.textDidChange(inputView: self, text: self.text)
            }
        }
    }
    
    /// Used for segmentcontroller
    var selectedIndex: Int = 0
    
    /// Used in durationPicker
    var startDate: Date?
    
    /// Used in datePicker and durationPicker
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval = 5
        return datePicker
    }()
    
    private let lblTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppTheme.Colors.labelTitle
        label.font = AppTheme.Fonts.labelTitle
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 10
        textField.font = AppTheme.Fonts.textfield
        textField.adjustsFontForContentSizeCategory = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let type: InputType
    
    init(title: String = "", type: InputType) {
        self.type = type
        super.init(frame: .zero)
        addSubview(lblTitle)
        lblTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        lblTitle.text = title
        
        switch type {
        case .datePicker:
            setUpTextField()
            datePicker.datePickerMode = .dateAndTime
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        case .textfield:
            setUpTextField()
        case .durationPicker:
            setUpTextField()
            textField.inputView = datePicker
            datePicker.datePickerMode = .countDownTimer
            datePicker.countDownDuration = 300
            datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        case .segmentedControl(let items):
            let segmentedControl = UISegmentedControl(items: items)
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            addSubview(segmentedControl)
            segmentedControl.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 10).isActive = true
            segmentedControl.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor).isActive = true
            segmentedControl.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor).isActive = true
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.addTarget(self, action: #selector(handleSegmentedControl(_:)), for: .valueChanged)
           // segmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        }
        
        
    }
    
    func fixPickerGlitch() {
        guard type == .durationPicker else { return }
        self.datePicker.setDate(Date(), animated: true)
        0.5 ~> {
            DispatchQueue.main.async {
                self.datePicker.datePickerMode = .countDownTimer
                self.datePicker.minuteInterval = 5
                self.datePicker.countDownDuration = 300
            }
        }
    }
    
    func setUpTextField() {
        let bottomLine = UIView()
        addSubview(bottomLine)
        addSubview(textField)
        textField.delegate = self
        textField.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor).isActive = true
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = .lightGray
        bottomLine.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: -2).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setDate(_ date: Date) {
        guard type == .datePicker else { return }
        datePicker.date = date
        handleDatePicker(datePicker)
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        switch type {
        case .durationPicker:
            text = Formatters.duration.string(from: DateInterval(start: startDate ?? Date(), duration: datePicker.countDownDuration)) ?? ""
        case .datePicker:
            text = Formatters.date.string(from: datePicker.date)
            delegate?.dateDidChanged(inputView: self, date: sender.date)
        default:
            break
        }
    }
    
    @objc func handleSegmentedControl(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        text = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
