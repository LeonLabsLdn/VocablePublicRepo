import Foundation
import AVFoundation
import Speech

class AudioModel{
    
    static let shared       = AudioModel()
    private var timer       : Timer?
    var speechRecognizer    = SFSpeechRecognizer()!
    let audioEngine         = AVAudioEngine()
    var recognitionRequest  : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask     : SFSpeechRecognitionTask?
    var audioSession        = AVAudioSession.sharedInstance()
    var count               = 0
    
    func restartSpeechTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            self.stop()
        })
    }
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
        }
    }
    func startRecording(eng:Bool) throws {
        AudioModel.shared.count = 0
        recognitionTask?.cancel()
        recognitionTask = nil
        AudioModel.shared.configureAudioSession()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest!.shouldReportPartialResults = true
        if eng == true{
            speechRecognizer = SFSpeechRecognizer()!
        }else{
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "it_IT"))!
        }
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { result, error in
            if let result = result {
                Protocols.translateDelegate?.updateLabel(text:"\(result.bestTranscription.formattedString)")
            }
            if error != nil{
                print(error!)
            }
            else{
                AudioModel.shared.restartSpeechTimer()
            }
        }
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
    }
    func stop(){
        if count < 1{
            count += 1
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
            recognitionRequest = nil
            recognitionTask = nil
            recognitionTask?.cancel()
            Protocols.translateDelegate?.endTranscribe()
        }
    }
    func checkRecordingPermission(){
            audioSession.requestRecordPermission() { [] allowed in
                DispatchQueue.main.async { [] in
                    if allowed {
                        SFSpeechRecognizer.requestAuthorization { [] authStatus in
                            DispatchQueue.main.async { [] in
                                if authStatus == .authorized {
                                    Protocols.translateDelegate?.authorisationSuccess()
                                }else{
                                    Protocols.translateDelegate?.authorisationFailed()
                                }
                            }
                        }
                    }else{
                        Protocols.translateDelegate?.authorisationFailed()
                    }
                }
            }
    }
    
}
