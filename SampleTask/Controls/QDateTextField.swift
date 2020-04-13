//
//  QDateTextField.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit

protocol QDateTextFieldDelegate: UITextFieldDelegate {
    func valueChanged(_ sender: UITextField)
}

class QDateTextField: UITextField {
    
    weak var qDelegate: QDateTextFieldDelegate?
    
    // MARK: - Properties -
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    var unixTimestamp: Int64 = 0
    
    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        inputView = datePicker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        text = DateFormatter.ddMMyyyyDashes.string(from: sender.date)
        qDelegate?.valueChanged(self)
    }
}
