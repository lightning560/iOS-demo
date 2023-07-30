//
//  GalleryLayoutView.swift
//  light
//
//  Created by LiangNing on 2023/06/19.
//
import SwiftUI

struct GalleryLayoutView<Content: View, T: Identifiable>: View where T: Hashable {
    var content: (T) -> Content
    var list: [T]
    var colums: Int
    var showsIndicators: Bool
    var spacing: CGFloat

    init(list: [T], colums: Int, showsIndicators: Bool, spacing: CGFloat, @ViewBuilder content: @escaping (T) -> Content) {
        self.list = list
        self.colums = colums
        self.showsIndicators = showsIndicators
        self.spacing = spacing
        self.content = content
    }

    func setupList() -> [[T]] {
        // 创建一个二维数组，数组元素类型为[T]，数组个数为colums个
        var girdList: [[T]] = Array(repeating: [], count: colums)

        var currIndex: Int = 0
        // 分割list
        list.forEach { obj in
            girdList[currIndex].append(obj)

            if currIndex == colums - 1 {
                currIndex = 0
            } else {
                currIndex += 1
            }
        }

        return girdList
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            HStack(alignment: .top) {
                ForEach(setupList(), id: \.self) { objs in
                    LazyVStack(spacing: spacing) {
                        ForEach(objs) { obj in
                            content(obj)
                        }
                    }
                }
            }
        }
    }
}
