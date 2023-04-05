import Alamofire

class PracticeModel{
    
    static let shared           = PracticeModel()
    var colorArr                : [UIColor] = []
    var wordsData               : [String] = []
    var phraseArr               : [String] = []
    var wordsArr                : [String] = []
    var engAnswers              : [String] = []
    var itaAnswers              : [String] = []
    var wrongAnswers            : [String] = []
    var phraseArrEng            : [String] = []
    var phraseArrIta            : [String] = []
    var phraseCollectionData    : [String] = []
    var phraseAnswerArr         : [String] = []
    var proCorrectArr           : [String] = []
    var dummyData               : [String] = []
    var translateWords          : [String] = []
    var qCount                  : [Int] = []
    var selectedWordIP          : IndexPath?
    var answerWordIP            : IndexPath?
    var correctAnswers          = 0
    var livesLost               = 0
    var wordAnswerCount         = 0
    var selectedWord            = ""
    var answerWord              = ""
    var translateEng            = ""
    var translateIta            = ""
    
    func retrievePracticeData(cat: String){
        let parameters: Parameters=["key":Constants.key,"cat":cat,"lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)getPracticeData.php", method: .post, parameters: parameters).responseDecodable(of:Array<Array<String>>.self) { [self]
            response in
            switch response.result {
            case.success(let value):
                print(value)
                dummyData = value[2]
                setupQuiz(words: value[0].shuffled(), phrases: value[1].shuffled())
            case.failure(let error):
                Protocols.quizProtocol?.dismissPractice()
                print("this is the errorrr \(error)")
            }
        }
    }
    
    func retrieveDummyData(proWord:[String],proPhrase:[String]){
        let parameters:  Parameters=["lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)getDummyData.php",method: .post,parameters: parameters).responseDecodable(of:Array<String>.self) { [self]
            response in
            switch response.result {
            case.success(let value):
                dummyData = value
                print("this is dummy data\(dummyData)")
                setupQuiz(words: proWord.shuffled(), phrases: proPhrase.shuffled())
                case.failure(let error):
                Protocols.quizProtocol?.dismissPractice()
                print("\(error)")
            }
        }
    }
    
    func setupQuiz(words:[String],phrases:[String]){
        resetDataValues()
        wordsData = words
        phraseArr = phrases
        translateWords = words
        if wordsData.count < 5 {
            for _ in phraseArr{
            qCount.append(2)
            qCount.append(3)
            }
            wordsData.shuffle()
            qCount.shuffle()
            Protocols.quizProtocol?.startQuiz()
        }else{
            qCount.append(1)
            var count = 0
            while true{
                //need to account for pro word match question to allow for more word match qs in normal quiz
                if count == 2{
                    break
                }else{
                    qCount.append(3)
                    count += 1
                }
            }
            phraseArr = Array(phraseArr[0 ..< 3])
            for _ in phraseArr{
                qCount.append(2)
            }
            qCount.shuffle()
            Protocols.quizProtocol?.startQuiz()
        }
    }
    
    func resetDataValues(){
        wordAnswerCount = 0
        selectedWordIP = nil
        answerWordIP = nil
        answerWord = ""
        selectedWord = ""
        correctAnswers = 0
        livesLost = 0
        qCount.removeAll()
        wordsData.removeAll()
        phraseArr.removeAll()
        wordsArr.removeAll()
        wrongAnswers.removeAll()
        proCorrectArr.removeAll()
        UserData.proPoints.removeAll()
        translateWords.removeAll()
    }
    
    func splitWordData() -> Bool{
        engAnswers.removeAll()
        itaAnswers.removeAll()
        wordsArr.removeAll()
        var count = 0
        for values in wordsData{
            let text = "\(values)".components(separatedBy: "_")
            engAnswers.append(text[0])
            itaAnswers.append(text[1])
            wordsData.remove(at: 0)
            count += 1
            if count == 5{
                var engShuffle = engAnswers.shuffled()
                var itaShuffle = itaAnswers.shuffled()
                for _ in engShuffle{
                    self.wordsArr.append(engShuffle[0])
                    self.wordsArr.append(itaShuffle[0])
                    engShuffle.remove(at: 0)
                    itaShuffle.remove(at: 0)
                }
                return true
            }
        }
        return true
    }
    
    func setupTranslate() -> Bool{
        let words = "\(translateWords[0])".components(separatedBy: "_")
        translateEng = words[0]
        translateIta = words[1]
        translateWords.remove(at: 0)
        return true
    }
    
