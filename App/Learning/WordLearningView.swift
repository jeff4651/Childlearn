import SwiftUI
import AVFoundation

struct WordLearningView: View {
    let word: Word
    private var player: AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: word.audioName, withExtension: "mp3") else { return nil }
        return try? AVAudioPlayer(contentsOf: url)
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
