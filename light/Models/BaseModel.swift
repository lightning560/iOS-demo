//
//  BaseModel.swift
//  light
//
//  Created by LiangNing on 2023/06/18.
//

import Foundation

// MARK: - Cursor

struct CursorModel: Codable {
    let offset, limit: Int
}

// MARK: - Image

struct ImageModel: Codable, Identifiable {
    let id: Int
    let url: String
    let hash, name: String?
    let sizeKB, width, height: Int

    enum CodingKeys: String, CodingKey {
        case id, url, hash, name
        case sizeKB = "size_kb"
        case width, height
    }
}

// MARK: - Video

struct VideoModel: Codable {
    var id: Int?
    var url: String?
    var type: String?
    var cover: ImageModel?
    var hash, name: String?
    var sizeKB, width, height, length: Int?
    var createdAt: Int?
}

// MARK: - Tag

struct TagModel: Codable {
    let tagID: Int
    let name: String
    let bizType: String

    enum CodingKeys: String, CodingKey {
        case tagID = "tag_id"
        case name
        case bizType = "biz_type"
    }
}

// MARK: - UserInfo

struct UserInfoModel: Codable {
    let id, uid: Int
    let name: String
    let sex: Int
    let avatar: ImageModel
    let sign: String
    let state, level: Int
}
