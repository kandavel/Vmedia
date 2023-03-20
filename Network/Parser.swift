//
//  Parser.swift
//  Vmedia
//
//  Created by kandavel on 18/03/23.
//

import Foundation
protocol ParserProtocol {
    func json<T: Codable>(data: Data, completition: @escaping ResultCallback<T>)
}

struct Parser {
   private let jsonDecoder = JSONDecoder()
    
    func json<T: Codable>(data: Data, completition: @escaping ResultCallback<T>) {
        do {
            let result: T = try jsonDecoder.decode(T.self, from: data)
            OperationQueue.main.addOperation { completition(.success(result)) }
            
        } catch let error {
            OperationQueue.main.addOperation { completition(.failure(.parserError(error: error))) }
        }
    }
}
