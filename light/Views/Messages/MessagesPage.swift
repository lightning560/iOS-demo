//
//  MessagesPage.swift
//  light
//
//  Created by LiangNing on 2023/07/09.
//

import SwiftUI

struct MessagesPage: View {
    var body: some View {
        NavigationView {
            ScrollView {
                messagesHeader()
                ForEach(0 ..< 5) { _ in
                    messagesListItem()
                }
            }
            .navigationBarTitle(Text("Messages"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: { }) { Image(systemName: "square.and.arrow.up") }.accentColor(.black)
            )
        }
    }
}

private struct messagesHeader: View {
    var body: some View {
        HStack {
            Spacer()
            Button {}
            label: {
                    VStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                            .font(.system(size: 23))
                            .padding(10)
                            .background(.pink.opacity(0.2), in:
                                RoundedRectangle(cornerRadius: 10))
                        Text("a").font(.system(size: 15))
                    }
                }
                .foregroundColor(.black)
            Spacer()
            Button {} label: {
                VStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 23))
                        .padding(10)
                        .background(.blue.opacity(0.2), in:
                            RoundedRectangle(cornerRadius: 10))
                    Text("a")
                }
            }.foregroundColor(.black)

            Spacer()
            Button {} label: {
                VStack {
                    Image(systemName: "ellipsis.bubble.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 23))
                        .padding(10)
                        .background(.green.opacity(0.2), in:
                            RoundedRectangle(cornerRadius: 10))
                    Text("a").font(.system(size: 15))
                }
            }.foregroundColor(.black)

            Spacer()
        }
    }
}

private struct messagesListItem: View {
    var body: some View {
        HStack(alignment: .top) {
            HStack {
                Image("avatar_1")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("miona")
                Text("hello,neuro-safa")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text("09-06")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding()
                Image(systemName: "circle.fill").foregroundColor(.pink)
                    .font(.system(size: 10))
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10))
//                    Spacer()
            }
        }
    }
}

struct MessagesPage_Previews: PreviewProvider {
    static var previews: some View {
        MessagesPage()
    }
}
