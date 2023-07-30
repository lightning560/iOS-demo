//
//  PostModel.swift
//  light
//
//  Created by LiangNing on 2023/06/21.
//

import Foundation

// MARK: - Post

struct PostModelWrap:Codable{
    var post :PostModel
}
struct PostModel: Codable {
    var id: String
    var uid: Int
    var title, content: String?
    var createdAt, updatedAt: Int?
    var cover: ImageModel?
    var type: String
    var images : [ImageModel]?
    var video: VideoModel?
    var tags: [TagModel]?
    var state, likeCount, shareCount, favorCount: Int
    var viewCount: Int?
    var commentID: String?
    var authorInfo: UserInfoModel?
    
    enum CodingKeys: String, CodingKey {
        case id, uid, title, content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cover, type, images, video, tags, state
        case likeCount = "like_count"
        case shareCount = "share_count"
        case favorCount = "favor_count"
        case viewCount = "view_count"
        case commentID = "comment_id"
        case authorInfo = "author_info"
    }
}
