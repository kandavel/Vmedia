//
//  NetworkManager.swift
//  Vmedia
//
//  Created by kandavel on 18/03/23.
//

import Foundation
import Alamofire

typealias ResultCallback<T> = (Result<T, NetworkError>) -> Void
typealias ChannelListResponse = (Result<[Channel], NetworkError>)

protocol NetworkManagerProtocol  : AnyObject {
    func request<T: Codable>(_ request: URLRequestConvertible,
                             decodeToType type: T.Type,
                             completionHandler: @escaping ResultCallback<T>)
}

final class NetworkManager {
    static let shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()

    
    fileprivate let parser: Parser =  Parser()
    let reachabilityManager = NetworkReachabilityManager()?.isReachable
    func isConnectedToInternet() -> Bool {
        return reachabilityManager ?? false
    }
    
}
extension NetworkManager : NetworkManagerProtocol {
    func request<T: Codable>(_ request: URLRequestConvertible,
                             decodeToType type: T.Type,
                             completionHandler: @escaping ResultCallback<T>) {
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let data):
                self.parser.json(data: data, completition: completionHandler)
            case .failure(let error):
                completionHandler(.failure(.responseError(error: error)))
            }
        }
    }
}
