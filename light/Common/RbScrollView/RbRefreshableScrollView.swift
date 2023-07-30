//
//  RbRefreshableScrollView.swift
//  light
//
//  Created by LiangNing on 2023/06/19.
//
import Combine
import SwiftUI

public typealias BenRefreshComplete = () -> Void
public typealias BenOnRefresh = (@escaping BenRefreshComplete) -> Void

struct BenRefreshableScrollView<Content: View>: View {
    @StateObject private var refreshVM: BenRefreshableViewModel = BenRefreshableViewModel()

    let content: () -> Content
    let onRefreshHeader: BenOnRefresh
    let onRefreshFooter: BenOnRefresh

    init(@ViewBuilder content: @escaping () -> Content, onRefreshHeader: @escaping BenOnRefresh, onRefreshFooter: @escaping BenOnRefresh) {
        self.content = content
        self.onRefreshHeader = onRefreshHeader
        self.onRefreshFooter = onRefreshFooter
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    // 首先能够获取滚动过程的偏移量
                    // 创建一个ViewModel来管理刷新过程中的ui状态变化
                    GeometryReader { proxy -> AnyView in
                        let minY = proxy.frame(in: .global).minY
                        if refreshVM.normalOffsetY == 0 {
                            refreshVM.normalOffsetY = minY
                        }
                        DispatchQueue.main.async {
                            refreshVM.currOffsetY = minY
                            // 计算出滚动过程中的footerView高度
                            let _refreshFooterCurrHeight = refreshVM.normalOffsetY - minY + refreshVM.scrollHeight - refreshVM.scrollContentHeight

                            // 尽可能缩小refreshVM.refreshFooterCurrHeight需要赋值的时机
                            if _refreshFooterCurrHeight > 0 && refreshVM.state != .refreshFooter {
                                refreshVM.refreshFooterCurrHeight = _refreshFooterCurrHeight
                            }
                            // 当滚动中footerView高度大于设置的footView的高度,并且当前状态是normal,更新状态到pullUp，也就是预备加载状态
                            if _refreshFooterCurrHeight > refreshVM.progressViewHeight && refreshVM.state != .pullUp && refreshVM.state == .normal {
                                withAnimation {
                                    refreshVM.state = .pullUp
                                }
                            }
                            // 当手指离开ScrollView区域,回弹,footerView的高度小于设置的footerView的高度,并且当前状态是预备加载的状态,更新状态到加载中
                            if _refreshFooterCurrHeight < refreshVM.progressViewHeight && refreshVM.state == .pullUp {
                                withAnimation {
                                    print("hello")
                                    refreshVM.state = .refreshFooter
                                }
                            }

                            // 当滚动偏移量超过刷新View的预定高度之后,切换刷新状态为下拉
                            if refreshVM.currOffsetY - refreshVM.normalOffsetY > refreshVM.progressViewHeight && refreshVM.state == .normal {
                                withAnimation(.easeIn) {
                                    refreshVM.state = .pullDown
                                }
                            }
                        }
                        return AnyView(Color.clear)
                    }
                    .frame(height: 0)

                    VStack(spacing: 0) {
                        VStack {
                            Spacer(minLength: 0)

                            if refreshVM.state == .refreshHeader {
                                ProgressView()
                                    .frame(height: refreshVM.progressViewHeight)
                            } else {
                                Image(systemName: "arrow.down")
                                    .frame(height: refreshVM.progressViewHeight)
                                    // 控件180度旋转
                                    .rotationEffect(.init(degrees: refreshVM.state == .normal ? 0 : 180))
                                    .opacity(refreshVM.refreshHeaderCurrHeight == 0 ? 0 : 1)
                            }
                        }
                        // 控制不同状态下刷新view占据的高度空间的
                        .frame(height: refreshVM.refreshHeaderCurrHeight)
                        .clipped()

                        content()
                    }
                    .overlay(
                        // 获取ScrollView的内容高度
                        GeometryReader { proxy -> AnyView in

                            let height = proxy.frame(in: .global).height

                            DispatchQueue.main.async {
                                if refreshVM.scrollContentHeight != height {
                                    refreshVM.scrollContentHeight = height
                                    print(refreshVM.scrollContentHeight)
                                }
                            }

                            return AnyView(Color.clear)
                        }
                    )
                }
                .offset(y: refreshVM.state == .refreshFooter ? -refreshVM.progressViewHeight : 0)

                VStack {
                    if refreshVM.state == .refreshFooter {
                        ProgressView()
                            .frame(height: refreshVM.progressViewHeight)
                    } else {
                        Image(systemName: "arrow.up")
                            .frame(height: refreshVM.progressViewHeight)
                            .rotationEffect(.init(degrees: refreshVM.state == .normal ? 0 : 180))
                            .opacity(refreshVM.refreshFooterCurrHeight == 0 ? 0 : 1)
                    }

                    Spacer(minLength: 0)
                }
                .frame(height: refreshVM.state == .refreshFooter ? refreshVM.progressViewHeight : refreshVM.refreshFooterCurrHeight)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .clipped()
                // 这里比下拉刷新多一个y轴的偏移操作，因为整体会跟随scrollView向上滚动,需要这个步骤抵消偏移量
                .offset(y: refreshVM.state == .refreshFooter ? 0 : refreshVM.refreshFooterCurrHeight)
                // 调整层次，可以放在最上层
                .zIndex(1)
            }
        }
        .overlay(
            // 这里是用来获取整个ScrollView在屏幕中的高度
            GeometryReader { proxy -> AnyView in
                let height = proxy.frame(in: .global).height

                DispatchQueue.main.async {
                    if refreshVM.scrollHeight != height {
                        refreshVM.scrollHeight = height
                    }
                }

                return AnyView(Color.clear)
            }
        )
        .onChange(of: refreshVM.state) { newValue in
            // 监听state的变化，.refreshHeader是执行block
            if newValue == .refreshHeader {
                onRefreshHeader {
                    DispatchQueue.main.async {
                        withAnimation {
                            refreshVM.state = .normal
                        }
                    }
                }
            }
            // 监听状态
            if newValue == .refreshFooter {
                onRefreshFooter {
                    DispatchQueue.main.async {
                        withAnimation {
                            refreshVM.state = .normal
                        }
                    }
                }
            }
        }
    }
}
