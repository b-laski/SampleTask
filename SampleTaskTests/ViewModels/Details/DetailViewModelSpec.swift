//
//  DetailViewModelSpec.swift
//  SampleTaskTests
//
//  Created by Bartłomiej Łaski on 13/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//  swiftlint:disable force_cast function_body_length superfluous_disable_command

import Quick
import Nimble
import Swinject
import RxTest
import RxSwift
import RxBlocking

@testable
import SampleTask

extension DetailViewModelSpec {
    class MockedHTTPHandler: HTTPHandlerProtocol {
        var shouldReturnSuccess = false
        
        func make<T: Codable>(request: HTTPHandlerRequestProtocol, completion: @escaping (Result<T, Error>) -> Void) {
            let responseModel = Table(table: "A",
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
            
            guard let castedResponseModel = responseModel as? T else { return }
            
            let result: Result<T, Error> = shouldReturnSuccess == true ?
                .success(castedResponseModel) :
                .failure(HTTPHandlerError.wrongStatusCode(code: 404))
            
            completion(result)
        }
        
        func cancel() { }
        
    }
    
}

class DetailViewModelSpec: QuickSpec {
    override func spec() {
        describe("DetailViewModelSpec") {
            var container: Container!
            
            var viewModel: DetailViewModel!
            var httpHandler: MockedHTTPHandler!
            let disposeBag = DisposeBag()
            
            beforeEach {
                container = Container()
                
                container.register(HTTPHandlerProtocol.self) { _ in MockedHTTPHandler() }.inObjectScope(.container)
                container.register(CurrencyServiceProtocol.self) { resolver in
                    return CurrencyService(httpHandler: resolver.resolve(HTTPHandlerProtocol.self)!)
                }
                
                container.register(DetailViewModel.self) { resolver in
                    let service = resolver.resolve(CurrencyServiceProtocol.self)!
                    let detailViewModel = DetailViewModel(tableType: "A", currency: Currency(currency: "",
                                                                                             code: "", no: "",
                                                                                             effectiveDate: "",
                                                                                             bid: 20.0,
                                                                                             ask: 20.0,
                                                                                             mid: 20.0))
                    detailViewModel.currencyService = service
                    return detailViewModel
                }
                
                httpHandler = (container.resolve(HTTPHandlerProtocol.self) as! MockedHTTPHandler)
                viewModel = (container.resolve(DetailViewModel.self))!
            }
            
            describe("Should call to reload data") {
                var shouldBeReloadData = false
                
                beforeEach {
                    httpHandler.shouldReturnSuccess = true
                    
                    viewModel.didLoadData.subscribe(onNext: { _ in
                        shouldBeReloadData = true
                    }).disposed(by: disposeBag)
                    
                    viewModel.didFailLoadData.subscribe({ _ in
                        shouldBeReloadData = false
                    }).disposed(by: disposeBag)
                    
                    viewModel.fetchCurrencyData()
                }

                it("Should reload data") {
                    expect(shouldBeReloadData).to(beTrue())
                }
            }

            describe("Should call to show message") {
                var shouldFailLoadData = false
                
                beforeEach {
                    httpHandler.shouldReturnSuccess = false
                    
                    viewModel.didLoadData.subscribe(onNext: { _ in
                        shouldFailLoadData = false
                    }).disposed(by: disposeBag)
                    
                    viewModel.didFailLoadData.subscribe({ _ in
                        shouldFailLoadData = true
                    }).disposed(by: disposeBag)

                    viewModel.fetchCurrencyData()
                }

                it("Should show message") {
                    expect(shouldFailLoadData).to(beTrue())
                }
            }
        }
    }
}
