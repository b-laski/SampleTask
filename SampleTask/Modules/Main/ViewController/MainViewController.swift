//
//  MainViewController.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 10/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController {
    
    // MARK: - Private variables -
    private let mainView = MainView()
    private lazy var viewmModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits -
    override func loadView() {
        view = mainView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
        makeBinds()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods -
    private func setupView() {
        title = "Home"
        
        mainView.menuBarView.menuBarDelegate = self
        mainView.collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
        mainView.refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        mainView.collectionView.delegate = self

    }
    
    private func makeBinds() {
        _ = viewmModel.currencies.subscribe(onNext: { [weak self] _ in self?.mainView.refresher.endRefreshing() },
                                            onError: { [weak self] in self?.showMessage(title: "Error", body: $0.localizedDescription)})
        
        viewmModel.segments.bind(to: mainView.menuBarView.rx
            .items(cellIdentifier: MenuBarCell.identifier, cellType: MenuBarCell.self)) { [weak self] _, attribute, cell in
                guard let strongSelf = self else { return }
                cell.prepareForReuse()
                cell.attribute = attribute
        }.disposed(by: disposeBag)
        
        viewmModel.currencies.bind(to: mainView.collectionView.rx
            .items(cellIdentifier: MainCell.identifier, cellType: MainCell.self)) { [weak self] (_, currency, cell) in
                guard let strongSelf = self else { return }
                cell.currency = currency
                cell.effectiveDate = strongSelf.viewmModel.table?.effectiveDate
        }.disposed(by: disposeBag)
    
        _ = mainView.collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let strongSelf = self else { return }
            let cell = strongSelf.mainView.collectionView.cellForItem(at: indexPath) as? MainCell
            
            guard let tableType = strongSelf.viewmModel.table?.table, let currency = cell?.currency  else { return }
            let detailViewController = DetailViewController(tableType: tableType, currency: currency)
            strongSelf.navigationController?.pushViewController(detailViewController, animated: true)
        })
    }
    
    // MARK: - Actions -
    @objc private func refreshData() {
        if let selectedItem = mainView.menuBarView.selectedItem {
            viewmModel.fetchSelectedTable(tableName: selectedItem.text)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource -
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100.0)
    }
}

// MARK: - MenuBarDelegate -
extension MainViewController: MenuBarDelegate {
    func cellDidSelect(tabelName: String) {
        viewmModel.clearTableData()
        mainView.collectionView.refreshControl?.beginRefreshing()
        viewmModel.fetchSelectedTable(tableName: tabelName)
    }
}
