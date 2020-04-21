//
//  DetailView.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit
import Charts

class DetailView: UIView {
    // MARK: - Components -
    let chartView: LineChartView = {
        let chart = LineChartView()
        chart.backgroundColor = .systemBackground
        chart.gridBackgroundColor = .systemBackground
        chart.xAxis.labelTextColor = .systemBackground
        chart.borderColor = .systemOrange
        chart.noDataTextColor = .systemOrange
        chart.xAxis.labelTextColor = .systemOrange
        chart.leftAxis.labelTextColor = .systemOrange
        chart.rightAxis.labelTextColor = .systemOrange
        
        chart.drawBordersEnabled = true
        chart.pinchZoomEnabled = false
        chart.dragEnabled = true
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.labelRotationAngle = 45
        chart.xAxis.drawGridLinesEnabled = true
        chart.xAxis.centerAxisLabelsEnabled = true
        
        chart.xAxis.labelFont = .boldSystemFont(ofSize: 10)
        chart.leftAxis.labelFont = .boldSystemFont(ofSize: 10)
        chart.rightAxis.labelFont = .boldSystemFont(ofSize: 10)
        return chart
    }()
    
    let startDateInputForm: FormInputView = {
        let input = FormInputView()
        input.tag = 0
        input.nameLabel.text = Texts.startDateInputFormLabel
        input.dateTextField.text = Texts.startDateInputFormTextField
        return input
    }()
    
    let endDateInputForm: FormInputView = {
        let input = FormInputView()
        input.tag = 1
        input.nameLabel.text = Texts.endDateInputFormLabel
        input.dateTextField.text = Texts.endDateInputFormTextField
        return input
    }()
    
    // MARK: - Inits -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods -
    private func doLayout() {
        addSubview(chartView)
        addSubview(startDateInputForm)
        addSubview(endDateInputForm)
        
        backgroundColor = .systemBackground
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        let chartViewConstraints = [chartView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constraints.chartViewTopMargin),
                                    chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.chartViewLeftMargin),
                                    chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constraints.chartViewRightMargin),
                                    chartView.heightAnchor.constraint(equalToConstant: Constraints.chartViewHeight)]
        
        NSLayoutConstraint.activate(chartViewConstraints)
        
        startDateInputForm.translatesAutoresizingMaskIntoConstraints = false
        let startDateInputFormConstraints = [startDateInputForm.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: Constraints.startDateInputFormTopMargin),
                                             startDateInputForm.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.startDateInputFormLeftMargin),
                                             startDateInputForm.trailingAnchor.constraint(equalTo: centerXAnchor, constant: Constraints.startDateInputFormRightMargin),
                                             startDateInputForm.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor)]
        
        NSLayoutConstraint.activate(startDateInputFormConstraints)
        
        endDateInputForm.translatesAutoresizingMaskIntoConstraints = false
        let endDateInputFormConstraints = [endDateInputForm.topAnchor.constraint(equalTo: startDateInputForm.topAnchor),
                                           endDateInputForm.leadingAnchor.constraint(equalTo: centerXAnchor, constant: Constraints.endDateInputFormLeftMargin),
                                           endDateInputForm.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constraints.endDateInputFormRightMargin),
                                           endDateInputForm.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor)]
        
        NSLayoutConstraint.activate(endDateInputFormConstraints)
    }
}

// MARK: - Static values -
private extension DetailView {
    struct Constraints {
        static let chartViewTopMargin: CGFloat = 20
        static let chartViewLeftMargin: CGFloat = 20
        static let chartViewRightMargin: CGFloat = -20
        static let chartViewHeight: CGFloat = 400
        
        static let startDateInputFormTopMargin: CGFloat = 20
        static let startDateInputFormLeftMargin: CGFloat = 24
        static let startDateInputFormRightMargin: CGFloat = -8
        
        static let endDateInputFormLeftMargin: CGFloat = 8
        static let endDateInputFormRightMargin: CGFloat = -24
    }
    
    struct Texts {
        static let startDateInputFormLabel: String = "Data startowa"
        static let endDateInputFormLabel: String = "Data końcowa"
        
        static let startDateInputFormTextField: String = DateFormatter.ddMMyyyyDashes.string(from: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date())
        static let endDateInputFormTextField: String = DateFormatter.ddMMyyyyDashes.string(from: Date())
    }
}
