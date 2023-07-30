//
//  CollectView.swift
//  light
//
//  Created by LiangNing on 2023/06/17.
//

import Kingfisher
import SwiftUI

struct CollectionPage: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ScrollViewReader { _ in
                ScrollView(.vertical, showsIndicators: true) {
                    CollectImageTabView()
                    CollectIntroduceView()
                    CollectIntroduceListView()
                    CollectShopIntroduceView()
                    CollectDescriptionView()
                    CollectCollapseView()
                    CollectCollapseView()
                    CollectRelatedView()
                    HStack {}.frame(height: 100)
                }
            }.edgesIgnoringSafeArea(.all)
            CollectBottomBarView()
        }.edgesIgnoringSafeArea(.all)
    }
}

struct CollectImageTabView: View {
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
        .frame(width: UIScreen.main.bounds.width, height: 400)
        //                .foregroundColor(.red)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .animation(.spring(), value: selectedImage)
        .onChange(of: selectedImage, perform: { _ in
            //                    print(value)
        })
    }
}

struct CollectIntroduceView: View {
    @State private var isFavorite: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text("$188")
                    .font(.title2)
                    .foregroundColor(.black)
                Text("到手价$158")
                    .font(.body)
                    .foregroundColor(.red)
                    .bold()
                Spacer()
                if isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                } else {
                    Image(systemName: "star")
                        .font(.footnote)
                }
            }
            Text("SwiftUI区别于我们UIKit的创建方式，SwiftUI对它进行了简化，具体的创建如下")
                .font(.body)
//                .foregroundColor(.red)
                .bold()
                .lineLimit(2)
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct CollectIntroduceListView: View {
    @State private var isShowingSheet = false

    func didDismiss() {
        // Handle the dismissing action.
        print("sheet didDismiss")
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark.circle")
                Text("包邮")
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.gray)
                Text("分期免息")
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.gray)
                Text("7天保价")
                Spacer()
                Image(systemName: "chevron.forward")
                    .foregroundColor(.black)
                    .font(.body)
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            .foregroundColor(.gray)
            .font(.caption)
            .background(Color.gray.opacity(0.2))
            //            Spacer().frame(height: 1)
            .onTapGesture {
                isShowingSheet.toggle()
            }
            .sheet(isPresented: $isShowingSheet, onDismiss: didDismiss) {
                VStack {
                    Text("License Agreement")
                        .font(.title)
                        .padding(50)
                    Text("""
                        Terms and conditions go here.
                    """)
                    .padding(50)
                    Button("Dismiss",
                           action: { isShowingSheet.toggle() })
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .background(Color.blue)
                .ignoresSafeArea(edges: .all)
            }

            HStack {
                Text("优惠")
                    .font(.footnote)
                    .bold()
                Text("满149减25")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                    .background(RoundedRectangle(cornerRadius: 6.0).foregroundColor(.red).opacity(0.06))
//                    .border(Color.red)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.red, lineWidth: 0.5)
                    )
                Text("粉丝专享券")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                    .background(RoundedRectangle(cornerRadius: 6.0).foregroundColor(.red).opacity(0.06))
//                    .border(Color.red)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.red, lineWidth: 0.5)
                    )
                Spacer()
                Image(systemName: "chevron.forward")
            }
//            .listRowInsets(EdgeInsets())

            HStack {
                Text("分期")
                    .font(.footnote)
                    .bold()
                Text("优惠sdafasdfasdfafds,adsf,ads fadssfasd af ")
                    .font(.caption)
                    .frame(width: .infinity)
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chevron.forward")
            }
            HStack {
                Text("发货")
                    .font(.footnote)
                    .bold()
                Image(systemName: "airplane.circle")
                    .rotationEffect(.degrees(-45.0))
                Text("优惠sdafasdfasdfafds adsf ads fadssfasd af ")
                    .font(.caption)
                    .frame(width: .infinity)
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chevron.forward")
            }
            HStack {
                Text("点评")
                    .font(.footnote)
                    .bold()
                Text("8")
                    .font(.footnote)
                    .bold()
                Spacer()
                Text("好评率 89.4%")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Image(systemName: "chevron.forward")
            }
        }
//        .listStyle(.inset)
    }
}

