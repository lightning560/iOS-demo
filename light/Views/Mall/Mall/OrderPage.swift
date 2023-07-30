//
//  OrderPage.swift
//  light
//
//  Created by LiangNing on 2023/07/11.
//

import SwiftUI

struct OrderPage: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                ScrollView {
                    VStack {
                        VStack {
                            HStack {
                                Text("New location")
                                Spacer()
                                Text("add")
                            }
                            HStack(spacing: 6) {
                                ForEach(0 ..< 10) { _ in
                                    Image(systemName: "minus").foregroundColor(.red)
                                    Image(systemName: "minus").foregroundColor(.blue)
                                }
                            }
                        }
                    }.frame(width: SCREEN_WIDTH)
                    ForEach(0 ..< 3) { _ in
                        orderProductListItem()
                    }
                    HStack {
                        Text("商品金额")
                        Spacer()
                        Text("$39.9")
                    }
                    HStack {
                        Text("优惠券")
                        Spacer()
                        Text("$39.9")
                    }
                    HStack {
                        Text("运费")
                        Spacer()
                        Text("$39.9")
                    }
                    HStack {
                        Text("支付方式")
                        Spacer()
                        Text("$39.9")
                    }
                    HStack {
                        Text("订单备注")
                        Spacer()
                        Text("$39.9")
                    }
                }

                HStack {
                    Text("Total:")
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
            .navigationBarTitle(Text("Order"), displayMode: .inline)
        }
    }
}

private struct orderProductListItem: View {
    @State var count: Int = 1
    var body: some View {
        HStack(alignment: .top) {
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

struct OrderPage_Previews: PreviewProvider {
    static var previews: some View {
        OrderPage()
    }
}
