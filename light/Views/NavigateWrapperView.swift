//
//  NavigateWrapperView.swift
//  light
//
//  Created by LiangNing on 2023/06/12.
//

import SwiftUI

// out
struct NavigateWrapperView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 1){
            Button(action: {}) {
                Label("Add", systemImage: "seal").labelStyle(.iconOnly)
                    .foregroundColor(.black)
            }
            .frame(alignment: .leading)
            Spacer()
            HStack{
                Text("a")
                Text("b")
                Text("c")
            }
            .frame(alignment:.center)
            Spacer()
            Button(action: {}) {
                Label("Add", systemImage: "magnifyingglass").labelStyle(.iconOnly)
                    .foregroundColor(.black)
            }
            .frame(alignment: .trailing)
        }
//        .frame(width:300)
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct NavigateWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        NavigateWrapperView()
    }
}
