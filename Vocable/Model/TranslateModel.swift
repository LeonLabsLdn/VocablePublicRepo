import MLKitTranslate

class TranslateModel{
    
    static let shared       = TranslateModel()
    
    let language        = ["Italian":TranslateLanguage .italian, "Spanish":TranslateLanguage .spanish, "French":TranslateLanguage .french, "German":TranslateLanguage .german]
    var translation     :String?
    
    func translate(eng: String, learningLang: String){
        let fromEnglish             = TranslatorOptions(sourceLanguage: .english, targetLanguage: language[UserData.lang]!)
        let toEnglish               = TranslatorOptions(sourceLanguage: language[UserData.lang]!, targetLanguage: .english)
        let fromEnglishTranslator = Translator.translator(options: fromEnglish)
        let toEnglishTranslator = Translator.translator(options: toEnglish)
        let conditions = ModelDownloadConditions(allowsCellularAccess: true,allowsBackgroundDownloading: true)
        
        toEnglishTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else {
                return
            }
            toEnglishTranslator.translate(learningLang) { [self] translatedText, error in
                guard error == nil, let translatedText = translatedText else {
                    let model = TranslateRemoteModel.translateRemoteModel(language: language[UserData.lang]!)
                    ModelManager.modelManager().deleteDownloadedModel(model) { error in
                        guard error == nil else { return }
                        UserDefaults.standard.setValue(false, forKey: UserData.lang)
                }
                    return
                }
                if learningLang != ""{
                    self.translation = translatedText
                    Protocols.imageRecognitionDelegate?.completeTranslate()
                    Protocols.translateDelegate?.completeTranslate()
                    return
                }
            }
        }
        fromEnglishTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else {
                return
            }
            fromEnglishTranslator.translate(eng) { [self] translatedText, error in
                guard error == nil, let translatedText = translatedText else {
                    let model = TranslateRemoteModel.translateRemoteModel(language: language[UserData.lang]!)
                        ModelManager.modelManager().deleteDownloadedModel(model) { error in
                            guard error == nil else { return }
                            UserDefaults.standard.setValue(false, forKey: UserData.lang)
                    }
                    return
                }
                if eng != ""{
                    self.translation = translatedText
                    Protocols.imageRecognitionDelegate?.completeTranslate()
                    Protocols.translateDelegate?.completeTranslate()
                    return
                }
            }
        }
    }
    
    func downloadModels(){
        switch UserData.lang{
        case "Italian":
            if UserDefaults.standard.bool(forKey: UserData.lang) == false{
                let italianModel = TranslateRemoteModel.translateRemoteModel(language: .italian)
                ModelManager.modelManager().deleteDownloadedModel(italianModel) { error in
                    guard error == nil else {return}
                    ModelManager.modelManager().download(italianModel,conditions: ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true))
                    NotificationCenter.default.addObserver(forName: .mlkitModelDownloadDidSucceed,object: nil,queue: nil) { [] notification in
                        guard let userInfo = notification.userInfo, let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel,
                              model == italianModel
                        else { return }
                        UserDefaults.standard.setValue(true, forKey: UserData.lang)
                    }
                }
            }
        case "Spanish":
            if UserDefaults.standard.bool(forKey: UserData.lang) == false{
                let spanishModel = TranslateRemoteModel.translateRemoteModel(language: .spanish)
                ModelManager.modelManager().deleteDownloadedModel(spanishModel) { error in
                    guard error == nil else {return}
                    ModelManager.modelManager().download(spanishModel,conditions: ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true))
                    NotificationCenter.default.addObserver(forName: .mlkitModelDownloadDidSucceed,object: nil,queue: nil) { [] notification in
                        guard let userInfo = notification.userInfo, let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel,
                              model == spanishModel
                        else { return }
                        UserDefaults.standard.setValue(true, forKey: UserData.lang)
                    }
                }
            }
        case "French":
            if UserDefaults.standard.bool(forKey: UserData.lang) == false{
                let frenchModel = TranslateRemoteModel.translateRemoteModel(language: .french)
                ModelManager.modelManager().deleteDownloadedModel(frenchModel) { error in
                    guard error == nil else {return}
                    ModelManager.modelManager().download(frenchModel,conditions: ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true))
                    NotificationCenter.default.addObserver(forName: .mlkitModelDownloadDidSucceed,object: nil,queue: nil) { [] notification in
                        guard let userInfo = notification.userInfo, let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel,
                              model == frenchModel
                        else { return }
                        UserDefaults.standard.setValue(true, forKey: UserData.lang)
                    }
                }
            }
        default:
            if UserDefaults.standard.bool(forKey: UserData.lang) == false{
                let germanModel = TranslateRemoteModel.translateRemoteModel(language: .german)
                ModelManager.modelManager().deleteDownloadedModel(germanModel) { error in
                    guard error == nil else {return}
                    ModelManager.modelManager().download(germanModel,conditions: ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true))
                    NotificationCenter.default.addObserver(forName: .mlkitModelDownloadDidSucceed,object: nil,queue: nil) { [] notification in
                        guard let userInfo = notification.userInfo, let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel,
                              model == germanModel
                        else { return }
                        UserDefaults.standard.setValue(true, forKey: UserData.lang)
                    }
                }
            }
        }
    }
}
