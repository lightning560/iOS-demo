//
//  PostCard.swift
//  light
//
//  Created by LiangNing on 2023/06/18.
//

import Foundation

// MARK: - DataClass

struct PostCardsModelWrap: Codable {
    let postCards: [PostCardModel]
    let total: Int
    let cursor: CursorModel

    enum CodingKeys: String, CodingKey {
        case postCards = "post_cards"
        case total, cursor
    }
}

// MARK: - PostCard

struct PostCardModel: Identifiable, Hashable, Codable {
    let id: String
    let uid: Int
    let type, title: String
    let cover: ImageModel
    let likeCount: Int
    let tags: [TagModel]
    let state: Int
    let authorInfo: UserInfoModel

    static func == (lhs: PostCardModel, rhs: PostCardModel) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id, uid, type, title, cover
        case likeCount = "like_count"
        case tags, state
        case authorInfo = "author_info"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(uid)
        hasher.combine(type)
        hasher.combine(title)
    }
}
