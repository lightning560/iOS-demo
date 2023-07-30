//
//  TagView.swift
//  light
//
//  Created by LiangNing on 2023/06/19.
//

import SwiftUI

struct CreatorTabBarView: View {
    
    @Binding  var currentTabSelected: Int
    var body:some View{
        HStack {
            Button(action: {
                currentTabSelected = 0
            }) {
                currentTabSelected == 0 ?
                    Text("one")
                    .underline()
                    .foregroundColor(.black)
                    .bold() :
                    Text("one")
                    .foregroundColor(.gray)
                    .bold()
            }
            Button(action: {
                currentTabSelected = 1
            }) {
                currentTabSelected == 1 ?
                    Text("two")
                    .underline()
                    .foregroundColor(.black)
                    .bold()
                    :
                    Text("two")
                    .foregroundColor(.gray)
                    .bold()
            }
        }
        .buttonStyle(.bordered)
    }
}




struct CreatorTabBarView_Previews: PreviewProvider {
    @State static var currentSelected: Int = 0
    static var previews: some View {
        CreatorTabBarView(currentTabSelected:$currentSelected)
//        _creatorTabViews(currentSelected: $currentSelected)
    }
}
