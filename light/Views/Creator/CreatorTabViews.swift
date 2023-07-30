//
//  CreatorTabViewss.swift
//  light
//
//  Created by LiangNing on 2023/07/02.
//

import SwiftUI

struct CreatorTabViews: View {
    @Binding var currentTabSelected: Int
    @State var frame: CGRect = .zero

    func makeView(_ geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async { self.frame = geometry.frame(in: .global) }
        return CreatorTabView(currentTabSelected: $currentTabSelected)
    }

    var body: some View {
        GeometryReader { geometry in
            self.makeView(geometry)
        }
    }
}

struct CreatorTabView: View {
    @Binding var currentTabSelected: Int

    var body: some View {
        TabView(selection: $currentTabSelected) {
            //                ForEach(0..<3){
            FeedMasonryView()
                .tag(0)
            Text("1")
                .tag(1)
            FeedMasonryView()
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.spring(), value: currentTabSelected)
        .onChange(of: currentTabSelected, perform: { value in
            print(value)
        })
    }
}

struct CreatorTabView_Previews: PreviewProvider {
    @State static var currentTabSelected: Int = 0
    static var previews: some View {
        CreatorTabView(currentTabSelected: $currentTabSelected)
    }
}
