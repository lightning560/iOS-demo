//
//  MallCellView.swift
//  light
//
//  Created by LiangNing on 2023/07/01.
//

import Kingfisher
import SwiftUI

struct MallCardView: View {
    var body: some View {
        VStack(spacing: 2) {
            KFImage(URL(string: "https://dummyimage.com/180x320")!)
                .resizable()
                .frame(width: 180, height: 240, alignment: .center)
            Text("LazyVGrid填充的顺序是从上方一行一行填充的")
                .lineLimit(2)
                .frame(width: 170, height: 35, alignment: .leading)
                .font(.system(size: 14))
            HStack(spacing: 2) {
                AsyncImage(url: URL(string: "https://dummyimage.com/30"))
                    .frame(width: 30, height: 30, alignment: .center)
                Text("hori miona nogizaka46")
                    .font(.system(size: 12, weight: .light, design: .default))
                    .foregroundColor(.gray)
                    .frame(width: 80)
                    .lineLimit(1)
                Label("69.2k", systemImage: "heart")
                    .labelStyle(.iconOnly)
                Text("46.1k")
                    .font(.system(size: 13, weight: .light, design: .default))
            }
        }
        .frame(height: 300)
        .cornerRadius(5.0)
    }
}

struct MallCardView_Previews: PreviewProvider {
    static var previews: some View {
        MallCardView()
    }
}
