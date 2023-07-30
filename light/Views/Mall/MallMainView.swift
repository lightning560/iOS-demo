//
//  MallMainView.swift
//  light
//
//  Created by LiangNing on 2023/07/01.
//

import Kingfisher
import SwiftUI
import WaterfallGrid

struct MallMainView: View {
    private var cards = [
        Card(id: UUID().uuidString, image: "https://sns-img-hw.xhscdn.com/c431e03e-5297-d994-14c9-f2d943794c4e?imageView2/2/w/648/format/webp", title: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque praesentium cumque iure dicta incidunt est ipsam, officia dolor fugit natus", subtitle: "$648"),
        Card(id: UUID().uuidString, image: "https://sns-img-hw.xhscdn.com/275484c1-fdf1-1b2d-50d2-533a2700668d?imageView2/2/w/648/format/webp", title: "", subtitle: ""),
        Card(id: UUID().uuidString, image: "https://dummyimage.com/150x300/000/fff", title: "2223", subtitle: "s11"),
        Card(id: UUID().uuidString, image: "https://sns-img-bd.xhscdn.com/f8c5839c-c114-0d3f-a36f-779d9d1ab06a?imageView2/2/w/648/format/webp", title: "32323", subtitle: "b111"),
    ]

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                ScrollViewReader { _ in
                    ScrollView(.vertical, showsIndicators: true) {
                        MallBannerView()
                        MallGridView()
                        WaterfallGrid(cards) { card in
                            NavigationLink {
                                CollectionPage()
                            } label: {
                                collectionCardView(card: card)
                            }
                        }
                        .gridStyle(
                            columnsInPortrait: 2,
                            columnsInLandscape: 3,
                            spacing: 8,
                            animation: .easeInOut(duration: 0.2)
                        )
                    }
                }
            }.padding()
//                .toolbar(.hidden, for: .tabBar)
//                .toolbar(.hidden, for: .navigationBar)
                .navigationBarTitle("mall", displayMode: .inline)
        }
    }
}

private struct collectionCardView: View {
    let card: Card

    var body: some View {
        VStack {
            KFImage(URL(string: card.image)!)
                //            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()

            VStack(alignment: .leading) {
                Text(card.title)
                    .frame(maxWidth: .infinity)
                    .lineLimit(2)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.bottom, 5)
                    .fixedSize(horizontal: false, vertical: true)
                    .border(Color.red)

                Text(card.subtitle)
                    .font(.caption)
//                        .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            //                Spacer()
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing, .bottom], 8)
        }
        .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
}

struct MallMainView_Previews: PreviewProvider {
    static var previews: some View {
        MallMainView()
    }
}