struct CollectShopIntroduceView: View {
    var body: some View {
        VStack {
            HStack {
                Image("image1")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 1))
                    .shadow(radius: 1)
                VStack(alignment: .leading, spacing: 4) {
                    Text("优衣库")
                        .font(.body)
                    HStack(spacing: 0) {
                        Text("体验星际")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Group {
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star")
                        }
                        .font(.caption2)
                        .foregroundColor(.red)
                    }
                }
                Spacer()

                Image(systemName: "chevron.forward")
                    .foregroundColor(.black)
                    .font(.body)
            }
            CollectShopIntroduceTabItemView()
        }
    }
}

struct CollectShopIntroduceTabItemView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0 ..< 5) { _ in
                    VStack(alignment: .leading, spacing: 2) {
                        Image("image2")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("namenanananan")
                            .lineLimit(1)
                        Text("$199")
                            .font(.footnote)
                    }
                    .frame(width: 100, height: 150, alignment: .leading)
                }
            }
        }
    }
}

struct CollectDescriptionView: View {
    var body: some View {
        LazyVStack(alignment: .center) {
            ForEach(1 ... 10, id: \.self) {
                Text("Row \($0)")
                Image("image1")
                    .scaledToFill()
//                    .resizable()
            }
        }
    }
}

struct CollectCollapseView: View {
    @State private var isCollapseExpanded: Bool = false
    var body: some View {
        VStack {
            panel
            content
        }
        .animation(.interactiveSpring(), value: isCollapseExpanded)
    }

    private var panel: some View {
        HStack {
            Text("价格说明")
            Spacer()
            isCollapseExpanded ?Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
        }
        .onTapGesture { isCollapseExpanded.toggle() }
//        .animation(.default,value:isCollapseExpanded)
    }

    private var content: some View {
        Text(isCollapseExpanded ? "By following this tutorial, you will achieve an effect presented at the top of the article. With the help of SwiftUI, adding animations that delights the user experience can be straightforward.You can find the full code of this project below:" : "")
            .font(.footnote)
    }
}

struct CollectRelatedView: View {
    let columns = [GridItem(.adaptive(minimum: 160, maximum: 500)), GridItem(.adaptive(minimum: 160, maximum: 500))]

    var body: some View {
        VStack(alignment: .leading) {
            Text("related produces")
                .frame(alignment: .leading)
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(0 ..< 6) { _ in
                    cell
                }
                KFImage(URL(string: "https://dummyimage.com/101")!)
                KFImage(URL(string: "https://dummyimage.com/101")!)
                    .resizable()
            }
        }
    }

    private var cell: some View {
        VStack(spacing: 2) {
            AsyncImage(url: URL(string: "https://dummyimage.com/100"), transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case let .success(image):
                    image
                        .resizable()
                        .transition(.scale(scale: 0.1, anchor: .center))
                case .failure:
                    Image(systemName: "wifi.slash")
                @unknown default:
                    EmptyView()
                }
            }
//        placeholder: {
//                ProgressView()
//            }
            .frame(height: 140, alignment: .center)
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
        .frame(height: 200)
        .cornerRadius(5.0)
    }
}

struct CollectBottomBarView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle().fill().foregroundColor(.white)
            VStack {
                HStack {
                    VStack {
                        Image("avatar_4").resizable().frame(width: 26, height: 26).clipShape(Circle()).padding(0)
                        Text("shop").font(.system(size: 15)).bold()
                    }
                    VStack {
                        Image(systemName: "beats.headphones").font(.title)
                        Text("kefu").font(.system(size: 15)).bold()
                    }

                    VStack {
                        Image(systemName: "cart").font(.title)
                        Text("cart").font(.system(size: 15)).bold()
                    }
                    Spacer()
                    Button(action: { }) {
                        Text("add to cart")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .frame(width: 120, height: 40, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 100.0).foregroundColor(.gray).opacity(0.15))
                    Button(action: { }) {
                        Text("buy now")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(width: 120, height: 40, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 100.0).foregroundColor(.red).opacity(0.8))
                }.padding()
                HStack {}.frame(height: 20)
            }
        }.frame(height: 100)
    }
}

struct CollectPage_Previews: PreviewProvider {
    static var previews: some View {
        CollectionPage()
//        CollectIntroduceView()
//        CollectIntroduceListView()
//        CollectShopIntroduceTabItemView()
//        CollectShopIntroduceView()
//        CollectDescriptionView()
    }
}
