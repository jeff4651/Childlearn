import Foundation
import Speech
import AVFoundation
import Combine

/// 提供語音辨識來檢查使用者發音是否正確
class SpeechPronunciationChecker: NSObject, ObservableObject {
    @Published var recognizedText: String = ""

    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    /// 開始錄音並辨識
    func startRecognition() throws {
        recognizedText = ""
        let authStatus = SFSpeechRecognizer.authorizationStatus()
        if authStatus != .authorized {
            SFSpeechRecognizer.requestAuthorization { _ in }
        }

        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else { return }

        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        recognitionTask = recognizer?.recognitionTask(with: request) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                }
            }
            if error != nil || (result?.isFinal ?? false) {
                self.stopRecognition()
            }
        }
    }

    /// 停止錄音與辨識
    func stopRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
}
