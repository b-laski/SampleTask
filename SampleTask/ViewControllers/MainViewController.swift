//
//  MainViewController.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 10/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Private variables -
    private let mainView = MainView()
    private let refresher = UIRefreshControl()
    private lazy var mainViewModel = MainViewModel(delegate: self)
    
    // MARK: - Inits -
    override func loadView() {
        view = mainView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods -
    private func setupView() {
        title = "Home"
        
        mainView.menuBarView.menuBarDelegate = self
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
        
        mainView.collectionView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    // MARK: - Actions -
    @objc private func refreshData() {
        if let selectedItem = mainView.menuBarView.selectedItem {
            mainViewModel.fetchSelectedTable(tableName: selectedItem.text)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource -
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainViewModel.tableData?.rates.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.identifier, for: indexPath) as! MainCell
        
        let currency = mainViewModel.tableData?.rates[indexPath.item]
        
        cell.currencyNameLabel.text = "\(currency?.currency?.uppercased() ?? "") (\(currency?.code?.uppercased() ?? ""))"
        cell.dateLabel.text = mainViewModel.tableData?.effectiveDate
        cell.averagePriceLabel.text = currency?.mid != nil ? "\(currency?.mid ?? 0.00)" : "\(currency?.average() ?? 0.00)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = mainView.menuBarView.selectedItem, let currency = mainViewModel.tableData?.rates[indexPath.item] {
            
            let detailViewControlle = DetailViewController(tableType: selectedItem.text, currency: currency)
            navigationController?.pushViewController(detailViewControlle, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100.0)
    }
    
}

// MARK: - MenuBarDelegate -
extension MainViewController: MenuBarDelegate {
    func cellDidSelect(tabelName: String) {
        mainViewModel.clearTableData()
        mainView.collectionView.refreshControl?.beginRefreshing()
        mainViewModel.fetchSelectedTable(tableName: tabelName)
    }
}

// MARK: - MainViewModelDelegate -
extension MainViewController: MainViewModelDelegate {
    func reloadData() {
        refresher.endRefreshing()
        mainView.collectionView.reloadData()
    }
}
