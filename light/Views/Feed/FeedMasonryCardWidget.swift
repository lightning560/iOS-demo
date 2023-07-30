//
//  FeedMasonryCellView.swift
//  light
//
//  Created by LiangNing on 2023/07/02.
//

import Kingfisher
import SwiftUI

struct FeedMasonryCardView: View {
    var postCard: PostCardModel
    @State private var isPresenting = false
    func didDismiss() {
        // Handle the dismissing action.
    }

    var body: some View {
        VStack(spacing: 1) {
            KFImage(URL(string: postCard.cover.url)!)
//                KFImage(URL(string: "https://www.gif.cn/Upload/newsucai/2022-09-01/1204.gif")!
//                )
                .resizable()
                .scaledToFit()
                .frame(width: 175, alignment: .center)
                .onTapGesture {
                    isPresenting.toggle()
                }
                .fullScreenCover(isPresented: $isPresenting,
                                 onDismiss: didDismiss) {
                    HStack {
                        Button(action: {
                            isPresenting.toggle()
                        }, label: { Image(systemName: "chevron.backward") })
                            .frame(width: 60)
                        Spacer()
                        Image(systemName: "face.smiling.fill")
                        Spacer()
                        Text("nogiza46")
                    }
                    .padding(.horizontal, 0)
                    ImagePostView(isPresenting: $isPresenting,
                                  postId: "1654113146228441088")
                }
            Text(postCard.title)
                .lineLimit(2)
                .frame(width: 170, height: 35, alignment: .leading)
                .font(.system(size: 14))
            HStack(spacing: 0) {

                KFImage(URL(string: postCard.authorInfo.avatar.url)!)
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                Text(postCard.authorInfo.name)
                    .font(.system(size: 12, weight: .light, design: .default))
                    .foregroundColor(.gray)
                    .frame(width: 80)
                    .lineLimit(1)
                Label("", systemImage: "heart")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.red)

                Text(String(postCard.likeCount))
                    .font(.system(size: 13, weight: .light, design: .default))
            }
        }
//            .frame(height: 300)
        .cornerRadius(5.0)
    }
}

struct FeedMasonryCardView_Previews: PreviewProvider {
    static var previews: some View {
        FeedMasonryCardView(postCard: PostCardModel(
            id: " 1",
            uid: 101,
            type: "image",
            title: "title123",
            cover: ImageModel(
                id: 1,
                url: "https://sns-img-qc.xhscdn.com/447f398a-6461-1a2a-b50f-69bc4e676f97?imageView2/2/w/648/format/webp",
                hash: "aasdf",
                name: "alt",
                sizeKB: 50,
                width: 50,
                height: 80),
            likeCount: 99,
            tags: [TagModel(tagID: 1, name: "abc", bizType: "feed")],
            state: 1,
            authorInfo: UserInfoModel(
                id: 101,
                uid: 101,
                name: "myname",
                sex: 1,
                avatar: ImageModel(
                    id: 1,
                    url: "https://sns-img-qc.xhscdn.com/b579f455-7ce4-9fe0-60ad-e5418389eab7?imageView2/2/w/648/format/webp",
                    hash: "aasdf",
                    name: "alt",
                    sizeKB: 50,
                    width: 50,
                    height: 80),
                sign: "sign",
                state: 1,
                level: 6)
        )
        )
    }
}
