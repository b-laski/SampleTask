//
//  HTTPHandler.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 10/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation

protocol HTTPHandlerProtocol: class {
    func make<T: Codable>(request: HTTPHandlerRequestProtocol, completion: @escaping (Result<T, Error>) -> Void)
    func cancel()
}

class HttpHandler: HTTPHandlerProtocol {
    
    private let urlSession: URLSession
    private let completionQueue: DispatchQueue
    var currentTask: URLSessionDataTask? = nil
    
    init(urlSession: URLSession = URLSession(configuration: .default), completionQueue: DispatchQueue = DispatchQueue.main) {
        self.urlSession = urlSession
        self.completionQueue = completionQueue
    }
    
    func make<T: Codable>(request: HTTPHandlerRequestProtocol, completion: @escaping (Result<T, Error>) -> Void) {
        runRequest(request: request) { [weak self] (result: T?, error: Error?) in
            guard let strongSelf = self else { return }
            
            strongSelf.completionQueue.async {
                if let error = error {
                    completion(Result.failure(error))
                    return
                }
                
                guard let result = result else { return }
                
                completion(Result.success(result))
            }
        }
    }
    
    func cancel() {
        currentTask?.cancel()
    }
    
    private func prepareUrl(request: HTTPHandlerRequestProtocol) -> URL? {
        let endpoint = Const.Api.NBPApiUrl.rawValue + request.endpoint
        var urlComponent = URLComponents(string: endpoint)
        
        if let queryParameters = request.queryParameters {
            let queryItems = queryParameters.map{ URLQueryItem(name: $0.key, value: $0.value) }
            
            urlComponent?.queryItems = queryItems
        }
        
        return urlComponent?.url
    }
    
    private func prepareRequest(_ finalUrl: URL, request: HTTPHandlerRequestProtocol) -> URLRequest? {
        var urlRequest = URLRequest(url: finalUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        urlRequest.httpMethod = request.method.rawValue
        request.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return urlRequest
    }
    
    private func runRequest<T: Codable>(request: HTTPHandlerRequestProtocol, completion: @escaping (T?, Error?) -> Void) {
        guard let finalUrl = prepareUrl(request: request) else {
            completion(nil, HTTPHandlerError.incorectUrl)
            return
        }
        
        guard let urlRequest = prepareRequest(finalUrl, request: request) else {
            completion(nil, HTTPHandlerError.incorectRequest)
            return
        }
        
        currentTask = urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 300...510:
                    completion(nil, HTTPHandlerError.wrongStatusCode(code: response.statusCode))
                default:
                    break
                }
            }
            
            
            if let data = data {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                
                do {
                    let model = try jsonDecoder.decode(T.self, from: data)
                    completion(model, nil)
                } catch let error {
                    completion(nil, error)
                }
            }
            
        })
        
        currentTask?.resume()
    }
}
