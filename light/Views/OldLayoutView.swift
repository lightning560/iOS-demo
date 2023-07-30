//
//  TabLayoutView.swift
//  light
//
//  Created by LiangNing on 2023/06/12.
//

import SwiftUI
// out
struct TabLayoutView: View {
    @State private var currentSelectedCategory:Int = 0
    private var categoryNavigateList=["one","two","three","four"]
    var body: some View {
            VStack{
                // TODO:给每个buttom绑定namespace.id,每次currentSelectedCategory的 onchange就会触发滚动。应对navigate超出屏幕。
                TabScrollView(selection:$currentSelectedCategory)
                TabWrapperView(selection:$currentSelectedCategory)
            }
    }
}
struct TabScrollView: View {
    /// 轮播滚动又用到TabView
    @Binding var selection:Int
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView (.horizontal, showsIndicators: false){
                HStack {
                    Button(action: {
                        selection = 0
                    }) {
                        selection == 0 ?
                        Text("one")
                            .underline()
                            .foregroundColor(.black)
                            .bold():
                        Text("one")
                            .foregroundColor(.gray)
                            .bold()
                    }
                    Button(action: {
                        selection=1
                    }) {
                        selection == 1 ?
                        
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


struct TabWrapperView: View {
    /// 轮播滚动又用到TabView
    @Binding var selection:Int
    
    var body: some View {
        TabView(selection: $selection) {
            //                ForEach(0..<3){
            FeedMasonryView()
                .tag(0)
            FeedMasonryViewTwo()
                .tag(1)

        }
        /// PageTabViewStyle 14.0的新东西
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.spring(),value:selection)
        .onChange(of: selection, perform: { value in
            print(value)
        })
    }
}

struct TabLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        TabLayoutView()
    }
}
