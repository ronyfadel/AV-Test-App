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

      Button("Export") {
        let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        let outputURL = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString + ".mov")
        session.outputURL = outputURL
        session.outputFileType = .mov
        session.exportAsynchronously {
          assert(session.error == nil) // <- crashes here
        }
      }
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

          let videoTracks = try await asset.loadTracks(withMediaType: .video)
          let formatDescriptions = try await videoTracks[0].load(.formatDescriptions)

          print("format descriptions: \(formatDescriptions)")
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
