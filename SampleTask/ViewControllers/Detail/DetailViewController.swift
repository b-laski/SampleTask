//
//  DetailViewController.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController {
    
    // MARK: - Private variables-
    private let detailView = DetailView()
    private lazy var detailViewModel = DetailViewModel(delegate: self)
    private let tableType: String
    private let currency: Currency
    
    private var startDate: String = ""
    private var endDate: String = ""
    
    // MARK: - Inits -
    override func loadView() {
        view = detailView
    }
    
    init(tableType: String, currency: Currency) {
        self.tableType = tableType
        self.currency = currency
        
        super.init(nibName: nil, bundle: nil)
        
        [detailView.startDateInputForm.dateTextField,
         detailView.endDateInputForm.dateTextField].forEach({
            $0.qDelegate = self
         })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let code = currency.code else { return }
        title = currency.currency
        
        showSpinner(onView: detailView)
        
        startDate = detailView.startDateInputForm.dateTextField.text ?? ""
        endDate = detailView.endDateInputForm.dateTextField.text ?? ""
        detailViewModel.fetchCurrencyData(tableType: tableType, code: code, startDate: startDate, endDate: endDate)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        detailView.endEditing(true)
    }
    
    // MARK: - Private methods -
    private func setDataToChart() {
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = detailViewModel.currencyDate?.rates.compactMap({ $0.effectiveDate?.toDate()?.timeIntervalSince1970}).min() {
            referenceTimeInterval = minTimeInterval
        }

        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: DateFormatter.ddMMyyyyDashes)
        
        let xAxis = detailView.chartView.xAxis
        xAxis.valueFormatter = xValuesNumberFormatter

        
        let yVal = detailViewModel.currencyDate?.rates.map({ item -> ChartDataEntry in
            var xValue = 0.0
            if let timeInterval = item.effectiveDate?.toDate()?.timeIntervalSince1970 {
                xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            }
            
            return ChartDataEntry(x: xValue, y: item.mid!)
        })
        
        let dataSet = LineChartDataSet(entries: yVal)
        dataSet.axisDependency = .left
        dataSet.drawCirclesEnabled = false
        dataSet.circleRadius = 15
        dataSet.drawFilledEnabled = true
        dataSet.drawCircleHoleEnabled = false
        dataSet.valueTextColor = .systemOrange

        let data = LineChartData(dataSets: [dataSet])
        detailView.chartView.data = data
        detailView.chartView.animate(xAxisDuration: 0.2)
    }
    
}

// MARK: - Extension QDateTextFieldDelegate -
extension DetailViewController: QDateTextFieldDelegate {
    
    func valueChanged(_ sender: UITextField) {
        guard let code = currency.code else { return }
        showSpinner(onView: detailView)
        if sender.tag == 0 {
            startDate = sender.text ?? ""
        } else {
            endDate = sender.text ?? ""
        }
        
        detailViewModel.fetchCurrencyData(tableType: tableType, code: code, startDate: startDate, endDate: endDate)
    }
}

// MARK: - Extension DetailViewModelDelegate -
extension DetailViewController: DetailViewModelDelegate {
    func reloadChart() {
        setDataToChart()
        removeSpinner()
    }
}
