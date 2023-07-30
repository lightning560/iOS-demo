//
//  MallGridView.swift
//  light
//
//  Created by LiangNing on 2023/07/01.
//

import Kingfisher
import SwiftUI

struct MallGridView: View {
    private var symbols = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    private var itemLayout = GridItem(.flexible(), spacing: 0, alignment: .center)
    private var gridItemLayout = [GridItem(.flexible(), spacing: 0, alignment: .center), GridItem(.flexible(), spacing: 0, alignment: .center), GridItem(.flexible(), spacing: 0, alignment: .center), GridItem(.flexible(), spacing: 0, alignment: .center), GridItem(.flexible(), spacing: 0, alignment: .center)]

    var body: some View {
        LazyVGrid(columns: gridItemLayout, spacing: 0) {
            ForEach(0 ... 9, id: \.self) { _ in
                _mallGridCellView()
            }
        }
    }
}

private struct _mallGridCellView: View {
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    var body: some View {
        VStack {
            KFImage(URL(string: "https://sns-img-hw.xhscdn.com/0b559604-7782-4f2b-983e-2a7717d61035?imageView2/2/w/648/format/webp")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .clipped()
//                .layoutPriority(97)
            Text("abccdef")
        }.frame(width: self.screenWidth / 5, height: 70)
    }
}

struct MallGridView_Previews: PreviewProvider {
    static var previews: some View {
        MallGridView()
        _mallGridCellView()
    }
}
