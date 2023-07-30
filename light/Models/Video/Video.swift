//
//  Video.swift
//  light
//
//  Created by LiangNing on 2023/07/05.
//

import Foundation
import AVFoundation
import SwiftUI
import Kingfisher

struct Video: Hashable, Codable, Identifiable {
    var id: String
    var playListIndex :Int
    var playing: Bool
    var isFavorite: Bool
    
    var src: String
    var videoPlayer :AVPlayer{
        let url = URL(string: src)
        return AVPlayer(playerItem: AVPlayerItem(url: url!))
    }
    
    private var cover: String
    var coverImage: KFImage {
        KFImage(URL(string: cover)!)
        .resizable()
    }
    
}
