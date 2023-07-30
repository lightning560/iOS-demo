//
//  RbRefreshableViewModel.swift
//  light
//
//  Created by LiangNing on 2023/06/19.
//

import SwiftUI
import Combine

enum BenRefreshState {
    case normal
    // 下拉刷新的预备状态
    case pullDown
    // 上拉加载的预备状态
    case pullUp
    // 下拉刷新一步请求中状态
    case refreshHeader
    // 上拉刷新一步请求中状态
    case refreshFooter
}

class BenRefreshableViewModel: ObservableObject {
    //定义现实刷新状态的view的高度
    let progressViewHeight: CGFloat = 50
    // 记录scrollview的初始的y轴坐标
    var normalOffsetY: CGFloat = 0
    //记录scrollView在屏幕中的高度
    var scrollHeight: CGFloat = 0
    // 记录ScrollView的内容高度,通过2个数据结合才能计算出上拉加载的准确时机
    var scrollContentHeight: CGFloat = 0
    
    // 记录上拉加载更多的View的当前高度
    @Published var refreshFooterCurrHeight: CGFloat = 0
    @Published var showRefreshFooter: Bool = false
    // 记录下拉刷新的View的当前高度
    @Published var refreshHeaderCurrHeight: CGFloat = 0
    //记录scrollview滚动过程中的当前y轴坐标
    @Published var currOffsetY: CGFloat = 0
    @Published var state: BenRefreshState = .normal
    
    // 通过合并currOffsetY和state最后的通知,来确定时候进行刷新
    private var canRefreshPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($currOffsetY, $state)
            .map { currOffsetY, state -> Bool in
                if currOffsetY - self.normalOffsetY <= self.progressViewHeight && state == .pullDown {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    // 更新刷新状态view的高度,刷新状态view的高度根据scrollView的偏移量以及刷新状态来确定
    private var updatePorgressViewHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.CombineLatest($currOffsetY, $state)
            .map { currOffsetY, state -> CGFloat in
                //首先获取偏移量
                var _progressViewHeight: CGFloat = currOffsetY - self.normalOffsetY
                //判断当前是否已经在刷新请求耗时操作的状态下，如果在此状态，则固定高度progressViewHeight
                if state == .refreshHeader {
                    if _progressViewHeight < self.progressViewHeight {
                        _progressViewHeight = self.progressViewHeight
                    }
                }
                //如果偏移量小于0，说明向上滚动，此时要把刷新状态的view高度固定为0，如果小于0，xcode会报错
                if _progressViewHeight < 0 {
                    _progressViewHeight = 0
                }
                return _progressViewHeight
            }
            .eraseToAnyPublisher()
    }
    
    private var cancellable: Set<AnyCancellable> = []
    
    
    init() {
        
        canRefreshPublisher
            .dropFirst()
            .removeDuplicates()
            .sink { canRefresh in
                
                if canRefresh {
                    self.state = .refreshHeader
                    
                }
            }
            .store(in: &cancellable)
        
        updatePorgressViewHeightPublisher
            .dropFirst()
            .removeDuplicates()
            .sink { height in
                DispatchQueue.main.async {
                    if self.state == .pullDown {
                        self.refreshHeaderCurrHeight = height
                    } else {
                        withAnimation {
                            self.refreshHeaderCurrHeight = height
                        }
                    }
                }
            }
            .store(in: &cancellable)
    }
   
}

