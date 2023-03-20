//
//  Router.swift
//  Vmedia
//
//  Created by kandavel on 18/03/23.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {

    static let apiKey = ""

    case channelList(page: String)
    case channelProgramList(page: String)

    var baseURL : URL {
        return URL(string: "https://demo-c.cdn.vmedia.ca/")!
    }

    var method: HTTPMethod {
        switch self {
        case .channelList:
            return .get
        case .channelProgramList:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .channelList( _):
            return nil
        case .channelProgramList(page: _):
            return nil
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var path: String {
        switch self {
        case .channelList:
            return "json/Channels"
        case .channelProgramList(page: _):
            return  "json/ProgramItems"
            
        }
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.cachePolicy  = .returnCacheDataDontLoad

        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()

        var completeParameters = parameters ?? [:]
        let urlRequestPrint = try encoding.encode(urlRequest, with: completeParameters)
        debugPrint("************> MY URL: ", urlRequestPrint.url ?? "")
        return try encoding.encode(urlRequest, with: completeParameters)
    }
}
