//
//  TTVideoPlayList.swift
//  light
//
//  Created by LiangNing on 2023/07/01.
//

import AVFoundation
import AVKit
import SwiftUI

struct TTVideo: Identifiable {
    var id: String = UUID().uuidString
    var player: AVPlayer
    var isMoving: Bool = false
    var avatar: String
}

class TTVideoPlayListVM: ObservableObject {
    @Published var videos: [TTVideo] = [
        TTVideo(
            player:
            AVPlayer(
                url: URL(fileURLWithPath: Bundle.main.path(forResource: "v1", ofType: "MP4")!)
            ),
            avatar: "avatar_1"
        ),

        TTVideo(
            player:
            AVPlayer(
                url: URL(fileURLWithPath: Bundle.main.path(forResource: "v2", ofType: "MP4")!)
            ),
            avatar: "avatar_2"
        ),
        TTVideo(
            player:
            AVPlayer(
                url: URL(fileURLWithPath: Bundle.main.path(forResource: "v3", ofType: "MP4")!)
            ),
            avatar: "avatar_3"
        ),
        TTVideo(
            player:
            AVPlayer(
                url: URL(fileURLWithPath: Bundle.main.path(forResource: "v4", ofType: "MP4")!)
            ),
            avatar: "avatar_4"
        ),
        TTVideo(
            player:
            AVPlayer(
                url: URL(fileURLWithPath: Bundle.main.path(forResource: "v5", ofType: "MP4")!)
            ),
            avatar: "avatar_5"
        ),
    ]
    @Published var currPlayerIndex: Int = 0
    @Published var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                playIndex()
            } else {
                pauseIndex()
            }
        }
    }

    func playIndex() {
        print("playerIndex:\(currPlayerIndex)")
        let currentItem = videos[currPlayerIndex].player.currentItem

        if currentItem?.currentTime() == currentItem?.duration {
            currentItem?.seek(to: .zero, completionHandler: nil)
        }
        videos[currPlayerIndex].player.play()
    }

    func pauseIndex() {
        print("pauseIndex:\(currPlayerIndex)")
        videos[currPlayerIndex].player.pause()
    }
}

struct TTVideoPlayList: View {
    @StateObject var playerListVM = TTVideoPlayListVM()
    @State var currPlayerIndex: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            PlayerScrollView(currPlayerIndex: $currPlayerIndex, videos: $playerListVM.videos)
                .frame(height: TTVIDEO_HEIGHT)
        }
        .ignoresSafeArea()
    }

    private var bottomBarWidget: some View {
        // tabbar
        HStack {
            Button {
            } label: {
                Text("首页")
            }
            .frame(maxWidth: .infinity)
            .frame(height: TAB_BAR_HEIGHT)

            Button {
            } label: {
                Text("朋友")
            }
            .frame(maxWidth: .infinity)
            .frame(height: TAB_BAR_HEIGHT)

            Button {
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue, lineWidth: 2)
                        .offset(x: -2)
                        .frame(width: 30, height: 20)

                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.red, lineWidth: 2)
                        .offset(x: 2)
                        .frame(width: 30, height: 20)

                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 30, height: 20)

                    Image(systemName: "plus")
                        .font(.system(size: 12))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: TAB_BAR_HEIGHT)

            Button {
            } label: {
                Text("消息")
            }
            .frame(maxWidth: .infinity)
            .frame(height: TAB_BAR_HEIGHT)

            Button {
            } label: {
                Text("我")
            }
            .frame(maxWidth: .infinity)
            .frame(height: TAB_BAR_HEIGHT)
        }
        .foregroundColor(.black)
        .frame(height: TAB_BAR_HEIGHT + SCREEN_SAFE_BOTTOM, alignment: .top)
    }
}

struct PlayerViewController: UIViewControllerRepresentable {
    var player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.player = player
        vc.showsPlaybackControls = false
        vc.videoGravity = .resizeAspectFill

        return vc
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }

    typealias UIViewControllerType = AVPlayerViewController
}

