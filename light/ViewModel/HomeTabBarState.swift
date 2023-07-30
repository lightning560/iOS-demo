//
//  HomeTabState.swift
//  light
//
//  Created by LiangNing on 2023/07/03.
//

import Foundation

enum HomeTabBarEnum {
    case Home
    case Video
    case Shop
    case Message
    case Me
}
class HomeTabBarState: ObservableObject {
   @Published var homeTabBarShow : Bool = true
}
