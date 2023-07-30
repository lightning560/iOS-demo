//
//  ReplyModel.swift
//  light
//
//  Created by LiangNing on 2023/06/22.
//

import Foundation

struct FloorsModelWrap: Codable {
    var floors: [FloorModel]?
    var total: Int?
    var cursor: CursorModel?
}

struct RepliesModelWrap: Codable {
    var replies: [ReplyModel]?
    var total: Int?
    var cursor: CursorModel?
}

// MARK: - Floor

class FloorModel: Codable, Identifiable {
    var ID: String?
    var rootReply: ReplyModel?
    var replies: [ReplyModel]?
    var total: Int?
    var cursor: CursorModel?

    enum CodingKeys: String, CodingKey {
        case rootReply = "root_reply"
        case replies, total, cursor
    }
}

// MARK: - FloorAttr

struct FloorAttrModel: Codable {
    var replyCount, pinAdmin, pinOwner, fold: Int?
    var hot: Bool?

    enum CodingKeys: String, CodingKey {
        case replyCount = "reply_count"
        case pinAdmin = "pin_admin"
        case pinOwner = "pin_owner"
        case fold, hot
    }
}

// MARK: - Reply

struct ReplyModel: Codable {
    var id, subjectID, bizType: String?
    var ownerUid: String?
    var floorID, content, atUid: String?
    var state, createdAt, updatedAt, deleted: Int?
    var likeCount, dislikeCount, fanGrade: Int?
    var device: String?
    var floorAttr: FloorAttrModel?
    var userInfo: UserInfoModel?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerUid = "owner_uid"
        case subjectID = "subject_id"
        case bizType = "biz_type"
        case floorID = "floor_id"
        case content
        case atUid = "at_uid"
        case state
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deleted
        case likeCount = "like_count"
        case dislikeCount = "dislike_count"
        case fanGrade = "fan_grade"
        case device
        case floorAttr = "floor_attr"
        case userInfo = "user_info"
    }
}