    func checkWordMatchAnswer() -> Bool{
        let indexOfAnswer:Int?
        let indexOfSelected:Int?
        if engAnswers.contains(answerWord) == true{
            indexOfAnswer = engAnswers.firstIndex(of: answerWord)
            indexOfSelected = itaAnswers.firstIndex(of: selectedWord)
        }else{
            indexOfAnswer = itaAnswers.firstIndex(of: answerWord)
            indexOfSelected = engAnswers.firstIndex(of: selectedWord)
        }
        if indexOfAnswer == indexOfSelected{
            if wrongAnswers.contains(answerWord) == false{
                correctAnswers += 1
                proCorrectArr.append(answerWord)
            }
            resetWordMatch()
            wordAnswerCount += 1
            return true
        }else{
            if wrongAnswers.contains(answerWord) != true{
                wrongAnswers.append(answerWord)
            }
            if wrongAnswers.contains(selectedWord) != true{
                wrongAnswers.append(selectedWord)
            }
            var indexOfOpposite: Int?;var indexOfOpposite2: Int?
            if engAnswers.contains(answerWord) == true{
                indexOfOpposite = engAnswers.firstIndex(of: answerWord)
                indexOfOpposite2 = itaAnswers.firstIndex(of: selectedWord)
                if wrongAnswers.contains(itaAnswers[indexOfOpposite!]) != true{
                    wrongAnswers.append(itaAnswers[indexOfOpposite!])
                }
                if wrongAnswers.contains(engAnswers[indexOfOpposite2!]) != true{
                    wrongAnswers.append(engAnswers[indexOfOpposite2!])
                }
            }else{
                indexOfOpposite = itaAnswers.firstIndex(of: answerWord)
                indexOfOpposite2 = engAnswers.firstIndex(of: selectedWord)
                
                if wrongAnswers.contains(engAnswers[indexOfOpposite!]) != true{
                    wrongAnswers.append(engAnswers[indexOfOpposite!])
                }
                if wrongAnswers.contains(itaAnswers[indexOfOpposite2!]) != true{
                    wrongAnswers.append(itaAnswers[indexOfOpposite2!])
                }
            }
            resetWordMatch()
            if UserStats.lives != 0 && PurchaseModel.shared.isPro != true{
                UserStats.lives = UserStats.lives - 1
                livesLost += 1
            }
            return false
        }
    }
    
    func resetWordMatch(){
        selectedWordIP = nil
        answerWordIP = nil
        answerWord = ""
        selectedWord = ""
    }
    
    func checkTranslateAnswer(answer:String,wordList:[String] = []) -> Bool{
        if answer.lowercased().replacingOccurrences(of: " ", with: "") == PracticeModel.shared.translateIta.lowercased().replacingOccurrences(of: " ", with: ""){
            correctAnswers += 1
            return true
        }
        if UserStats.lives != 0 && PurchaseModel.shared.isPro != true{
            UserStats.lives = UserStats.lives - 1
            livesLost += 1
        }
        return false
    }
    
    func checkPhraseAnswer() -> Bool{
        UserDefaults.standard.setValue("\(phraseAnswerArr)", forKey: "reportAnswer")
        if ("\(phraseAnswerArr)".caseInsensitiveCompare("\(phraseArrIta)") == .orderedSame){
            correctAnswers += 1
            return true
        }
        if UserStats.lives != 0 && PurchaseModel.shared.isPro != true{
            UserStats.lives = UserStats.lives - 1
            livesLost += 1
        }
        return false
    }
    
    func phraseCompletion () -> Bool{
        phraseArrEng.removeAll()
        phraseArrIta.removeAll()
        phraseCollectionData.removeAll()
        phraseAnswerArr.removeAll()
        colorArr.removeAll()
        let p = phraseArr[0].components(separatedBy: "_")
        phraseArrEng = p[0].components(separatedBy: " ")
        phraseArrIta = p[1].components(separatedBy: " ")
        phraseCollectionData = p[1].components(separatedBy: " ")
        dummyData.shuffle()
        var count = 0
        for _ in phraseCollectionData{
            phraseCollectionData.append(dummyData[count].lowercased())
            count += 1
            if count == 2{
                break
            }
        }
        phraseCollectionData.shuffle()
        for _ in  phraseCollectionData{colorArr.append(.black)}
        return true
    }
    
    func cancel(){
        AF.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }

}
