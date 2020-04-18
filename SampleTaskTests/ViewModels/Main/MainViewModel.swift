//
//  MainViewModel.swift
//  SampleTaskTests
//
//  Created by Bartłomiej Łaski on 13/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//  swiftlint:disable force_cast function_body_length

import Quick
import Nimble
import Swinject

@testable
import SampleTask

extension MainViewModelSpec {
    class MockedMainViewModelDelegate: MainViewModelDelegate {
        
        var reloadedData = false
        func reloadData() {
            reloadedData = true
        }
        
        var messageSent = false
        func showMessage(title: String, body: String) {
            messageSent = true
        }
    }
    
    class MockedHTTPHandler: HTTPHandlerProtocol {
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
            var container: Container!
            
            var viewModel: MainViewModel!
            var delegate: MockedMainViewModelDelegate!
            var httpHandler: MockedHTTPHandler!
            
            beforeEach {
                container = Container()
                
                container.register(HTTPHandlerProtocol.self) { _ in MockedHTTPHandler() }.inObjectScope(.container)
                container.register(MainViewModelDelegate.self) { _ in MockedMainViewModelDelegate() }.inObjectScope(.container)
                container.register(TableRequestServiceProtocol.self) { resolver in
                    return TableRequestService(httpHandler: resolver.resolve(HTTPHandlerProtocol.self)!)
                }
                
                container.register(MainViewModel.self) { resolver in
                    let service = resolver.resolve(TableRequestServiceProtocol.self)!
                    let delegate = resolver.resolve(MainViewModelDelegate.self)!
                    let mainViewModel = MainViewModel(delegate: delegate)
                    mainViewModel.tableRequestManager = service
                    return mainViewModel
                }
                
                httpHandler = (container.resolve(HTTPHandlerProtocol.self) as! MockedHTTPHandler)
                delegate = (container.resolve(MainViewModelDelegate.self) as! MockedMainViewModelDelegate)
                viewModel = (container.resolve(MainViewModel.self))!
                
            }
            
            describe("Should reload data after load data from api.") {
                beforeEach {
                    httpHandler.shouldReturnSuccess = true
                    viewModel.fetchSelectedTable(tableName: "A")
                }
                
                it("Should reload data") {
                    expect(delegate.reloadedData).to(beTrue())
                }
            }
//
            describe("Should show message") {
                beforeEach {
                    httpHandler.shouldReturnSuccess = false
                    viewModel.fetchSelectedTable(tableName: "A")
                }

                it("Should reload data") {
                    expect(delegate.messageSent).to(beTrue())
                }
            }

            describe("Should clear data and cast reloadData") {
                beforeEach {

                    delegate.reloadedData = false
                    viewModel.tableData = Table(table: "A",
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
                    viewModel.clearTableData()
                }

                it("Should reload data") {
                    expect(viewModel.tableData).to(beNil())
                    expect(delegate.reloadedData).to(beTrue())
                }
            }
        }
    }
}
