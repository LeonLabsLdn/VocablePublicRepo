import UIKit

class QuizDelegate:NSObject,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    static let shared = QuizDelegate()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//PHRASE COMPLETION CV
        if collectionView == PhraseCompletionView.shared.collectionView2{
            if PracticeModel.shared.colorArr[indexPath.item] == #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1){
                return
            }
            PracticeModel.shared.phraseAnswerArr.append(PracticeModel.shared.phraseCollectionData[indexPath.item])
            PracticeModel.shared.colorArr[indexPath.item] = #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1)
            let cell = collectionView.cellForItem(at: indexPath) as! CompletePhraseCell
            cell.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1)
            DispatchQueue.main.async {
                UIView.performWithoutAnimation {
                    PhraseCompletionView.shared.collectionView2?.reloadItems(at: [indexPath])
                }
                PhraseCompletionView.shared.collectionView1?.reloadData()
                Protocols.quizProtocol?.updateButton(enable: true)
            }
        }else if collectionView == PhraseCompletionView.shared.collectionView1{
            let colourPosition = PracticeModel.shared.phraseCollectionData.firstIndex(of: "\(PracticeModel.shared.phraseAnswerArr[indexPath.item])")
            PracticeModel.shared.phraseAnswerArr.remove(at: indexPath.item)
            if PracticeModel.shared.phraseAnswerArr.count == 0{
                Protocols.quizProtocol?.updateButton(enable: false)
            }
            PracticeModel.shared.colorArr[colourPosition!] = .black
            DispatchQueue.main.async {
                PhraseCompletionView.shared.collectionView2?.reloadData()
                PhraseCompletionView.shared.collectionView1?.reloadItems(at: [indexPath])
            }
            
//WORDMATCH CV
        }else if collectionView == WordMatchCollectionView.shared.collectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! WordMatchCollectionViewCell
            if PracticeModel.shared.selectedWordIP != nil && PracticeModel.shared.answerWordIP == nil && cell.backgroundColor != #colorLiteral(red: 0.5165752172, green: 0.6737377644, blue: 0.08136635274, alpha: 1){
                let selectedCell = collectionView.cellForItem(at: PracticeModel.shared.selectedWordIP!) as! WordMatchCollectionViewCell
                //Disallow selection from same langauge:
                if PracticeModel.shared.engAnswers.contains(cell.answerLabel.text!) && PracticeModel.shared.engAnswers.contains(PracticeModel.shared.selectedWord) && cell.answerLabel.text != PracticeModel.shared.selectedWord || PracticeModel.shared.itaAnswers.contains(cell.answerLabel.text!) && PracticeModel.shared.itaAnswers.contains(PracticeModel.shared.selectedWord) && cell.answerLabel.text != PracticeModel.shared.selectedWord{
                    return
                }
                //Deselect same cell selected twice:
                if PracticeModel.shared.selectedWordIP == indexPath{
                    cell.backgroundColor = .white
                    cell.layer.borderWidth = 4
                    cell.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1)
                    PracticeModel.shared.selectedWord = ""
                    PracticeModel.shared.selectedWordIP = nil
                    return
                }
                //Check an answer:
                PracticeModel.shared.answerWordIP = indexPath
                PracticeModel.shared.answerWord = cell.answerLabel.text!
                //Answer is correct:
                if PracticeModel.shared.checkWordMatchAnswer() == true{
                    cell.isUserInteractionEnabled = false
                    selectedCell.isUserInteractionEnabled = false
                    cell.backgroundColor = #colorLiteral(red: 0.9473914504, green: 0.9987586141, blue: 0.8883878589, alpha: 1)
                    selectedCell.backgroundColor = #colorLiteral(red: 0.9473914504, green: 0.9987586141, blue: 0.8883878589, alpha: 1)
                    cell.layer.borderColor = #colorLiteral(red: 0.2676271796, green: 0.4900760055, blue: 0.001995741623, alpha: 1)
                    cell.layer.borderWidth = 4
                    selectedCell.layer.borderColor = #colorLiteral(red: 0.2676271796, green: 0.4900760055, blue: 0.001995741623, alpha: 1)
                    selectedCell.layer.borderWidth = 4
                    DispatchQueue.main.asyncAfter(deadline: .now () + 0.25){
                        cell.animateBackgroundColor(toColor: #colorLiteral(red: 0.9725491405, green: 0.9725491405, blue: 0.9725490212, alpha: 1), duration: 0.25)
                        selectedCell.animateBackgroundColor(toColor: #colorLiteral(red: 0.9725491405, green: 0.9725491405, blue: 0.9725490212, alpha: 1), duration: 0.25)
                        cell.animateBorderColor(toColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039216399, alpha: 1), duration: 0.25)
                        selectedCell.animateBorderColor(toColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039216399, alpha: 1), duration: 0.25)
                        cell.answerLabel.animateTextColor(toColor: #colorLiteral(red: 0.4549018741, green: 0.4549018741, blue: 0.4549018741, alpha: 1), duration: 0.25)
                        selectedCell.answerLabel.animateTextColor(toColor: #colorLiteral(red: 0.4549018741, green: 0.4549018741, blue: 0.4549018741, alpha: 1), duration: 0.25)
                    }
                    //Answer is incorrect:
                }else{
                    Protocols.quizProtocol?.incorrectAnswer()
                    cell.backgroundColor = #colorLiteral(red: 0.9997925162, green: 0.8821271658, blue: 0.8799641728, alpha: 1)
                    selectedCell.backgroundColor = #colorLiteral(red: 0.9997925162, green: 0.8821271658, blue: 0.8799641728, alpha: 1)
                    cell.layer.borderColor = #colorLiteral(red: 0.9997962117, green: 0.4013226032, blue: 0.3988559246, alpha: 1)
                    cell.layer.borderWidth = 4
                    selectedCell.layer.borderColor = #colorLiteral(red: 0.9997962117, green: 0.4013226032, blue: 0.3988559246, alpha: 1)
                    selectedCell.layer.borderWidth = 4
                    DispatchQueue.main.asyncAfter(deadline: .now () + 0.25){
                        cell.animateBackgroundColor(toColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), duration: 0.25)
                        selectedCell.animateBackgroundColor(toColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), duration: 0.25)
                        cell.animateBorderColor(toColor: #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1), duration: 0.25)
                        selectedCell.animateBorderColor(toColor: #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1), duration: 0.25)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now () + 0.25){
                    if PracticeModel.shared.wordAnswerCount == 5{
                        PracticeModel.shared.wordAnswerCount = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                            Protocols.quizProtocol?.updateButton(enable: true)
                        }
                    }
                    return
                }
                //First selection:
            }else if PracticeModel.shared.selectedWordIP != indexPath{
                cell.backgroundColor = #colorLiteral(red: 0.954025209, green: 0.9482728839, blue: 1, alpha: 1)
                cell.layer.borderColor = #colorLiteral(red: 0.3350995779, green: 0.2774070501, blue: 0.4716001153, alpha: 1)
                cell.layer.borderWidth = 4
                PracticeModel.shared.selectedWordIP = indexPath
                PracticeModel.shared.selectedWord = cell.answerLabel.text!
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case PhraseCompletionView.shared.collectionView1:
            return PracticeModel.shared.phraseAnswerArr.count
        case PhraseCompletionView.shared.collectionView2:
            return PracticeModel.shared.phraseCollectionData.count
        case WordMatchCollectionView.shared.collectionView:
            return PracticeModel.shared.wordsArr.count
        default: return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == PhraseCompletionView.shared.collectionView1{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "completioncell", for: indexPath) as! CompletePhraseCell
            cell1.label.text = PracticeModel.shared.phraseAnswerArr[indexPath.item]
            return cell1
        }else if collectionView == PhraseCompletionView.shared.collectionView2{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "completioncell", for: indexPath) as! CompletePhraseCell
            cell1.label.textColor = PracticeModel.shared.colorArr[indexPath.item]
            if cell1.label.textColor != #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1){
                cell1.backgroundColor = .white
            }else{
                cell1.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1)
            }
            cell1.label.text =  PracticeModel.shared.phraseCollectionData[indexPath.item]
            return cell1
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WordMatchCollectionViewCell
        cell.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1)
        cell.layer.borderWidth = 4
        cell.answerLabel.text = PracticeModel.shared.wordsArr[indexPath.item]
        cell.answerLabel.textColor = .black
        cell.backgroundColor = .white
        cell.isUserInteractionEnabled = true
        return cell
    }

}
