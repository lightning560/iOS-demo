//
//  Card.swift
//  light
//
//  Created by LiangNing on 2023/07/10.
//

struct Card: Identifiable {
    let id: String
    let image: String
    let title: String
    let subtitle: String
}

struct CollectionCard: Identifiable {
    let id: String
    let image: String
    let title: String
    let price: Int
}
