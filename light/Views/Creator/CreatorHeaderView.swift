//
//  CreatorView.swift
//  light
//
//  Created by LiangNing on 2023/06/19.
//

import Kingfisher
import Logging
import SwiftUI

struct CreatorHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 4) {
                KFImage(URL(string: "https://dummyimage.com/100x100")!)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 1))
                    .shadow(radius: 0)
                VStack(alignment: .leading) {
                    HStack {
                        Text("band name")
                            .font(.body)
                            .bold()
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                    }
                    HStack {
                        Text("band name")
                            .font(.caption)
                        Text("ID: 12345678")
                            .font(.caption)
                    }
                }
            }
            Text("时间的朋友👬").font(.footnote)
            HStack {
                VStack(alignment: .center, spacing: 2) {
                    Text("30")
                        .font(.subheadline)
                    Text("Following")
                        .font(.caption2)
                }
                VStack(alignment: .center, spacing: 2) {
                    Text("894k")
                        .font(.subheadline)
                    Text("Followers")
                        .font(.caption2)
                }
                VStack(alignment: .center, spacing: 2) {
                    Text("4.6M")
                        .font(.subheadline)
                    Text("Likes&Col")
                        .font(.caption2)
                }
                Button("Follow", action: {
                    Dlog("i'm Dlog in CreatorHeaderView Follow buttom")

                    // 2) we need to create a logger, the label works similarly to a DispatchQueue label
                    let logger = Logger(label: "com.example.BestExampleApp.main")

                    // 3) we're now ready to use it
                    logger.info("\(#function)Hello World!")
                })
                .font(.footnote)
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 20.0).foregroundColor(.red).opacity(1))
                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                        .font(.body)
                        .overlay(Text("···").font(.caption2))
                }
                .font(.subheadline)
                .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 20.0).foregroundColor(.red).opacity(0.01))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1)
                )
            }
            Button(action: {}) {
                HStack {
                    Image(systemName: "bag")
                    Text("shop")
                }
            }
            .frame(width: UIScreen.main.bounds.width - 60, height: 30, alignment: .center)
            .font(.subheadline)
            .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 20.0).foregroundColor(.white).opacity(0.2))
        }
        .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.gray.opacity(0.9))
    }
}

struct CreatorHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorHeaderView()
    }
}
