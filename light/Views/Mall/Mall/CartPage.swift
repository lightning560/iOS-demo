//
//  CartPage.swift
//  light
//
//  Created by LiangNing on 2023/07/11.
//

import SwiftUI

struct CartPage: View {
    @State var isSelectedAll: Bool = false
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                ScrollView {
                    ForEach(0 ..< 5) { _ in
                        cartListItem()
                    }
                }
                .navigationBarTitle(Text("Messages"), displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: { }) { Image(systemName: "square.and.arrow.up") }.accentColor(.black)
                )

                HStack {
                    HStack {
                        isSelectedAll ?
                            Image(systemName: "circle").font(.system(size: 22)) :
                            Image(systemName: "circle.fill").font(.system(size: 22))
                    }
                    Text("$99").foregroundColor(.red)
                    Spacer()
                    Button(action: {}) {
                        Text("pay for (0)").bold()
                    }
                    .foregroundColor(.white)
                    .padding(15)
                    .background(.pink.opacity(0.9), in: RoundedRectangle(cornerRadius: 100))
                }
            }
        }
    }
}

private struct cartHeader: View {
    var body: some View {
        Text("view")
    }
}

private struct cartListItem: View {
    @State var isOn: Bool = false
    @State var count: Int = 1
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Spacer()
                HStack {
                    isOn ?
                        Image(systemName: "circle").font(.system(size: 22)) :
                        Image(systemName: "circle.fill").font(.system(size: 22))
                }
                Spacer()
            }.frame(width: 50)
                .onTapGesture {
                    self.isOn.toggle()
                }
            HStack {
                Image("avatar_1")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("miona")
                Text("hello,neuro-safa")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("$39.9")
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text("09-06")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding()
                HStack {
                    Image(systemName: "minus").frame(width: 15, height: 15).padding(5).background(.gray.opacity(0.3), in:
                        Circle())
                        .onTapGesture {
                            if count > 0 {
                                count -= 1
                            }
                        }
                    Text("\(count)")
                    Image(systemName: "plus").frame(width: 15, height: 15).padding(6).background(.gray.opacity(0.3), in:
                        Circle())
                        .onTapGesture {
                            if count < 10 {
                                count += 1
                            }
                        }
                }
            }
        }
    }
}

struct CartPage_Previews: PreviewProvider {
    static var previews: some View {
        CartPage()
    }
}
