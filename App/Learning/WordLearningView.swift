import SwiftUI
import AVFoundation
import Speech

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

    @StateObject private var checker = SpeechPronunciationChecker()
    @State private var isRecording = false
    @State private var showResult = false
    private var player: AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: word.audioName, withExtension: "mp3") else { return nil }
        return try? AVAudioPlayer(contentsOf: url)

    }

    var body: some View {
        VStack(spacing: 20) {
            Text(word.text)
                .font(.largeTitle)
            Text(word.translation)
                .font(.title3)
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
=======
            HStack(spacing: 40) {
                Button(action: {
                    player?.play()
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.largeTitle)
                }
                Button(action: {
                    if isRecording {
                        checker.stopRecognition()
                        isRecording = false
                        showResult = true
                    } else {
                        try? checker.startRecognition()
                        isRecording = true
                    }
                }) {
                    Image(systemName: isRecording ? "mic.fill" : "mic")
                        .font(.largeTitle)
                }

            }
            Text(word.sentence)
                .font(.title2)
                .padding()
        }
        .padding()

        .onAppear(perform: loadAudio)

        .alert(isPresented: $showResult) {
            Alert(title: Text("你的發音"), message: Text(checker.recognizedText), dismissButton: .default(Text("OK")))
        }
    }
}

struct WordLearningView_Previews: PreviewProvider {
    static var previews: some View {
        let sample = Word(text: "apple",
                          imageName: "apple_image",
                          audioName: "apple_sound",
                          sentence: "I eat an apple.",
                          translation: "蘋果")
        WordLearningView(word: sample)
    }
}
