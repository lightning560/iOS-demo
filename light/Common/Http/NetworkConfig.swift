//
//  HttpConfig.swift
//  light
//
//  Created by LiangNing on 2023/07/13.
//

import Foundation

struct NetworkConfig {
    static var baseURL: String {
        #if DEBUG
            return "http://localhost:8080"
        #else
            return "http://localhost:8080"
        #endif
    }

    static let retryCount: Int = 2

    static let contentType = "application/json"

    static let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
}
