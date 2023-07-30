//
//  MainView.swift
//  light
//
//  Created by LiangNing on 2023/06/14.
//

import SwiftUI

struct FeedMainTabBarView: View {
    @State private var currentSelectedCategory: Int = 0
    private var categoryNavigateList = ["one", "two", "three", "four"]

    var body: some View {
        NavigationView {
            VStack {
                _feedMainTabBarView(currentSelectedCategory: $currentSelectedCategory)
                FeedMainTabViews(selection: $currentSelectedCategory)
            }.padding()
                .navigationBarTitle("首页", displayMode: .inline)
                .navigationBarItems(
                    leading: Image(systemName: "square.fill"),
                    trailing: Button(action: {}) {
                        Label("Add Folder", systemImage: "magnifyingglass").labelStyle(.iconOnly)
                            .foregroundColor(.black)
                    }
                )
        }
    }
}

struct _feedMainTabBarView: View {
    @Binding var currentSelectedCategory: Int
    var body: some View {
        // TODO: 给每个buttom绑定namespace.id,每次currentSelectedCategory的 onchange就会触发滚动。应对navigate超出屏幕。
        ScrollViewReader { _ in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button(action: {
                        currentSelectedCategory = 0
                    }) {
                        currentSelectedCategory == 0 ?
                            Text("one")
                            .underline()
                            .foregroundColor(.black)
                            .bold() :
                            Text("one")
                            .foregroundColor(.gray)
                            .bold()
                    }
                    Button(action: {
                        currentSelectedCategory = 1
                    }) {
                        currentSelectedCategory == 1 ?
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
    }
}

struct FeedMainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        FeedMainTabBarView()
    }
}
