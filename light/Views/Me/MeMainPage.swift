//
//  MeMainView.swift
//  light
//
//  Created by LiangNing on 2023/07/05.
//

import Foundation
import Kingfisher
import SwiftUI
import WaterfallGrid

struct MeMainPage: View {
    private var cards = [
        Card(id: UUID().uuidString, image: "https://sns-img-hw.xhscdn.com/c431e03e-5297-d994-14c9-f2d943794c4e?imageView2/2/w/648/format/webp", title: "1", subtitle: "a"),
        Card(id: UUID().uuidString, image: "https://dummyimage.com/150x300/000/fff", title: "2", subtitle: "s"),
        Card(id: UUID().uuidString, image: "https://sns-img-bd.xhscdn.com/f8c5839c-c114-0d3f-a36f-779d9d1ab06a?imageView2/2/w/648/format/webp", title: "3", subtitle: "b"),
    ]

    @State var menuWidth = UIScreen.main.bounds.width - 205
    @State var offsetX = -UIScreen.main.bounds.width + 200
    // 顶部导航入口
    private var moreBtnView: some View {
        Button(action: {
            withAnimation {
                offsetX = 0
            }
        }) {
            Image(systemName: "list.bullet")
                .foregroundColor(.black)
        }
    }

    @State var cur: Int = 0
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    CreatorHeaderView()
                    CreatorTabBarView(currentTabSelected: $cur)
                    WaterfallGrid(cards) { card in
                        cardView(card: card)
                    }
                    .gridStyle(
                        columnsInPortrait: 2,
                        columnsInLandscape: 3,
                        spacing: 8,
                        animation: .easeInOut(duration: 0.2)
                    )
                    //            .scrollOptions(direction: .horizontal)
//                    .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                }
//                .padding()
                .navigationBarTitle("首页", displayMode: .inline)
                .navigationBarItems(leading: moreBtnView)
            }
            MeDrawerMenu(menuWidth: $menuWidth, offsetX: $offsetX)
        }
    }
}

private struct cardView: View {
    let card: Card

    var body: some View {
        VStack {
            KFImage(URL(string: card.image)!)
                //            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .layoutPriority(97)
            HStack {
                VStack(alignment: .leading) {
                    Text(card.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(98)
                    Text(card.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(99)
                }
                //                Spacer()
            }
            .padding([.leading, .trailing, .bottom], 8)
        }
        .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
}

struct MeMainPage_Previews: PreviewProvider {
    static var previews: some View {
        MeMainPage()
    }
}
