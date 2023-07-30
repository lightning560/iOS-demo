//
//  ContentView.swift
//  light
//
//  Created by LiangNing on 2023/06/12.
//

import SwiftUI

struct ContentView: View {
    @StateObject var webVM = WebViewModel()
    @ObservedObject var homeTabBarState = HomeTabBarState()
    func printstate() {
        print(homeTabBarState.homeTabBarShow)
    }

    func tabView() -> some View {
        print("homeTabBarState.homeTabBarShow:")
        print(homeTabBarState.homeTabBarShow)
        if homeTabBarState.homeTabBarShow {
            return AnyView(_tabView())
        } else {
            return AnyView(HStack {}.frame(width: 100, height: 100))
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                _tabView()
            }
        }
    }
}

struct _tabView: View {
    @State private var selection: HomeTabBarEnum = .Home
    var body: some View {
        TabView(selection: $selection) {
            // 0
            FeedMainTabBarView().tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(HomeTabBarEnum.Home)

            // 1
            TTVideoPlayList()

                .tabItem {
                    Label("Video", systemImage: "play.circle")
                }
                .tag(HomeTabBarEnum.Video)
            // 2
            MallMainView()
                .tabItem {
                    Label("Shop", systemImage: "bag")
                }
                .tag(HomeTabBarEnum.Shop)
            // 3
            CollectionPage()
                .tabItem {
                    Label("Messages", systemImage: "message.fill")
                }
                .tag(HomeTabBarEnum.Message)
            // 4
            MeMainPage()
                .tabItem {
                    Label("Me", systemImage: "person.circle.fill")
                }
                .tag(HomeTabBarEnum.Me)
        }
        .toolbar(.automatic, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
