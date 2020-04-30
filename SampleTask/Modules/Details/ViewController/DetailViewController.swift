//
//  DetailViewController.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    // MARK: - Private variables-
    private let disposeBag = DisposeBag()
    private let detailView = DetailView()
    private let viewModel: DetailViewModel
    
    // MARK: - Inits -
    override func loadView() {
        view = detailView
    }
    
    init(tableType: String, currency: Currency) {
        viewModel = DetailViewModel(tableType: tableType, currency: currency)
        super.init(nibName: nil, bundle: nil)
        
        title = currency.currency
        setupBinding()
        viewModel.fetchCurrencyData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped(_:)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        detailView.endEditing(true)
    }
    
    // MARK: - Private methods -
    private func setupBinding() {
        detailView.startDateInputForm.dateTextField.rx.text.orEmpty
            .bind(to: viewModel.startDate)
            .disposed(by: disposeBag)
        
        detailView.endDateInputForm.dateTextField.rx.text.orEmpty
            .bind(to: viewModel.endDate)
            .disposed(by: disposeBag)
        
        viewModel.didLoadData
            .subscribe (onNext: { data in
                self.setDataToChart(form: data)
            }
        ).disposed(by: disposeBag)
        
        viewModel.didFailLoadData
            .subscribe (onNext: { error in
                self.showMessage(title: "Error", body: error.localizedDescription)
            }
        ).disposed(by: disposeBag)
        
        detailView.startDateInputForm.dateTextField.rx
            .controlEvent(.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchCurrencyData()
            }).disposed(by: disposeBag)
        
        detailView.endDateInputForm.dateTextField.rx
            .controlEvent(.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchCurrencyData()
            }).disposed(by: disposeBag)
    }
    
    private func setDataToChart(form data: Table) {
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = data.rates.compactMap({ $0.effectiveDate?.toDate()?.timeIntervalSince1970}).min() {
            referenceTimeInterval = minTimeInterval
        }

        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: DateFormatter.ddMMyyyyDashes)
        
        let xAxis = detailView.chartView.xAxis
        xAxis.valueFormatter = xValuesNumberFormatter

        let yVal = data.rates.map({ item -> ChartDataEntry in
            var xValue = 0.0
            if let timeInterval = item.effectiveDate?.toDate()?.timeIntervalSince1970 {
                xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            }
            
            if let mid = item.mid {
                return ChartDataEntry(x: xValue, y: mid)
            } else {
                return ChartDataEntry(x: xValue, y: item.average()!)
            }
            
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
    
    @objc private func refreshButtonTapped(_: Any) {
        viewModel.fetchCurrencyData()
    }
}
