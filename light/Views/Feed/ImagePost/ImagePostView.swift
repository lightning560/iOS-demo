//
//  ImagePostView.swift
//  light
//
//  Created by LiangNing on 2023/06/17.
//

import Kingfisher
import SwiftUI

struct ImagePostView: View {
    @StateObject var commentVM = CommentViewModel()

    @ObservedObject var homeTabBarState = HomeTabBarState()
    @ObservedObject var feedVM = FeedViewModel()

    @State private var selectedImage: Int = 0
    @State var replyFocused: Bool = false

    @Binding var isPresenting: Bool

    var postId: String
    @State private var tagNum: Int = 2

    func createdTimeFromTimeStamp(ts: Int) -> String {
        let date = Date.getDateWith(timeStamp: ts)
        let time = Date.getTime(date)
        return time().0 + "-" + time().1 + "-" + time().2 + " " + time().3 + ":" + time().4
    }

    var body: some View {

        ZStack(alignment: .bottomLeading) {
            if postId != feedVM.postData?.id {
                Text("await")
            } else {
                ScrollView(.vertical) {
                    TabView(selection: $selectedImage) {
                        //                ForEach(0..<3){
                        Image("image1")
                            //                        .frame(width:UIScreen.main.bounds.width, height: 340, alignment: .center)
                            .resizable()
                            //                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                            //                        .aspectRatio(1/1,contentMode: .fit)
                            .tag(0)

                        Image("image2")
                            .resizable()
                            .tag(1)
                        ForEach((feedVM.postData?.images)!) { img in
                            KFImage(URL(string: img.url))
                                .resizable()
                                .scaledToFill()
//                                .aspectRatio(1/1,contentMode: .fit)
//                                .scaledToFit()
                                .frame(width: SCREEN_WIDTH)
                                .tag(img.id)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 400)
                    //                .foregroundColor(.red)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .animation(.spring(), value: selectedImage)
                    .onChange(of: selectedImage, perform: { _ in
//                        print(value)
                    }
                    )

/// MARK: ArticleView

                    VStack {
                        Text((feedVM.postData?.title)!)
                            .font(.body)
                            .bold()
                            //            .multilineTextAlignment(.leading)
                            .frame(width: UIScreen.main.bounds.width - 30, alignment: .leading)
                            .lineLimit(2)
                        Text((feedVM.postData?.content)!)
                            .frame(width: UIScreen.main.bounds.width - 30, alignment: .leading)
                            .font(.footnote)
                        HStack {
                            Text(createdTimeFromTimeStamp(ts: (feedVM.postData?.createdAt)!))
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Dislike")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                    }
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))

                    PostCommentView(subjectId: (feedVM.postData?.commentID)!)
                        .environmentObject(commentVM)

                    HStack {}.frame(height: 60)
                }
            }


            if replyFocused {
                _imagePostMaskView(replyFocused: $replyFocused)
                _replyEditorView(replyFocused: $replyFocused)
            } else {
                _imagePostBottomBarView(replyFocused: $replyFocused)
            }
        }
        .onAppear {
            Task {
                await feedVM.getPostById(id: postId)
            }
        }
        .onDisappear {
            self.tagNum = 2
        }
        .frame(
            width: UIScreen.main.bounds.width
        )
    }
}

private struct _imagePostArticleView: View {
    var body: some View {
        VStack {
            Text("h1h1h1h1h1h1h1")
                .font(.body)
                .bold()
//            .multilineTextAlignment(.leading)
                .frame(width: UIScreen.main.bounds.width - 30, alignment: .leading)
                .lineLimit(2)
            Text("在之前的代码中我们已经可以用onTapGesture和onLongPressGesture来分别响应NavigationLink的交互了，但是也发现了一个问题。NavigationLink最重要的跳转问题，我们还没有解决啊。下面要介绍的一个重要参数隆重登场：isActive，它是NavigationLink构造函数的一个参数，默认值为.constant(true)，先让我们看看它的正确使用方法")
                .frame(width: UIScreen.main.bounds.width - 30, alignment: .leading)
                .font(.footnote)
            HStack {
                Text("2022-02-02")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
                Text("Dislike")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
        }
        .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
    }
}

// MARK: 蒙层

private struct _imagePostMaskView: View {
    @Binding var replyFocused: Bool

    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(.black)
        .edgesIgnoringSafeArea(.all)
        .opacity(0.1)
        .onTapGesture {
            self.replyFocused = false
        }
    }
}

// MARK: ReplyEditor

private struct _replyEditorView: View {
    enum FocusedField: Hashable {
        case reply
    }

    @State var input = ""
    @Binding var replyFocused: Bool
    @FocusState var focused: FocusedField?
    var body: some View {
        HStack {
            TextField("replyEditor:", text: $input, onEditingChanged: getFocus)
                .focused($focused, equals: .reply)
            Text("submit")
        }.background(Color.white)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focused = .reply
                }
            }
    }

    func getFocus(focused: Bool) {
        print("get focus:\(focused ? "true" : "false")")
        print("isFocused:\(focused)")
        replyFocused = focused
    }
}

private struct _imagePostBottomBarView: View {
    @Binding var replyFocused: Bool
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle().fill().foregroundColor(.white)
            HStack {
                Button(action: {
                    self.replyFocused = !replyFocused
                }) {
                    Text("tell something")
                        .foregroundColor(.gray)
                        .padding()
                }
                .frame(width: UIScreen.main.bounds.width - 250, height: 40, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 100.0).foregroundColor(.gray).opacity(0.15))
                Image(systemName: "message").font(.title)
                Image(systemName: "waveform.circle").font(.title)
                Image(systemName: "face.smiling").font(.title)
                Image(systemName: "plus.circle").font(.title)
            }.padding()
        }.frame(height: 50)
    }
}

struct ImagePostView_Previews: PreviewProvider {
//    @State static var selection:Int = 0
    @State static var isPresenting: Bool = true
    static var post = PostModel(
        id: "1",
        uid: 101,
        title: "title 123",
        content: "xzcvzxcvxv",
        createdAt: 9999999,
        updatedAt: 9999999,
        cover: ImageModel(
            id: 1,
            url: "https://sns-img-qc.xhscdn.com/447f398a-6461-1a2a-b50f-69bc4e676f97?imageView2/2/w/648/format/webp",
            hash: "aasdf",
            name: "alt",
            sizeKB: 50,
            width: 50,
            height: 80),
        type: "image",
        video: VideoModel(id: 1,
                          url: "https://assets.mixkit.co/videos/preview/mixkit-rotating-bowl-with-fruit-on-a-white-background-10424-large.mp4",
                          type: "mp4",
                          cover: ImageModel(
                              id: 1,
                              url: "https://sns-img-qc.xhscdn.com/447f398a-6461-1a2a-b50f-69bc4e676f97?imageView2/2/w/648/format/webp",
                              hash: "aasdf",
                              name: "alt",
                              sizeKB: 50,
                              width: 50,
                              height: 80)
                          , hash: "asdfcxzvzvczc",
                          name: "asdf", sizeKB: 123, width: 100, height: 200, length: 60, createdAt: 12341234),
        state: 1,
        likeCount: 99,
        shareCount: 98,
        favorCount: 11
    )

    static var previews: some View {
        ImagePostView(isPresenting: $isPresenting, postId: "1654113146228441088")
        _imagePostArticleView()
    }
}
