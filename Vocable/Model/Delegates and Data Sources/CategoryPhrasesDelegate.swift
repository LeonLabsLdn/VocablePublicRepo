import Foundation
import UIKit

class CategoryPhrasesDelegate:NSObject,UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CategoryPhrasesTableViewCell
        if UserData.expandTest == true{
            UserData.expandTest = false
            if UserData.isSelected.contains(indexPath.row){
                    cell.cardView?.expandButton.image = UIImage(systemName: "chevron.down")
                    cell.cardView?.engLabelHeight.constant = 0
                    cell.cardView?.itaLabelHeight.constant = 0
                    cell.cardView?.exampleLabelTop.constant = 35
                    cell.cardView?.itaIconHeight.constant = 0
                    cell.cardView?.ukIconHeight.constant = 0
                    cell.cardView?.ukIconTop.constant = 5
                UIView.animate(withDuration: 0.4,animations: {
                    cell.cardView?.itaExample.alpha = 0
                    cell.cardView?.exampleLabel.alpha = 0
                    cell.cardView?.engExampleIcon.alpha = 0
                    cell.cardView?.itaExampleIcon.alpha = 0
                    cell.cardView?.speakerButton.alpha = 0
                })
                UserData.isSelected.remove(at: UserData.isSelected.firstIndex(of: indexPath.row)!)
            }else{
                cell.cardView?.expandButton.image = UIImage(systemName: "chevron.up")
                cell.cardView?.exampleLabelTop.constant = 61
                cell.cardView?.itaIconHeight.constant = 14
                cell.cardView?.ukIconHeight.constant = 14
                cell.cardView?.ukIconTop.constant = 16
                cell.cardView?.engLabelHeight.constant = (cell.cardView?.exampleLabel.intrinsicContentSize.height)!
                cell.cardView?.itaLabelHeight.constant = (cell.cardView?.itaExample.intrinsicContentSize.height)!
                
                UIView.animate(withDuration: 0.4,animations: {
                    cell.cardView?.itaExample.alpha = 1
                    cell.cardView?.exampleLabel.alpha = 1
                    cell.cardView?.engExampleIcon.alpha = 1
                    cell.cardView?.itaExampleIcon.alpha = 1
                    cell.cardView?.speakerButton.alpha = 1
                })
                UserData.isSelected.append(indexPath.row)
            }
            UIView.animate(withDuration: 0.2,animations: {
                tableView.beginUpdates()
                tableView.endUpdates()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhraseData.shared.engListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "phrasecell", for: indexPath) as! CategoryPhrasesTableViewCell
        let cell = customCell.cardView!
        cell.pronounceLabel.text = ""
        cell.learningIcon.image = UIImage(named: UserData.lang)
        cell.learningExampleIcon.image = UIImage(named: UserData.lang)
        cell.spinner.startAnimating()
        cell.itaExampleIcon.alpha = 1
        cell.engExampleIcon.alpha = 1
        cell.itaExample.alpha = 1
        cell.exampleLabel.alpha = 1
        if indexPath.item == 0{
            cell.cardTop.constant = 16}else{cell.cardTop.constant = 0
        }
        if indexPath.item == tableView.numberOfRows(inSection: indexPath.section) - 1 && PurchaseModel.shared.isPro == false{
            cell.cardBottom.constant = 0
        }else{
            cell.cardBottom.constant = -16
        }
        cell.engLabel.text = PhraseData.shared.engListArr[indexPath.row]
        cell.itaLabel.text = PhraseData.shared.itaListArr[indexPath.row]
//        if PhraseData.shared.pronounceListArr[indexPath.row] == ""{
            cell.pronounceHeight.constant = 0
            cell.pronounceBottom.constant = 3
            cell.cardHeight.constant = 82.33
//        }else{
//            cell.pronounceHeight.constant = 19
//            cell.pronounceBottom.constant = 11
//            cell.cardHeight.constant = 109.33
//        }
        cell.faveButton.restorationIdentifier = PhraseData.shared.rowIDListArr[indexPath.row];
        cell.exampleLabel.text = PhraseData.shared.engExpandedListArr[indexPath.row]
        cell.itaExample.text = PhraseData.shared.itaExpandedListArr[indexPath.row]
        if  UserData.isLoading.contains("\(PhraseData.shared.tablePhraseListArr[0]),\(PhraseData.shared.subPhraseListArr[0]),\(PhraseData.shared.rowIDListArr[indexPath.row])"){
            cell.faveButton.isHidden = true
            cell.spinner.isHidden = false
        }else{
            cell.spinner.isHidden = true
            cell.faveButton.isHidden = false}
        if UserData.isFave == false{
            cell.faveButton.setImage(UIImage(systemName: "\(PhraseData.shared.starListArr[indexPath.row])"), for: .normal);
        }else{
            cell.faveButton.setImage(UIImage(systemName: "star.fill"), for: .normal);
        }
            
        cell.addButton.restorationIdentifier = PhraseData.shared.rowIDListArr[indexPath.row]
        cell.addButton.accessibilityHint = "\(PhraseData.shared.engListArr[indexPath.row])"
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(selectFunc(sender:)))
        cell.expandView.addGestureRecognizer(tapGesture2)
        cell.expandView.restorationIdentifier = "\(indexPath.row)"
        cell.addButton.accessibilityIdentifier = "\(indexPath.row)"
        cell.addButton.addTarget(self, action: #selector(addToStudy(Sender:)), for: .touchUpInside)
        cell.greyView.isUserInteractionEnabled = true
        cell.greyView.restorationIdentifier = cell.itaLabel.text
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sayPhrase(sender:)))
        cell.greyView.addGestureRecognizer(tapGesture)
        cell.faveButton.addTarget(self, action: #selector(selectFave(Sender:)), for: .touchUpInside)
        cell.faveButton.accessibilityIdentifier = "\(indexPath.row)"
        if PhraseData.shared.studyingListArr.contains(PhraseData.shared.rowIDListArr[indexPath.row]) && PurchaseModel.shared.isPro == true{
            cell.addButton.setTitle("Remove from study list", for: .normal)
            cell.addButton.setImage(nil, for: .normal)
            cell.addButton.setTitleColor(#colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1), for: .normal)
            cell.addButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.addButton.backgroundColor = .white
            cell.addButton.layoutSubviews()
        }else if DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "1",tableNo: "\(PhraseData.shared.tablePhraseListArr[0])").contains("\(PhraseData.shared.engListArr[indexPath.row])") && PurchaseModel.shared.isPro == true{
            cell.addButton.setTitle("Remove from mastered list", for: .normal)
            cell.addButton.setImage(nil, for: .normal)
            cell.addButton.setTitleColor(#colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1), for: .normal)
            cell.addButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.addButton.backgroundColor = .white
            cell.addButton.layoutSubviews()
        }else{
            if PurchaseModel.shared.isPro == true{
                cell.addButton.setImage(nil, for: .normal)
            }else{
            cell.addButton.setImage(UIImage(systemName: "shield.fill"), for: .normal)
            }
            cell.addButton.setTitle("Add to study list", for: .normal)
            cell.addButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            cell.addButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            cell.addButton.backgroundColor = #colorLiteral(red: 0.2172547281, green: 0.1270844638, blue: 0.4073456824, alpha: 1)
        }
        if UserData.isSelected.contains(indexPath.row){
            cell.expandButton.image = UIImage(systemName: "chevron.up")
            cell.engLabelHeight.constant = cell.exampleLabel.intrinsicContentSize.height
            cell.itaLabelHeight.constant = cell.itaExample.intrinsicContentSize.height
            cell.exampleLabelTop.constant = 61
            cell.itaIconHeight.constant = 14
            cell.ukIconHeight.constant = 14
            cell.ukIconTop.constant = 16
            cell.itaExample.alpha = 1
            cell.exampleLabel.alpha = 1
            cell.engExampleIcon.alpha = 1
            cell.itaExampleIcon.alpha = 1
            cell.speakerButton.alpha = 1
        }else{
            cell.expandButton.image = UIImage(systemName: "chevron.down")
            cell.itaExample.alpha = 0
            cell.exampleLabel.alpha = 0
            cell.engExampleIcon.alpha = 0
            cell.itaExampleIcon.alpha = 0
            cell.speakerButton.alpha = 0
            cell.engLabelHeight.constant = 0
            cell.itaLabelHeight.constant = 0
            cell.exampleLabelTop.constant = 35
            cell.itaIconHeight.constant = 0
            cell.ukIconHeight.constant = 0
            cell.ukIconTop.constant = 5
        }
        return customCell
    }
    
    @objc func selectFunc(sender:UITapGestureRecognizer){
        Protocols.phraseDelegate!.selectFunc(pos: sender.view?.restorationIdentifier ?? "")
    }
    
    @objc func selectFave(Sender:UIButton){
        Protocols.phraseDelegate!.selectFave(row: Sender.restorationIdentifier ?? "", pos: Sender.accessibilityIdentifier ?? "")
    }
    
    @objc func addToStudy(Sender:UIButton){
        Protocols.phraseDelegate!.addToStudy(row: Sender.restorationIdentifier ?? "", pos: Sender.accessibilityIdentifier ?? "")
    }
    
    @objc func sayPhrase(sender:UITapGestureRecognizer){
        Helpers.shared.speak(phrase: "\(sender.view?.restorationIdentifier ?? "")")
    }
}
