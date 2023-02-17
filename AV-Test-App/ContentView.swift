import SwiftUI
import AVFoundation

struct ContentView: View {
  static let videoURL = Bundle.main.url(forResource: "example", withExtension: "mp4")!
  @State private var asset: AVAsset

  init() {
    _asset = .init(wrappedValue: AVURLAsset(url: Self.videoURL))
  }

  var body: some View {
    VStack {
      VideoPlayerView(asset: asset)
        .frame(maxHeight: 300)
    }
    .padding()
    .onAppear {
      Task {
        do {
          let isPlayable = try await asset.load(.isPlayable)
          let isReadable = try await asset.load(.isReadable)
          let isExportable = try await asset.load(.isExportable)
          let isComposable = try await asset.load(.isComposable)
          let hasProtectedContent = try await asset.load(.hasProtectedContent)

        print("""
        isPlayable? \(isPlayable)
        isReadable? \(isReadable)
        isExportable? \(isExportable)
        isComposable? \(isComposable)
        hasProtectedContent? \(hasProtectedContent)
        """)
        } catch {
          print("error: \(error)")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
