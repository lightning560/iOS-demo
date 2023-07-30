//
//  HttpBaseModel.swift
//  light
//
//  Created by LiangNing on 2023/07/13.
//

import Foundation

struct NetworkBaseModel<T: Codable>: Codable {
    var code: Int?
    var message: String?
    var data: T?
}

struct NetworkNilModel: Codable {
}
