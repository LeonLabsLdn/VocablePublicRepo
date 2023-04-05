import UIKit
import GoogleMobileAds

class QuizControllerViewController: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var mainView : QuizView!
    private var interstitial    : GADInterstitialAd?
    var category                : String?
    var proWordList             : [String] = []
    var proPhraseList           : [String] = []
    var proPronounceList        : [String] = []
    var progressAmount          : Int?
    var myViewHeightConstraint  : NSLayoutConstraint!
    var adError                 : Bool?
    var noLivesFlag             : Bool?
    var incorrectAnswers        = 0
    let label                   = PaddingLabel()
    var timer                   = Timer()
    let completionResultView    = CompletionResultView()
    var translateTap            = UITapGestureRecognizer()
    var phraseTap               = UITapGestureRecognizer()

    override func viewDidLoad(){
        super.viewDidLoad()

        mainView.textField.autocapitalizationType = .sentences
        Protocols.phraseDelegate?.popToRoot()
        tabBarController?.tabBar.isHidden = true
        intAd()
        LoadingAnimationView.shared.center = view.center
        view.addSubview(LoadingAnimationView.shared)
        title = category
        self.dismissKeyboard()
        mainView.textField.delegate = self
        PhraseCompletionView.shared.isHidden = true; mainView.wordMatchView.isHidden = true;
        mainView.closeButton.isHidden = false
        Protocols.quizProtocol = self
        mainView.quizButton.addTarget(self, action: #selector(quizButtonFunction), for: .touchUpInside)
        view.addSubview(completionResultView)
        myViewHeightConstraint = NSLayoutConstraint(item: completionResultView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        myViewHeightConstraint.isActive = true
        completionResultView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        completionResultView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        completionResultView.continueButton.addTarget(self, action: #selector(quizButtonFunction), for: .touchUpInside)
        completionResultView.reportButton.addTarget(self,action:#selector(reportFunction(sender:)),for: .touchUpInside)
        translateTap = UITapGestureRecognizer(target: self, action: #selector(showSolution(sender:)))
        mainView.translateQView.isUserInteractionEnabled = true
        mainView.translateQView.addGestureRecognizer(translateTap)
        completionResultView.speakerButton.addTarget(self, action: #selector(speak(sender:)), for: .touchUpInside)
        mainView.solutionView.isUserInteractionEnabled = true
        phraseTap = UITapGestureRecognizer(target: self, action: #selector(showSolution(sender:)))
        mainView.solutionView.addGestureRecognizer(phraseTap)
        label.layer.borderWidth = 1
        label.font = UIFont(name: "Roboto-Bold", size: 18)
        label.layer.borderColor = #colorLiteral(red: 0.8253167272, green: 0.8152162433, blue: 0.8284551501, alpha: 1)
        label.padding(12, 12, 18, 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = #colorLiteral(red: 0.5848218799, green: 0.5594590306, blue: 0.6033582687, alpha: 1)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        if category != "pro"{
            print(category!)
            PracticeModel.shared.retrievePracticeData(cat: category!)
        }else{
            PracticeModel.shared.retrieveDummyData(proWord: proWordList, proPhrase: proPhraseList)
        }
    }
    @objc func speak(sender:UIButton){
        Helpers.shared.speak(phrase: completionResultView.itaLabel.text ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noLivesFlag = false
        if PurchaseModel.shared.isPro == true{
            mainView.livesView.livesLabel.text = "∞"
        }else{
            mainView.livesView.livesLabel.text = "\(UserStats.lives)"
        }
        if UserStats.lives == 0 && PurchaseModel.shared.isPro != true{
            dismiss(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool){
        if noLivesFlag != true{
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc func reportFunction(sender:UIButton){
        present(AlertView.shared.returnActionSheet(question: "User ID: \(UserData.id)\nEmail: \(UserData.id)\nEng: \(completionResultView.engLabel.text!)\nIta: \(completionResultView.itaLabel.text!)\nUAnswer: \(UserDefaults.standard.string(forKey: "reportAnswer")!)"), animated: true)
    }
    
    @objc func errorDismiss(_:Any){
        PracticeModel.shared.cancel()
        present(AlertView.shared.returnPracticeError(), animated: true, completion: nil)}
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        dismiss(animated: true)
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        showCompletion()
    }
    
    //SET COMPLETE THE PHRASE ENGLISH TO BE TRANSLATED AND ANSWERS FOR COMPLETION CARD**(PRE EMPTIVELY)
    func updatePhraseView(eng:String, Ita:String){
        PhraseCompletionView.shared.qLabel.text = eng
        completionResultView.engLabel.text = eng
        completionResultView.itaLabel.text = Ita
    }
    
    func enableQuizButton(enable:Bool){
        if enable == true{mainView.quizButton.backgroundColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
            mainView.quizButton.isUserInteractionEnabled = true
        }else{
            mainView.quizButton.backgroundColor = .lightGray
            mainView.quizButton.isUserInteractionEnabled = false}
    }
    
    func setQuizData(){
        DispatchQueue.main.async{ [self] in
            var counts: [Int: Int] = [:]
            PracticeModel.shared.qCount.forEach {counts[$0, default: 0] += 1}
            UserData.qCount = (Int(counts[1] ?? 0) * 5) + (counts[2] ?? 0) + (counts[3] ?? 0)
            progressAmount = PracticeModel.shared.qCount.count
            let views = [mainView.progressBar,mainView]
            for v in views{v!.isHidden = false}
            updateQuizView()
        }
    }
    
    func updateQuizView(){
        label.layer.opacity = 0
        label.numberOfLines = 0
        DispatchQueue.main.async(execute:{ [self] in
            label.removeFromSuperview()
            if PracticeModel.shared.qCount.count != 0{
                switch PracticeModel.shared.qCount[0]{
                case 1:
                    if PracticeModel.shared.qCount.count == 1{mainView.quizButton.setTitle("Finish", for: .normal)}else{mainView.quizButton.setTitle("Continue", for: .normal)}
                    mainView.instructionLabel.text = "Match each word with its corresponding translation.."
                    mainView.instructionLabel.isHidden = false
                    if PracticeModel.shared.splitWordData() == true{
                        WordMatchCollectionView.shared.collectionView?.reloadData()
                        DispatchQueue.main.async(execute:{ [self] in LoadingAnimationView.shared.removeFromSuperview();mainView.wordMatchView.isHidden = false})
                    }
                case 2:
                    mainView.solutionView.isHidden = false
                    mainView.instructionLabel.text = "Translate the phrase.."
                    mainView.instructionLabel.isHidden = false
                    mainView.quizButton.setTitle("Check answer", for: .normal)
                    PhraseCompletionView.shared.isUserInteractionEnabled = true
                    if PracticeModel.shared.phraseCompletion() == true{
                        PhraseCompletionView.shared.qView.backgroundColor = .white;
                        updatePhraseView(eng: PracticeModel.shared.phraseArrEng.joined(separator: " "), Ita: PracticeModel.shared.phraseArrIta.joined(separator: " "))
                        PhraseCompletionView.shared.collectionView1?.reloadData()
                        PhraseCompletionView.shared.collectionView2?.reloadData()
                        DispatchQueue.main.async(execute:{ [self] in
                            LoadingAnimationView.shared.removeFromSuperview()
                            PhraseCompletionView.shared.isHidden = false
                            mainView.addSubview(label)
                            label.text = "\(completionResultView.itaLabel.text ?? "")"
                            label.leftAnchor.constraint(equalTo: PhraseCompletionView.shared.qLabel.leftAnchor).isActive = true
                            label.topAnchor.constraint(equalTo: PhraseCompletionView.shared.qLabel.bottomAnchor,constant: 8).isActive = true
                        }
        )}
                default:
                    
                    mainView.textField.isUserInteractionEnabled = true
                    mainView.instructionLabel.text = "Translate the word.."
                    mainView.instructionLabel.isHidden = false
                    mainView.quizButton.setTitle("Check answer", for: .normal)
                    if PracticeModel.shared.setupTranslate() == true{
                        updatePhraseView(eng: PracticeModel.shared.translateEng, Ita: PracticeModel.shared.translateIta)
                        let labelAtributes:[NSAttributedString.Key : Any]  = [
                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDot.union(.thick).union(.byWord).rawValue,
                            NSAttributedString.Key.underlineColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                        ]
                        mainView.translateLabel.attributedText = NSAttributedString(string: PracticeModel.shared.translateEng, attributes: labelAtributes)
                        mainView.textField.text = ""
                        mainView.translateAView.isHidden = false
                        mainView.translateQView.isHidden = false
                        mainView.textField.becomeFirstResponder()
                    }
                    DispatchQueue.main.async(execute:{ [self] in
                        LoadingAnimationView.shared.removeFromSuperview()
                        self.mainView.translateAView.isHidden = false
                        self.mainView.translateQView.isHidden = false
                        mainView.addSubview(label)
                        label.text = "\(PracticeModel.shared.translateIta)"
                        label.leftAnchor.constraint(equalTo: mainView.translateLabel.leftAnchor).isActive = true
                        label.topAnchor.constraint(equalTo: mainView.translateLabel.bottomAnchor,constant: 9).isActive = true
                    })
                }
                PracticeModel.shared.qCount.removeFirst()
                if UserStats.lives == 0 && PurchaseModel.shared.isPro != true{
                    noLivesFlag = true
                    performSegue(withIdentifier: "noLives", sender: self)
                }
            }else{
                dismiss(animated: true, completion: nil)
            }
        })
    }
    
@objc func showSolution(sender:UITapGestureRecognizer){
    timer.invalidate()
    if label.layer.opacity == 1 {
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            self.label.layer.opacity = 0
        }
    }else{
        if sender != translateTap{
            if label.frame.size.width > view.frame.size.width - PhraseCompletionView.shared.qLabel.frame.minX - 32{
                label.rightAnchor.constraint(equalTo: mainView.rightAnchor,constant: -32).isActive = true
                label.layoutIfNeeded()
                mainView.layoutIfNeeded()
            }
        }
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            self.label.layer.opacity = 1
        }
        var count = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if count == 2{
                UIView.animate(withDuration: 0.2, delay: 0.0) {
                    self.label.layer.opacity = 0
                }
                timer.invalidate()
            }else{
                count += 1
            }
        }
    }
}
    
    func setCompletionUI(result:Bool){
        if result == true{
            completionResultView.mainView.backgroundColor = #colorLiteral(red: 0.9473914504, green: 0.9987586141, blue: 0.8883878589, alpha: 1)
            completionResultView.resultLabel.text = "Correct!"
            completionResultView.resultLabel.textColor = #colorLiteral(red: 0.2705882353, green: 0.4862745098, blue: 0.003921568627, alpha: 1)
            completionResultView.layer.borderColor = #colorLiteral(red: 0.6667414308, green: 0.8228070736, blue: 0.4832466841, alpha: 1)
            //INCORRECT ANSWER
        }else{
            completionResultView.mainView.backgroundColor = #colorLiteral(red: 1, green: 0.9756459594, blue: 0.976079762, alpha: 1)
            completionResultView.resultLabel.text = "Incorrect"
            completionResultView.resultLabel.textColor = #colorLiteral(red: 0.6723505259, green: 0.1743948758, blue: 0.1729599535, alpha: 1)
            completionResultView.layer.borderColor = #colorLiteral(red: 1, green: 0.668007791, blue: 0.66681391, alpha: 1)
            if PurchaseModel.shared.isPro != true {
                updateLives()
            }
        }
    }
    
    @objc func quizButtonFunction(){
        completionResultView.reportButton.isUserInteractionEnabled = true
        //SET RESULT CONSTRAINT OUTSISE OF VISIBLE VIEW (0 TOP OF CARD/MAXY OF VC)
        myViewHeightConstraint.constant = 0
        //CHECK COMPLETE THE PHRASE QUESTION
        if mainView.quizButton.titleLabel!.text == "Check answer"{
            //check if its final q to set correct ui for completion card
            if PracticeModel.shared.qCount.count == 0{
                completionResultView.continueButton.setTitle("Finish", for: .normal)
                completionResultView.continueButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 20)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                    mainView.quizButton.setTitle("Finish", for: .normal)
                    if UserStats.lives == 0 && PurchaseModel.shared.isPro != true{
                        noLivesFlag = true
                        performSegue(withIdentifier: "noLives", sender: self)
                        return
                    }
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in mainView.quizButton.setTitle("Continue", for: .normal)}}
            //check if its translate word or translate phrase
            if mainView.translateAView.isHidden == true{
                //CORRECT ANSWER
                let answerResult = PracticeModel.shared.checkPhraseAnswer()
                setCompletionUI(result: answerResult)
                if answerResult == false && PurchaseModel.shared.isPro == false{
                    updateLives()
                }else if answerResult == true && category == "pro"{
                    UserData.proPoints.append(proPhraseList.firstIndex(of: PracticeModel.shared.phraseArr[0])!)
                }else if answerResult == false && PurchaseModel.shared.isPro == true{
                    incorrectAnswers += 1
                }
                PracticeModel.shared.phraseArr.remove(at: 0)
                //CHECK NUMBER OF QUESTION LEFT FOLLOWING THIS QUESTION TO PREPARE NEXT ACTION
            }else{
                /////check translate the word answer
                mainView.textField.isUserInteractionEnabled = false
                if PracticeModel.shared.checkTranslateAnswer(answer: mainView.textField.text ?? "",wordList: proWordList) == true{
                    if category == "pro"{
                        print(proWordList)
                        print(PracticeModel.shared.translateEng)
                        print(PracticeModel.shared.translateIta)
                        UserData.proPoints.append(proWordList.firstIndex(of: "\(PracticeModel.shared.translateEng)_\(PracticeModel.shared.translateIta)")!)
                        print(UserData.proPoints)
                    }
                    setCompletionUI(result: true)
                }else{
                    if PurchaseModel.shared.isPro != true{
                        updateLives()
                    }
                    incorrectAnswers += 1
                    setCompletionUI(result: false)
                }
            }
            //ANIMATE RESULT CARD INTO VIEW
            PhraseCompletionView.shared.isUserInteractionEnabled = false
            myViewHeightConstraint = NSLayoutConstraint(item: completionResultView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -completionResultView.frame.size.height)
            DispatchQueue.main.async {
                self.myViewHeightConstraint.isActive = true
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()})
            }
            return
        }
        //UPDATE QUIZ PROGRESS BAR (DOES NOT HAPPEN WHEN CHECKING COMPLETE THE PHRASE ABOVE, THIS IS CARRIED OUT ON CONTINUE FROM RESULT CARD)
        mainView.wordMatchView.isHidden = true
        PhraseCompletionView.shared.isHidden = true
        mainView.translateAView.isHidden = true
        mainView.translateQView.isHidden = true
        mainView.instructionLabel.isHidden = true
        mainView.solutionView.isHidden = true
        updateProgress()
        enableQuizButton(enable: false)
        //FINAL QUESTION COMPLETE UPDATE AND PRESENT RESULTS
        if mainView.quizButton.titleLabel!.text == "Finish"{
            DispatchQueue.main.asyncAfter(deadline: .now () + 0.5) { [self] in
                LoadingAnimationView.shared.center = view.center
                view.addSubview(LoadingAnimationView.shared)
                let v = [mainView.quizButton,mainView.livesView,mainView.progressBar]
                for v in v{v?.isHidden = true}
                if category != "pro"{
                    if adError != true && PurchaseModel.shared.isPro != true{
                        interstitial?.present(fromRootViewController: self)
                    }else{
                        showCompletion()
                    }
                }else{
                    var eng = Array<String>();var ita = Array<String>()
                    for words in proWordList{let string = words.components(separatedBy: "_")
                        eng.append(string[0])
                        ita.append(string[1])}
                    for correctWords in PracticeModel.shared.proCorrectArr{
                        
                        if let index = eng.firstIndex(of: correctWords) {UserData.proPoints.append(index)}
                        if let index1 = ita.firstIndex(of: correctWords) {UserData.proPoints.append(index1)}
                    }
                    showCompletion()
                }
            }
            return
            //CONTINUE QUIZ (SETUP NEXT QUESTION)
        }else{
            updateQuizView()}
    }
    
    func updateLives(){
        mainView.livesView.livesLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.3 ,animations: { [self] in
            mainView.livesView.livesLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            mainView.livesView.livesLabel.text = "\(UserStats.lives)"})
        NetworkModel.shared.updateUserData {_ in}
    }
    
    func updateProgress(){
        let progress = mainView.progressBar.progress + (1 / Float(progressAmount!))
        UIView.animate(withDuration: 0.5) {self.mainView.progressBar.setProgress(progress, animated: true)}}
    
    func intAd (){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-1067528508711342/1010035586",request: request,completionHandler: { [self] ad, error in
            if let error = error {
                adError = true
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self})
    }
    
    func showCompletion(){
        
        //get time related points if available
        TimeModel.shared.updateStreak()
        
        //update daily and weekly quiz count
        UserStats.stats[0] += 1
        UserStats.stats[3] += 1
        
        //check for possible daily goal points
        switch UserStats.stats[0]{
        case 1:
            UserStats.xp += 20
            UserStats.stats[1] += 20
            UserStats.stats[4] += 20
        case 3:
            UserStats.xp += 50
            UserStats.stats[1] += 50
            UserStats.stats[4] += 50
        case 5:
            UserStats.xp += 70
            UserStats.stats[1] += 70
            UserStats.stats[4] += 70
        default:break
        }
        UserStats.stats[1] += PracticeModel.shared.correctAnswers
        UserStats.stats[4] += PracticeModel.shared.correctAnswers
        UserStats.xp = UserStats.xp + PracticeModel.shared.correctAnswers
    
        NetworkModel.shared.updateProData(){ [self] done in
            var data = [String]()
            for i in UserData.masteredData{
                let pos = Int(i)
                data.append("\(proWordList[pos!])_\(proPronounceList[pos!])")
            }
            UserData.masteredData = data
            NetworkModel.shared.retrieveProPractice()
            let completionView = CompletionView()
            if PurchaseModel.shared.isPro == true{
                completionView.livesLabel.text = "\(incorrectAnswers)"
                completionView.livesLostTitleLabel.text = "Mistakes made"
                completionView.heartWidthConstraint.constant = 0
                completionView.heartPaddingConstraint.constant = 0
                
            }else{
                completionView.livesLabel.text = "\(PracticeModel.shared.livesLost)"
            }
            view.addSubview(completionView)
            view.backgroundColor = #colorLiteral(red: 0.9523938298, green: 0.9500921369, blue: 1, alpha: 1)
            completionView.translatesAutoresizingMaskIntoConstraints = false
            mainView.isHidden = true
            completionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            completionView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16).isActive = true
            completionView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -16).isActive = true
            NetworkModel.shared.updateUserData { value in
            }
        }
    }
}

