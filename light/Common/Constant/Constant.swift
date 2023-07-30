//
//  File.swift
//  light
//
//  Created by LiangNing on 2023/07/07.
//

import SwiftUI

// 屏幕宽度
let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
// 屏幕高度
let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height
// 底部安全区域的高度
let SCREEN_SAFE_BOTTOM: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
// 自定义tabbar 的高度
let TAB_BAR_HEIGHT: CGFloat = 80
// 视频展示区域的高度
let TTVIDEO_HEIGHT: CGFloat = UIScreen.main.bounds.height - TAB_BAR_HEIGHT
