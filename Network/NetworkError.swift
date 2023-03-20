//
//  NetworkError.swift
//  Walmart-WaIE
//
//  Created by kandavel on 02/03/23.
//

import Foundation
enum NetworkError: Error {
    case invalidRequest
    case dataMissing
    case endpointNotMocked
    case mockDataMissing
    case responseError(error: Error)
    case parserError(error: Error)
    case reachabilityError(error : Error)
}
