//
//  RbRequest.swift
//  light
//
//  Created by LiangNing on 2023/06/18.
//

import Foundation

protocol FeedRequest {
    func fetchListPostCard(offset: Int, limit: Int, by: String, order: String) async throws -> PostCardsModelWrap
    func fetchPostById(id: String) async throws -> PostModelWrap
}

extension FeedRequest {
    func fetchListPostCard(offset: Int, limit: Int, by: String, order: String) async throws -> PostCardsModelWrap {
        // http://127.0.0.1:9002/v1/feed/cards/0/5/by/order
        let result = try await RbHttpTool.awaitRequest(url: LocalUrl.feed.url + Req.listPostCard.path + "/" + String(offset) + "/" + String(limit) + "/" + by + "/" + order, method: .get, responseType: PostCardsModelWrap.self)
        return result.data!
    }

    func fetchPostById(id: String) async throws -> PostModelWrap {
        let result = try await RbHttpTool.awaitRequest(url: LocalUrl.feed.url + Req.post.path + "/" + id, method: .get, responseType: PostModelWrap.self)
        return result.data!
    }
}
