import SwiftUI
import AVFoundation

struct WordLearningView: View {
    let word: Word
    @State private var player: AVAudioPlayer?
    private let ttsService = GoogleNotebookTTSService()

    private func loadAudio() {
        if let url = Bundle.main.url(forResource: word.audioName, withExtension: "mp3"),
           let audio = try? AVAudioPlayer(contentsOf: url) {
            self.player = audio
        } else {
            ttsService.synthesizeAudio(for: word.text) { data in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.player = try? AVAudioPlayer(data: data)
                }
            }
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(word.text)
                .font(.largeTitle)
            Image(word.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            Button(action: {
                if player == nil {
                    loadAudio()
                }
                player?.play()
            }) {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.largeTitle)
            }
            Text(word.sentence)
                .font(.title2)
                .padding()
        }
        .padding()
        .onAppear(perform: loadAudio)
    }
}

struct WordLearningView_Previews: PreviewProvider {
    static var previews: some View {
        let sample = Word(text: "apple",
                          imageName: "apple_image",
                          audioName: "apple_sound",
                          sentence: "I eat an apple.")
        WordLearningView(word: sample)
    }
}
