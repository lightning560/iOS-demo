//
//  FeedViewModel.swift
//  light
//
//  Created by LiangNing on 2023/06/18.
//

import Combine
import Foundation
import SwiftUI
import UIKit

@MainActor
class FeedViewModel: ObservableObject, FeedRequest {
    @Published var xcount: Int = 9
    @Published var scrollEnable: Bool = true

    @Published var toggleQueryCards: Bool = false
    @Published var postId: String = ""

    // MARK: - network

    var offset: Int = 0
    var limit: Int = 8
    var by: String = "like"
    var order: String = "desc"
    
    var postCardsWrap: PostCardsModelWrap?
    @Published var postCardsData: [PostCardModel] = []

    var isOdd: Bool = true
    @Published var postCardsDataOdd: [PostCardModel] = []
    @Published var postCardsDataEven: [PostCardModel] = []

    var postWrap: PostModelWrap?
    @Published var postData: PostModel? = nil
    /// 异步获取顶级商品分类

    func listPostCard() async {
        do {
            postCardsWrap = try await fetchListPostCard(offset: offset, limit: limit, by: "like", order: "order")
            offset = limit
            postCardsData = postCardsData + (postCardsWrap?.postCards)!
            print(postCardsData.count)
            for c in postCardsWrap!.postCards {
                if isOdd {
                    postCardsDataOdd.append(c)
                } else {
                    postCardsDataEven.append(c)
                }
                isOdd = !isOdd
            }

        } catch {
            Dlog(error)
        }
    }

    func getPostById(id: String) async {
        do {
            postWrap = try await fetchPostById(id: id)
            postData = postWrap?.post
        } catch {
            Dlog(error)
        }
    }

    // MARK: - Publish

    private var cancelable: Set<AnyCancellable> = []

    private var toggleQueryCardsPublisher: AnyPublisher<Bool, Never> {
        $toggleQueryCards
            .print("toggleQueryCardsPublisher:")
            // 每两秒触发一次
            .debounce(for: 1, scheduler: RunLoop.main)
            // 过滤掉前后发出的值相同的通知
            // 连续多次点击，可能会出现模拟器中现在的情况，弹窗无法消失,注释掉过滤相同值通知的方法
//            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    init() {
        toggleQueryCardsPublisher
            .sink { toggle in
                print("toggleQueryCardsPublisher.sink:", toggle.description)
                if toggle {
                    self.xcount = self.xcount + 9
                    Task {
                        await self.listPostCard()
                    }
                }
            }
            .store(in: &cancelable)
    }
}
