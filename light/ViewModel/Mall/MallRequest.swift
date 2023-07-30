//
//  MallRequest.swift
//  light
//
//  Created by LiangNing on 2023/06/23.
//


import Foundation

protocol MallRequest {
    func fetchShopById(id: String) async throws -> SubjectModelWrap
    func fetchListFloorBySubject(subjectId: String, offset: Int, limit: Int, by: String, order: String) async throws -> FloorsModelWrap
    func fetchListReplyByFloor(subjectId: String, floorId: String, offset: Int, limit: Int, by: String, order: String) async throws -> RepliesModelWrap
}

extension MallRequest {}
