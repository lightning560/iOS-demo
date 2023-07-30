//
//  SubjectModel.swift
//  light
//
//  Created by LiangNing on 2023/06/22.
//

import Foundation

struct SubjectModelWrap: Codable {
    var subject: SubjectModel
}

// MARK: - Resp

struct SubjectModel: Codable {
    var id, ownerUid, belongID, bizType: String?
    var createdAt, updatedAt, floorCount, replyCount: Int?
    var state, attr: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerUid = "owner_uid"
        case belongID = "belong_id"
        case bizType = "biz_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case floorCount = "floor_count"
        case replyCount = "reply_count"
        case state, attr
    }
}
