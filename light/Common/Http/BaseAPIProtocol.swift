//
//  BaseAPIProtocol.swift
//  light
//
//  Created by LiangNing on 2023/07/13.
//

import Alamofire
import Foundation

protocol BaseAPIProtocol {
    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var headers: [String: String]? { get }
}

extension BaseAPIProtocol {
    var baseURL: URL {
        return try! NetworkConfig.baseURL.asURL()
    }

    var headers: [String: String]? {
        return nil
    }
}