struct PlayerListView: View {
    @Binding var videos: [TTVideo]
    @Binding var currPlayerIndex: Int
    @StateObject var playerListVM = TTVideoPlayListVM()
    @State var isPlaying: Bool = true
    func playerToggle() {
        print("playerToggle: \(videos[currPlayerIndex].player.timeControlStatus.rawValue)")
        if videos[currPlayerIndex].player.timeControlStatus.rawValue == 2 {
            videos[currPlayerIndex].player.pause()
            isPlaying = false
            return
        }
        if videos[currPlayerIndex].player.timeControlStatus.rawValue == 0 {
            videos[currPlayerIndex].player.play()
            isPlaying = true
            return
        }
        if videos[currPlayerIndex].player.timeControlStatus.rawValue == 1 {
            videos[currPlayerIndex].player.pause()
            isPlaying = false
            return
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(videos) { video in
                // 点赞、评论、转发等UI布局
                ZStack {
                    // 视频播放的view
                    PlayerViewController(player: video.player)
                    VStack {
                        isPlaying ?AnyView(Color.clear) :
                            AnyView(
                                Image(systemName: "play.fill")
                                    .font(.system(size: 40))
                            )
                    }
                    .frame(width: SCREEN_WIDTH, height: 600)
                    .background(Color.white)
                    .opacity(0.01)
                    .onTapGesture {
                        playerToggle()
                    }
                    .overlay(alignment: .bottomLeading) {
                        // 视频简介，作者id
                        VStack(alignment: .leading, spacing: 10) {
                            //                        Spacer()
                            // SwiftUI中还支持markdown的表达方式，比如加粗
                            Text(" **@等什么君** ")
                                .font(.system(size: 20, weight: .bold))
                            Text("有多令人迷惑 **#美好推荐官** **#搞笑** **#南北差异** **#吹水佬k** **#DOU+小助手** **#抖音小助手**")
                                .font(.system(size: 18))
                        }
                        .frame(width: SCREEN_WIDTH - 150)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        VStack {
                            ZStack(alignment: .bottom) {
                                Image(video.avatar)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )

                                Image(systemName: "plus")
                                    .font(.system(size: 12))
                                    .frame(width: 20, height: 20)
                                    .background(
                                        Circle()
                                            .fill(Color.red)
                                    )
                                    .offset(y: 10)
                            }
                            .padding(.bottom, 30)

                            VStack(spacing: 20) {
                                Button {
                                } label: {
                                    VStack(spacing: 6) {
                                        Image(systemName: "suit.heart.fill")
                                            .font(.system(size: 28))
                                        Text("29.3w")
                                            .font(.system(size: 18))
                                    }
                                }

                                Button {
                                } label: {
                                    VStack(spacing: 6) {
                                        Image(systemName: "ellipsis.bubble")
                                            .font(.system(size: 28))
                                        Text("9.3w")
                                            .font(.system(size: 18))
                                    }
                                }

                                Button {
                                } label: {
                                    VStack(spacing: 6) {
                                        Image(systemName: "arrowshape.turn.up.forward.fill")
                                            .font(.system(size: 28))
                                        Text("2.3w")
                                            .font(.system(size: 18))
                                    }
                                }
                                Button(action: {
                                    print("currPlayerIndex:\(currPlayerIndex) :pause()")
                                    print("\(self.videos[currPlayerIndex].player.timeControlStatus)")
                                    self.videos[currPlayerIndex].player.pause()
                                    //                                    self.playerListVM.isPlaying.toggle()
                                }) {
                                    Image(systemName: "play")
                                }
                            }
                            .foregroundColor(.white)
                        }
                    }

                    HStack(spacing: 30) {
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                }

                .frame(height: TTVIDEO_HEIGHT)
                .offset(y: -24)
            }
        }
        .onAppear {
            // 在view显示后，获取第一个video的player
            let player = self.videos[0].player
            // 让player播放video
            player.play()
            // 播放完成后的action设置为none
            player.actionAtItemEnd = .none

            // 监听播放到最后的通知
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videos[0].player.currentItem, queue: .main) { _ in
                // 重置视频播放时间并再次播放
//                player.seek(to: .zero)
//                player.play()
            }
        }
    }
}

struct PlayerScrollView: UIViewRepresentable {
    @Binding var currPlayerIndex: Int
    @Binding var videos: [TTVideo]

    typealias UIViewType = UIScrollView

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        // 分页滚动效果
        scrollView.isPagingEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        // 设置scrollView的代理
        scrollView.delegate = context.coordinator

        // 得到内容的大小
        let contentSize = CGSize(width: SCREEN_WIDTH, height: TTVIDEO_HEIGHT * CGFloat(videos.count))
        scrollView.contentSize = contentSize

        // 获取播放视频的list，通过UIHostingController转换成UIViewController
        let playerListView = UIHostingController(rootView: PlayerListView(videos: $videos, currPlayerIndex: $currPlayerIndex))
        playerListView.view.frame = CGRect(origin: .zero, size: contentSize)

        // 把播放视频的list添加到scrollView上
        scrollView.addSubview(playerListView.view)

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(playerScrollView: self, currPlayerIndex: $currPlayerIndex)
    }

    // 实现代理
    class Coordinator: NSObject, UIScrollViewDelegate {
        var currPlayerIndex: Binding<Int>
        var currIndex: Int = 0
        var playerScrollView: PlayerScrollView

        init(playerScrollView: PlayerScrollView, currPlayerIndex: Binding<Int>) {
            self.playerScrollView = playerScrollView
            self.currPlayerIndex = currPlayerIndex
        }

        // 监听滚动停止
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let index = Int(scrollView.contentOffset.y / TTVIDEO_HEIGHT)

            if currIndex != index {
                currIndex = index
                currPlayerIndex.wrappedValue = index

                for i in 0 ..< playerScrollView.videos.count {
                    playerScrollView.videos[i].player.seek(to: .zero)
                    playerScrollView.videos[i].player.pause()
                }

                playerScrollView.videos[currIndex].player.play()
                // 播放完成后的action设置为none
                playerScrollView.videos[currIndex].player.actionAtItemEnd = .none

                // 监听播放到最后的通知
                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerScrollView.videos[currIndex].player.currentItem, queue: .main) { _ in
                    // 重置视频播放时间并再次播放
//                    self.playerScrollView.videos[self.currIndex].player.seek(to: .zero)
//                    self.playerScrollView.videos[self.currIndex].player.play()
                }
            }
        }
    }
}

struct TTVideoPlayList_Previews: PreviewProvider {
    static var previews: some View {
        TTVideoPlayList()
    }
}
