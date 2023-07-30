//
//  MainBannerView.swift
//  light
//
//  Created by LiangNing on 2023/07/01.
//

import SwiftUI

struct MallBannerView: View {
    @State private var selectedImage: Int = 0
    var body: some View {
        TabView(selection: $selectedImage) {
            //                ForEach(0..<3){
            Image("image1")
                //                        .frame(width:UIScreen.main.bounds.width, height: 340, alignment: .center)
                .resizable()
                //                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                //                        .aspectRatio(1/1,contentMode: .fit)
                .tag(0)

            Image("image2")
                .resizable()
                .tag(1)
        }
        /// PageTabViewStyle 14.0的新东西
        .padding(0)
        .frame(width: UIScreen.main.bounds.width, height: 200)
        //                .foregroundColor(.red)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        //        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .animation(.spring(), value: selectedImage)
        .onChange(of: selectedImage, perform: { _ in
            //                    print(value)
//            print(LocalUrl.feed.url+Req.listPostCard.path+"/"+String(0)+"/"+String(5)+"/"+"by"+"/"+"order")
        })
    }
}

struct MallBannerView_Previews: PreviewProvider {
    static var previews: some View {
        MallBannerView()
    }
}
