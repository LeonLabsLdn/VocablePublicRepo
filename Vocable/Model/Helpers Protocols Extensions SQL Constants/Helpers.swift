import UIKit
import AVKit

class Helpers:NSObject,AVSpeechSynthesizerDelegate{
    
    static let shared = Helpers()
    
    let synthesizer = AVSpeechSynthesizer()
    
    let audioSession = AVAudioSession.sharedInstance()
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
    }
    
    func decodeBase64(toImage strEncodeData: String) -> UIImage {
        if strEncodeData.count < 5{return UIImage(systemName: "person.crop.circle")!}
        let dataDecoded  = NSData(base64Encoded: strEncodeData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        let image = UIImage(data: dataDecoded as Data)
        if image == nil{return UIImage(systemName: "person.crop.circle")!}
        return image!
    }
    
    func codeString() -> String {
        return NSUUID().uuidString
    }
    
    let impactFeedbackGenerator: (
        light: UIImpactFeedbackGenerator,
        medium: UIImpactFeedbackGenerator,
        heavy: UIImpactFeedbackGenerator) = (
            UIImpactFeedbackGenerator(style: .light),
            UIImpactFeedbackGenerator(style: .medium),
            UIImpactFeedbackGenerator(style: .heavy)
    )
    
    func speak(phrase: String){
        synthesizer.delegate = self
        try? audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
        try? audioSession.setActive(true)
        if phrase.contains("per ") || phrase.contains("per?"){
            let utterance = AVSpeechUtterance(string: phrase.replacingOccurrences(of: "per", with: "pair"))
            if UserDefaults.standard.bool(forKey: "tran") == true{
                UserDefaults.standard.setValue(false, forKey: "tran")
                utterance.voice = AVSpeechSynthesisVoice(language: "en_US")
            }else{
            switch UserData.lang{
            case"Italian":utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
            case"Spanish":utterance.voice = AVSpeechSynthesisVoice(language: "es")
            case"French":utterance.voice = AVSpeechSynthesisVoice(language: "fr")
            default:utterance.voice = AVSpeechSynthesisVoice(language: "de")
            }
        }
            synthesizer.speak(utterance)
            return
        }else{
        let utterance = AVSpeechUtterance(string: phrase.replacingOccurrences(of: "/", with: ","))
            if UserDefaults.standard.bool(forKey: "tran") == true{
                UserDefaults.standard.setValue(false, forKey: "tran")
                utterance.voice = AVSpeechSynthesisVoice(language: "en_GB")
            }else{
                switch UserData.lang{
                case"Italian":utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
                case"Spanish":utterance.voice = AVSpeechSynthesisVoice(language: "es")
                case"French":utterance.voice = AVSpeechSynthesisVoice(language: "fr")
                default:utterance.voice = AVSpeechSynthesisVoice(language: "de")
                }
            }
        synthesizer.speak(utterance)
        }
    }
    
    func landingPolicyAtttString()->NSMutableAttributedString{
        let underlineAttriString = NSMutableAttributedString(string: Constants.text)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: Constants.range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Roboto-Bold", size: 11)!, range: Constants.range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1), range: Constants.range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: Constants.range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Roboto-Bold", size: 11)!, range: Constants.range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1), range: Constants.range2)
        return underlineAttriString
    }

}
