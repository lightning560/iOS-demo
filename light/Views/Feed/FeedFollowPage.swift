//
//  FeedFollowPage.swift
//  light
//
//  Created by LiangNing on 2023/07/09.
//

import SwiftUI

struct FeedFollowPage: View {
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(0 ..< 5) { _ in
                        feedFollowRecommentWidget()
                    }
                }
            }
            ForEach(0 ..< 5) { _ in
                feedFollowCardWidget()
            }
        }
    }
}

struct feedFollowRecommentWidget: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("avatar_2").resizable().frame(width: 50, height: 50)
                .clipShape(Circle())
            Text("miona")
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
    }
}

struct feedFollowCardWidget: View {
    var body: some View {
        VStack {
            HStack {
                Image("avatar_3").resizable().frame(width: 50, height: 50)
                    .clipShape(Circle())
                Text("miona")
                Text("yestoday").font(.footnote).foregroundColor(.gray)
                Spacer()
                Image(systemName: "ellipsis")
            }
            Image("image1")
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack {
                Image(systemName: "square.and.arrow.up").font(.system(size: 22))
                Spacer()
                Button {}
                label: {
                        Image(systemName: "heart").font(.system(size: 22))
                        Text("123")
                    }
                Button {}
                label: {
                        Image(systemName: "star").font(.system(size: 22))
                        Text("123")
                    }
                Button {}
                label: {
                        Image(systemName: "ellipsis.bubble").font(.system(size: 22))
                        Text("123")
                    }
            }.foregroundColor(.black)
                .padding(10)
        }.frame(width: SCREEN_WIDTH)
    }
}

struct FeedFollowPage_Previews: PreviewProvider {
    static var previews: some View {
        FeedFollowPage()
    }
}
