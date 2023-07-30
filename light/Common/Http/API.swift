//
//  API.swift
//  light
//
//  Created by LiangNing on 2023/07/13.
//

import Alamofire
import Foundation
import UIKit

enum LocalUrl {
    case user
    case feed
    case comment
    case mall
}

extension LocalUrl {
    var url: String {
        switch self {
        case .user:
            return "http://192.168.1.103:9001/v1/"
        case .feed:
            return "http://192.168.1.103:9002/v1/"
        case .comment:
            return "http://192.168.1.103:9003/v1/"
        case .mall:
            return "http://192.168.1.103:9004/v1/"
        }
    }
}

enum Req {
    case exam(uid: Int, name: String)
    case listPostCard
    case post
    case subject
    case floors
    case replies
}

extension Req {
    // Parameters: http post request
    var parameters: Parameters? {
        var params: Parameters = [:]

        switch self {
        case let .exam(uid, name):
            params["uid"] = uid
            params["name"] = name
        case .listPostCard:
            print(".listPostCard parameters")
        case .post:
            print(".post paramters")
        case .subject:
            print(".subject paramters")
        case .floors:
            print(".floors")
        case .replies:
            print(".replies")
        }
        return params
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        switch self {
        case .exam:
            return "exam/"
        case .listPostCard:
            return "feed/cards"
        case .post:
            return "feed/post"
        case .subject:
            return "comment/subject"
        case .floors:
            return "comment/floors"
        case .replies:
            return "comment/replies"
        }
    }
}
