import Foundation
#if canImport(Combine)
import Combine
#endif
#if canImport(Speech) && canImport(AVFoundation)
import Speech
import AVFoundation
#endif

#if !canImport(Combine)
protocol ObservableObject: AnyObject {}
@propertyWrapper struct Published<Value> {
    var wrappedValue: Value
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}
#endif

/// 提供語音辨識來檢查使用者發音是否正確
#if canImport(Speech) && canImport(AVFoundation)
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
#else
/// A fallback implementation used when the Speech framework is unavailable.
class SpeechPronunciationChecker: ObservableObject {
    @Published var recognizedText: String = ""

    /// Dummy start method for non-Apple platforms.
    func startRecognition() throws {
        // In environments without the Speech framework we simply
        // indicate that recognition is unsupported.
        recognizedText = ""
    }

    /// Stop recognition - no-op in the fallback case.
    func stopRecognition() {}
}
#endif
