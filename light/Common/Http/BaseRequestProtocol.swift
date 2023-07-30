//
//  BaseRequestProtocol.swift
//  light
//
//  Created by LiangNing on 2023/07/13.
//

import Alamofire
import Combine
import Foundation

protocol BaseRequestProtocol: BaseAPIProtocol, URLRequestConvertible {
    var parameters: Parameters? { get }
    var encoding: URLEncoding { get }
}

extension BaseRequestProtocol {
    var encoding: URLEncoding {
        return .default
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))

        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = TimeInterval(30)

        if let params = parameters {
            urlRequest = try encoding.encode(urlRequest, with: params)
        }

        return urlRequest
    }
}
