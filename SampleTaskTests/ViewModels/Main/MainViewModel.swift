//
//  MainViewModel.swift
//  SampleTaskTests
//
//  Created by Bartłomiej Łaski on 13/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//  swiftlint:disable force_cast function_body_length superfluous_disable_command

import Quick
import Nimble
import Swinject
import RxSwift

@testable
import SampleTask

extension MainViewModelSpec {
    
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
            var httpHandler: MockedHTTPHandler!
            
            let bag = DisposeBag()
            
            beforeEach {
                container = Container()
                
                container.register(HTTPHandlerProtocol.self) { _ in MockedHTTPHandler() }.inObjectScope(.container)
                container.register(TableRequestServiceProtocol.self) { resolver in
                    return TableRequestService(httpHandler: resolver.resolve(HTTPHandlerProtocol.self)!)
                }
                
                container.register(MainViewModel.self) { resolver in
                    let service = resolver.resolve(TableRequestServiceProtocol.self)!
                    let viewModel = MainViewModel()
                    viewModel.tableRequestManager = service
                    return viewModel
                }
                
                httpHandler = (container.resolve(HTTPHandlerProtocol.self) as! MockedHTTPHandler)
                viewModel = (container.resolve(MainViewModel.self))!
                
            }
            
            describe("Should reload data after load data from api.") {
                var shouldReturnCurrencies = false
                beforeEach {
                    httpHandler.shouldReturnSuccess = true
                    
                    viewModel.currencies
                        .subscribe(onNext: { _ in
                            shouldReturnCurrencies = true
                        }
                    ).disposed(by: bag)
                    
                    viewModel.fetchSelectedTable(tableName: "A")
                }
                
                it("Should reload data") {
                    expect(shouldReturnCurrencies).to(beTrue())
                }
            }

            describe("Gettin reponse with error") {
                var shouldThrowError = false
                beforeEach {
                    httpHandler.shouldReturnSuccess = false
                    
                    viewModel.didFailLoadTable.subscribe(
                        onNext: { _ in
                            shouldThrowError = true
                        }
                    ).disposed(by: bag)
                    
                    viewModel.fetchSelectedTable(tableName: "A")
                }

                it("Should throw error") {
                    expect(shouldThrowError).to(beTrue())
                }
            }
        }
    }
}
