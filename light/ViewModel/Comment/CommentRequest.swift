//
//  CommentRequest.swift
//  light
//
//  Created by LiangNing on 2023/06/22.
//

import Foundation

protocol CommentRequest {
    func fetchSubjectById(id: String) async throws -> SubjectModelWrap
    func fetchListFloorBySubject(subjectId: String, offset: Int, limit: Int, by: String, order: String) async throws -> FloorsModelWrap
    func fetchListReplyByFloor(subjectId: String, floorId: String, offset: Int, limit: Int, by: String, order: String) async throws -> RepliesModelWrap
}

extension CommentRequest {
    func fetchSubjectById(id: String) async throws -> SubjectModelWrap {
        let result = try await RbHttpTool.awaitRequest(url: LocalUrl.comment.url + Req.subject.path + "/" + id, method: .get, responseType: SubjectModelWrap.self)
        return result.data!
    }

    //    http://127.0.0.1:9003/v1/comment/floors/1/1/2/reply/order
    func fetchListFloorBySubject(subjectId: String, offset: Int, limit: Int, by: String, order: String) async throws -> FloorsModelWrap {
        let result = try await RbHttpTool.awaitRequest(url: LocalUrl.comment.url + Req.floors.path + "/" + subjectId + "/" + String(offset) + "/" + String(limit) + "/" + by + "/" + order, method: .get, responseType: FloorsModelWrap.self)
        return result.data!
    }

    // http://127.0.0.1:9003/v1/comment/replies/1/1/0/2/like/order
    func fetchListReplyByFloor(subjectId: String, floorId: String, offset: Int, limit: Int, by: String, order: String) async throws -> RepliesModelWrap {
        let result = try await RbHttpTool.awaitRequest(url: LocalUrl.comment.url + Req.floors.path + "/" + subjectId + "/" + floorId + "/" + String(offset) + "/" + String(limit) + "/" + by + "/" + order, method: .get, responseType: RepliesModelWrap.self)
        return result.data!
    }
}
