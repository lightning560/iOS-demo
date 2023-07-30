//
//  XCombineDemoState.swift
//  light
//
//  Created by LiangNing on 2023/07/05.
//

import Foundation

class XCombineDemoState: ObservableObject {
    @Published var xnum : Int = 0
    
    func plusXnum() -> Void {
        self.xnum = self.xnum + 1
    }
}
