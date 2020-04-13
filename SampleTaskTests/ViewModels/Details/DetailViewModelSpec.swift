//
//  DetailViewModelSpec.swift
//  SampleTaskTests
//
//  Created by Bartłomiej Łaski on 13/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Quick
import Nimble

@testable
import SampleTask

extension DetailViewModelSpec {
    
    class MockedDetailViewModelDelegate: DetailViewModelDelegate {
        var chartDidReloaded = false
        func reloadChart() {
            chartDidReloaded = true
        }
        
        var messageDidSent = false
        func showMessage(title: String, body: String) {
            messageDidSent = true
        }
        
    }
    
    class MockedHTTPHandler: HTTPHandlerProtocol {
        var shouldReturnSuccess = false
        
        func make<T>(request: HTTPHandlerRequestProtocol, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
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
            var sut: DetailViewModel!
            var httpHandler: MockedHTTPHandler!
            var delegate: MockedDetailViewModelDelegate!
            
            beforeEach {
                httpHandler = MockedHTTPHandler()
                delegate = MockedDetailViewModelDelegate()
                DIContainter.container.register { httpHandler as HTTPHandlerProtocol }
                sut = DetailViewModel(delegate: delegate)
            }
            
            describe("Should call to reload data") {
                beforeEach {
                    httpHandler.shouldReturnSuccess = true
                    sut.fetchCurrencyData(tableType: "A", code: "USD", startDate: "2020-03-20", endDate: "2020-04-01")
                }
                
                it("Should reload data") {
                    expect(delegate.chartDidReloaded).to(beTrue())
                }
            }
            
            describe("Should call to show message") {
                beforeEach {
                    httpHandler.shouldReturnSuccess = false
                    sut.fetchCurrencyData(tableType: "A", code: "USD", startDate: "2020-03-20", endDate: "2020-04-01")
                }
                
                it("Should show message") {
                    expect(delegate.messageDidSent).to(beTrue())
                }
            }
        }
    }
}
