//
//  MasonryView.swift
//  light
//
//  Created by LiangNing on 2023/06/14.
//

import SwiftUI
import WaterfallGrid

struct FeedMasonryView: View {

    @ObservedObject var feedVM = FeedViewModel()
    var body: some View {
        ScrollViewReader { _ in
            ScrollView(.vertical, showsIndicators: false) {
                WaterfallGrid(feedVM.postCardsData) { card in
                    FeedMasonryCardView(postCard: card)
                }
                .gridStyle(
                    columnsInPortrait: 2,
                    columnsInLandscape: 3,
                    spacing: 8,
                    animation: .easeInOut(duration: 0.2)
                )
                .padding(5)
            }
        }
        .task {
            await feedVM.listPostCard()
        }
    }
}

struct FeedMasonryViewTwo: View {
    var body: some View {
        Text("MasonryViewTwo")
    }
}

struct FeedMasonryView_Previews: PreviewProvider {
    static var previews: some View {
        FeedMasonryView()
    }
}
