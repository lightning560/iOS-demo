//
//  CheckoutPage.swift
//  light
//
//  Created by LiangNing on 2023/07/12.
//

import SwiftUI

struct CheckoutPage: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                ScrollView {
                    ChoutoutCountdowmWidget()
                    HStack {
                        Text("订单号")
                        Spacer()
                        Text("31431444456")
                    }
                    HStack {
                        Text("应付金额")
                        Spacer()
                        Text("$319")
                    }
                    HStack {
                        Text("订单详情")
                        Spacer()
                        Text("$319")
                    }
                    HStack {
                        Text("支付方式")
                        Spacer()
                        Text("$319")
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
        }
    }
}

private struct ChoutoutCountdowmWidget: View {
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            Text("Time: \(timeRemaining)")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(Color.black)
                        .opacity(0.75)
                )
        }.onReceive(timer) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }
}

struct CheckoutPage_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutPage()
    }
}
