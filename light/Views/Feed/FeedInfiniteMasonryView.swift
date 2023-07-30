//
//  FeedInfiniteMasonryView.swift
//  light
//
//  Created by LiangNing on 2023/06/20.
//

import SwiftUI
import WaterfallGrid

struct FeedInfiniteMasonryView: View {
    @ObservedObject var feedVM = FeedViewModel()

    @State private var MasonryHeight: CGFloat = 0
    @State private var MasonryMinY: CGFloat = 0
    @State private var MasonryMinX: CGFloat = 0

    var body: some View {
        ScrollView {

            FlowLayoutView(
                list: feedVM.postCardsData,
                colums: 2,
                showsIndicators: true,
                spacing: 30
            ) { card in
                FeedMasonryCardView(postCard: card)
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 10)
            .frame(width: SCREEN_WIDTH)

            Text(feedVM.toggleQueryCards.description)

            GeometryReader { proxy -> AnyView in
                let frame = proxy.frame(in: .global)

                DispatchQueue.main.async {
                    MasonryMinY = frame.minY
                    MasonryHeight = proxy.size.height

                    let toggleQueryCards = (SCREEN_HEIGHT - MasonryMinY) > MasonryHeight
                    if feedVM.toggleQueryCards != toggleQueryCards {
                        feedVM.toggleQueryCards = toggleQueryCards
                    }
                }
                return AnyView(
                    Color.clear
                )
            }

        }
        .frame(alignment: .top)
    }
}

struct FeedInfiniteMasonryView_Previews: PreviewProvider {
    static var previews: some View {
        FeedInfiniteMasonryView()
    }
}
