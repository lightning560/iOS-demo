//
//  MeDrawerWidget.swift
//  light
//
//  Created by LiangNing on 2023/07/08.
//

import SwiftUI

// MARK: menu

struct MeDrawerMenu: View {
    @Binding var menuWidth: CGFloat
    @Binding var offsetX: CGFloat

    var body: some View {
        Form {
            Section {
            }
            Section {
                drawerItemView(itemImage: "lock", itemName: "A")
                drawerItemView(itemImage: "gear.circle", itemName: "B")
                drawerItemView(itemImage: "briefcase", itemName: "C")
            }
            Section {
                drawerItemView(itemImage: "icloud.and.arrow.down", itemName: "D")
                drawerItemView(itemImage: "leaf", itemName: "E")
                drawerItemView(itemImage: "person", itemName: "F")
            }
        }
        .padding(.trailing, UIScreen.main.bounds.width - menuWidth)
        .edgesIgnoringSafeArea(.all)
        .shadow(color: Color.black.opacity(offsetX != 0 ? 0.1 : 0), radius: 5, x: 5, y: 0)
        .offset(x: offsetX)
        .background(
            Color.black.opacity(offsetX == 0 ? 0.5 : 0)
                .ignoresSafeArea(.all, edges: .vertical)
                .onTapGesture {
                    withAnimation {
                        offsetX = -menuWidth
                    }
                })
    }
}

// MARK: 栏目结构

private struct drawerItemView: View {
    var itemImage: String
    var itemName: String
    var body: some View {
        Button(action: {
        }) {
            HStack {
                Image(systemName: itemImage)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                Text(itemName)
                    .foregroundColor(.black)
                    .font(.system(size: 17))
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }.padding(.vertical, 10)
        }
    }
}

struct MeDrawerWidget_Previews: PreviewProvider {
    static var previews: some View {
        MeDrawerMenu(menuWidth: .constant(250), offsetX: .constant(-250))
    }
}
