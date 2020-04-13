//
//  MainViewModel.swift
//  SampleTaskTests
//
//  Created by Bartłomiej Łaski on 13/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable
import SampleTask

extension MainViewModelSpec {
    class MockingMainViewModelDelegate: MainViewModelDelegate {
        
        var reloadedData = false
        func reloadData() {
            reloadedData = true
        }
        
        var messageSent = false
        func showMessage(title: String, body: String) {
            messageSent = true
        }
    }
    
    class MockingHTTPHandler: HTTPHandlerProtocol {
        var shouldReturnSuccess = false
        func make<T: Codable>(request: HTTPHandlerRequestProtocol, completion: @escaping (Result<T, Error>) -> Void) {
            
            let responseModel = [Table(table: "A",
                                      no: "NO/123/123",
                                      tradingDate: "2020-03-20",
                                      effectiveDate: "2020-03-20",
                                      currency: "dolar amrykański",
                                      code: "USD",
                                      rates: [Currency(currency: "dolar amerykański",
                                                       code: "USD", no: "NO/123/123",
                                                       effectiveDate: "2020-03-20",
                                                       bid: nil,
                                                       ask: nil,
                                                       mid: 3.987)])]
            
            guard let castedResponseModel = responseModel as? T else { return }
            
            let result: Result<T, Error> = shouldReturnSuccess == true ?
                .success(castedResponseModel) :
                .failure(HTTPHandlerError.wrongStatusCode(code: 404))
            
            completion(result)
        }
        
        func cancel() { }
    }
}


class MainViewModelSpec: QuickSpec {
    override func spec() {
        describe("MainViewModelSpec") {
            
            var sut: MainViewModel!
            var httpHandler: MockingHTTPHandler!
            var delegate: MockingMainViewModelDelegate!
            
            beforeEach {
                httpHandler = MockingHTTPHandler()
                delegate = MockingMainViewModelDelegate()
                
                DIContainter.container.register { httpHandler as HTTPHandlerProtocol }
                sut = MainViewModel(delegate: delegate)
                
                
            }
            
            describe("Should reload data after load data from api.") {
                beforeEach {
                    httpHandler.shouldReturnSuccess = true
                    sut.fetchSelectedTable(tableName: "A")
                }
                
                it("Should reload data") {
                    expect(delegate.reloadedData).to(beTrue())
                }
            }
            
            describe("Should show message") {
                beforeEach {
                    httpHandler.shouldReturnSuccess = false
                    sut.fetchSelectedTable(tableName: "A")
                }
                
                it("Should reload data") {
                    expect(delegate.messageSent).to(beTrue())
                }
            }
            
            describe("Should clear data and cast reloadData") {
                beforeEach {
                    
                    delegate.reloadedData = false
                    sut.tableData = Table(table: "A",
                                          no: "NO/123/123",
                                          tradingDate: "2020-03-20",
                                          effectiveDate: "2020-03-20",
                                          currency: "dolar amrykański",
                                          code: "USD",
                                          rates: [Currency(currency: "dolar amerykański",
                                                           code: "USD", no: "NO/123/123",
                                                           effectiveDate: "2020-03-20",
                                                           bid: nil,
                                                           ask: nil,
                                                           mid: 3.987)])
                    sut.clearTableData()
                }
                
                it("Should reload data") {
                    expect(sut.tableData).to(beNil())
                    expect(delegate.reloadedData).to(beTrue())
                }
            }
        }
    }
}
