//
//  CommentWrapperView.swift
//  light
//
//  Created by LiangNing on 2023/06/17.
//

import Kingfisher
import SwiftUI

struct PostCommentView: View {
    @EnvironmentObject var commentVM: CommentViewModel

    var subjectId: String

    func createdTimeFromTimeStamp(ts: Int) -> String {
        let date = Date.getDateWith(timeStamp: ts)
        let time = Date.getTime(date)
        return time().0 + "-" + time().1 + "-" + time().2 + " " + time().3 + ":" + time().4
    }

    var body: some View {
        if subjectId == "" {
            Text("no subject error")
        } else {
            LazyVStack {
                PostCommentHeaderView(subjectId: subjectId)
                    .environmentObject(commentVM)

                ForEach(commentVM.floorsDictData.sorted(by: { ($0.1.rootReply?.floorAttr?.replyCount)! > ($1.1.rootReply?.floorAttr?.replyCount)! }), id: \.key) { _, floor in
                    PostCommentFloorView(rootReply: floor.rootReply!)
                        .environmentObject(commentVM)
//                    ForEach(floor,id:\.self){reply in
//                        PostCommentReplyView(reply: reply)
//                    }
                }

                PostCommentFloorCounterView(subjectId: "1", floorId: "2", repliesCount: 99)
            }
            .onAppear {
                Task {
                    await commentVM.listFloorBySubject(subjectId: subjectId)
                }
            }
            //        .frame(width: 0)
        }
    }
}

private struct PostCommentHeaderView: View {
    @EnvironmentObject var commentVM: CommentViewModel
    var subjectId: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if commentVM.subjectData == nil {
                Text("subjectData wait")
                Text((commentVM.subjectData == nil).description)
            } else {
                Text(String((commentVM.subjectData?.replyCount)!) + "comments")
                    .font(.footnote)
            }

            HStack {
                Image("image1")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 1))
                    .shadow(radius: 1)

                Button(action: { }) {
                    Text("tell something")
                        .foregroundColor(.gray)
                        .padding()
                }
                .frame(width: UIScreen.main.bounds.width - 70, height: 40, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 100.0).foregroundColor(.gray).opacity(0.15))
            }
        }
        .onAppear {
            Task {
                await commentVM.getSubjectById(id: subjectId)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
    }
}

private struct PostCommentFloorView: View {
//    @EnvironmentObject var commentVM: CommentViewModel
    var rootReply: ReplyModel
    func createdTimeFromTimeStamp(ts: Int) -> String {
        let date = Date.getDateWith(timeStamp: ts)
        let time = Date.getTime(date)
        return time().0 + "-" + time().1 + "-" + time().2 + " " + time().3 + ":" + time().4
    }

    var body: some View {
        HStack {

            KFImage(URL(string: rootReply.userInfo!.avatar.url))
                .resizable()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
                .overlay(Circle().stroke(.white, lineWidth: 1))
                .shadow(radius: 0)

            VStack(alignment: .leading) {
                HStack {
                    Text(rootReply.userInfo!.name)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    Text(createdTimeFromTimeStamp(ts: rootReply.createdAt!))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Text(rootReply.content!)
                    .font(.caption)
                    .foregroundColor(.black)
            }
            Spacer()
            VStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text("46k")
                    .font(.footnote)
            }
        }

        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
        PostCommentRepliesView(floorId: rootReply.id!)
    }
}

private struct PostCommentRepliesView: View {
    @EnvironmentObject var commentVM: CommentViewModel

    var floorId: String
    var body: some View {
        if commentVM.floorsDictData.isEmpty {
            Text("floorsDictData nil")
        } else if commentVM.floorsDictData[floorId] == nil {
            Text("floorsDictData[floorId] nil")
        } else if commentVM.floorsDictData[floorId]!.replies!.isEmpty {
            Text("replies is []")
        } else {
            ForEach(commentVM.floorsDictData[floorId]!.replies!, id: \.id) { reply in
                PostCommentReplyView(reply: reply)
            }
        }
    }
}

private struct PostCommentReplyView: View {
    var reply: ReplyModel
    var body: some View {
        HStack {
            Image("image1")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(.white, lineWidth: 1))
                .shadow(radius: 0)

            VStack(alignment: .leading) {
                HStack {
                    Text("NAME")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("yestoday 23:59")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Text("good!")
                    .font(.caption)
                    .foregroundColor(.black)
            }
            Spacer()
            VStack {
                Image(systemName: "heart")
                Text("46k")
                    .font(.footnote)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 5))
    }
}

private struct PostCommentFloorCounterView: View {
    @EnvironmentObject var commentVM: CommentViewModel
    var subjectId: String
    var floorId: String
    var repliesCount: Int
    var body: some View {
        HStack {
            Spacer().frame(width: 50)
            Text("View 999 replies").font(.footnote)
            Spacer()
        }
    }
}

struct PostCommentViewDemo: View {
    var body: some View {
        LazyVStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("894 comments")
                    .font(.footnote)

                HStack {
                    Image("image1")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white, lineWidth: 1))
                        .shadow(radius: 1)

                    Button(action: { }) {
                        Text("tell something")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width - 70, height: 40, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 100.0).foregroundColor(.gray).opacity(0.15))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))

            HStack {
                Image("image2")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 1))
                    .shadow(radius: 0)

                VStack(alignment: .leading) {
                    HStack {
                        Text("NAME")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        Text("yestoday 23:59")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    Text("good!")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                Spacer()
                VStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("46k")
                        .font(.footnote)
                }
            }
            //        .frame(width: .infinity)
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))

            HStack {
                Image("image1")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 1))
                    .shadow(radius: 0)

                VStack(alignment: .leading) {
                    HStack {
                        Text("NAME")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("yestoday 23:59")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    Text("good!")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                Spacer()
                VStack {
                    Image(systemName: "heart")
                    Text("46k")
                        .font(.footnote)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 5))

            HStack {
                Spacer().frame(width: 50)
                Text("View 999 replies").font(.footnote)
                Spacer()
            }
        }
    }
}

struct PostCommentView_Previews: PreviewProvider {
    static var previews: some View {
        PostCommentView(subjectId: "1")
        PostCommentViewDemo()
        PostCommentHeaderView(subjectId: "1")
    }
}
