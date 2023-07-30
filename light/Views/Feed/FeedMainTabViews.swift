//
//  MasonryWrapperView.swift
//  light
//
//  Created by LiangNing on 2023/06/14.
//

import SwiftUI

struct FeedMainTabViews: View {
    @Binding var selection: Int

    var body: some View {
        TabView(selection: $selection) {
            //                ForEach(0..<3){
            FeedMasonryView()
                .tag(0)
            FeedInfiniteMasonryView()
                .tag(1)
            FeedMasonryView()
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.spring(), value: selection)
        .onChange(of: selection, perform: { value in
            print(value)
        })
    }
}

struct FeedMainTabViews_Previews: PreviewProvider {
    @State static var currentSelectedCategory: Int = 0
    static var previews: some View {
        FeedMainTabViews(selection: $currentSelectedCategory)
    }
}
