import SwiftUI
import AVKit

struct VideoPlayerView: View {
  @State private var avPlayer: AVPlayer

  init(asset: AVAsset) {
    _avPlayer = .init(wrappedValue: .init(playerItem: .init(asset: asset)))
  }

  var body: some View {
    AVPlayerView(avPlayer: avPlayer)
  }
}

private struct AVPlayerView : UIViewControllerRepresentable {
  var avPlayer: AVPlayer

  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let controller = AVPlayerViewController()
#if !targetEnvironment(macCatalyst)
    if #available(iOS 16.0, *) {
      controller.allowsVideoFrameAnalysis = false
    }
#endif
    controller.videoGravity = .resizeAspectFill
    controller.player = avPlayer
    controller.view.backgroundColor = .clear
    return controller
  }

  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    uiViewController.player = avPlayer
  }
}
