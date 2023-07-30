//
//  CommentViewModel.swift
//  light
//
//  Created by LiangNing on 2023/06/22.
//

import Foundation

@MainActor
class CommentViewModel: ObservableObject, CommentRequest {
    var floorsOffset: Int = 0
    var floorsLimit: Int = 5
    var floorsBy: String = "reply"
    var floorsOrder: String = "desc"

    var repliesLimit = 5
    var repliesBy = "like"
    var repliesOrder = "desc"

    var subjectModelWrap: SubjectModelWrap?
    var floorsModelWrap: FloorsModelWrap?
    var repliesModelWrap: RepliesModelWrap?

    @Published var subjectData: SubjectModel? = nil
    @Published var floorsDictData: Dictionary<String, FloorModel> = [:]
//    @Published var floorsSortedDictData: Dictionary<String, FloorModel> = [:]

    
    func createdTimeFromTimeStamp(ts: Int) -> String {
        let date = Date.getDateWith(timeStamp: ts)
        let time = Date.getTime(date)
        return time().0 + "-" + time().1 + "-" + time().2 + " " + time().3 + ":" + time().4
    }
    
    func getSubjectById(id: String) async {
        do {
            subjectModelWrap = try await fetchSubjectById(id: id)
            subjectData = subjectModelWrap?.subject
            Dlog(subjectData)
            Dlog(subjectData == nil)
        } catch {
            Dlog(error)
        }
    }

    func listFloorBySubject(subjectId: String) async {
        do {
            floorsModelWrap = try await fetchListFloorBySubject(subjectId: subjectId, offset: floorsOffset, limit: floorsLimit, by: floorsBy, order: floorsOrder)
//            floorsData = floorsData + (floorsModelWrap?.floors)!
            for floor in (floorsModelWrap?.floors)! {
                floor.ID = floor.rootReply?.id
                floorsDictData[(floor.rootReply?.id)!] = floor
            }
//            floorsSortedDictData = floorsDictData.sorted(by: { ($0.1.rootReply?.floorAttr?.replyCount)! > ($1.1.rootReply?.floorAttr?.replyCount)! })
            floorsOffset = floorsOffset + floorsLimit
        } catch {
            Dlog(error)
        }
    }

    func listReplyByFloor(subjectId: String, floorId: String) async {
        let offset = floorsDictData[floorId]!.replies!.count
        do {
            repliesModelWrap = try await fetchListReplyByFloor(subjectId: subjectId, floorId: floorId, offset: offset, limit: repliesLimit, by: repliesBy, order: repliesOrder)

            if floorsDictData[floorId]?.replies != nil {
                floorsDictData[floorId]?.replies = (floorsDictData[floorId]?.replies)! + (repliesModelWrap?.replies)!
            } else {
                floorsDictData[floorId]?.replies = []
                floorsDictData[floorId]?.replies = (floorsDictData[floorId]?.replies)! + (repliesModelWrap?.replies)!
            }

        } catch {
            Dlog(error)
        }
    }
}