extension QuizControllerViewController:QuizProtocol,UITextFieldDelegate{
    func disableReport(){
        completionResultView.reportButton.isUserInteractionEnabled = false
        completionResultView.reportButton.setTitleColor(.gray, for: .normal)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if mainView.textField.isFirstResponder == true {
        mainView.textField.placeholder = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        mainView.textField.placeholder = "Type here.."
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if mainView.textField.text != ""{
            enableQuizButton(enable: true)
        }else{
            enableQuizButton(enable: false)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    func report() {
        present(AlertView.shared.returnProblemAlert(eng: completionResultView.engLabel.text ?? "E", ita: completionResultView.itaLabel.text ?? "E"), animated: true, completion: nil)
    }
    func reportSent() {
        present(AlertView.shared.returnSentAlert(), animated: true, completion: nil)
    }
    func incorrectAnswer() {
        if PurchaseModel.shared.isPro != true{
            updateLives()
            if UserStats.lives == 0{
                noLivesFlag = true
                performSegue(withIdentifier: "noLives", sender: self)
            }
        }else{
            incorrectAnswers += 1
        }
    }
    func startQuiz(){
        setQuizData()
    }
    func dismissPractice() {
        errorDismiss(self)
    }
    func updateButton(enable: Bool) {
        enableQuizButton(enable:enable)
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    func quitQuiz() {
        if mainView.progressBar.progress == 0.0{
            dismiss(animated: true)
        }else{
            present(AlertView.shared.closeQuizAlert(),animated: true,completion: nil)
        }
    }
    func close(){
        dismiss(animated: true)
    }
}
