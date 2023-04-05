import UIKit

class ProPracticeDelegate: NSObject, UITableViewDelegate, UITableViewDataSource{
    

    static let shared   = ProPracticeDelegate()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "0",tableNo: "").count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "0",tableNo: "").count != 0{
            if indexPath.item == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "phrasecellstart", for: indexPath) as! StartTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "phrasecellcontent", for: indexPath) as! ProContentTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.mainView.pronounceLabel.text = ""
                cell.mainView.learningIcon.image = UIImage(named: UserData.lang)
                cell.mainView.exampleLearningIcon.image = UIImage(named: UserData.lang)
                cell.mainView.engLabel.text = "\(DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "0", tableNo: "")[indexPath.item - 1])"
                cell.mainView.itaLabel.text = "\(DataModel.shared.proListDataQuery(value: "proItaArr", mastered: "0", tableNo: "")[indexPath.item - 1])"
                cell.mainView.exEngLabel.text = "\(DataModel.shared.proListDataQuery(value: "proEngExampleArr", mastered: "0", tableNo: "")[indexPath.item - 1])"
                cell.mainView.exItaLabel.text = "\(DataModel.shared.proListDataQuery(value: "proItaExampleArr", mastered: "0", tableNo: "")[indexPath.item - 1])"
                cell.mainView.pronounceLabel.text = "\(DataModel.shared.proListDataQuery(value: "proPronounceArr", mastered: "0", tableNo: "")[indexPath.item - 1])"
                cell.mainView.removeButton.restorationIdentifier = "\(DataModel.shared.proListDataQuery(value: "proTableNoArr", mastered: "0", tableNo: "")[indexPath.item - 1])"
                cell.mainView.removeButton.accessibilityIdentifier = "\(DataModel.shared.proListDataQuery(value: "proRowNoArr", mastered: "0", tableNo: "")[indexPath.item - 1])"
                cell.mainView.removeButton.accessibilityHint = "\(DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "0", tableNo: "")[indexPath.item - 1])"
                cell.mainView.practiceLabel.text = "Practiced correctly \(DataModel.shared.proListDataQuery(value: "amountcount", mastered: "0", tableNo: "")[indexPath.item - 1])/5"
                cell.mainView.removeButton.addTarget(self, action: #selector(removeProCard(sender:)), for: .touchUpInside)
                cell.layoutIfNeeded()
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "emptylistcell", for: indexPath) as! EmptyListTableViewCell;cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    @objc func removeProCard(sender: UIButton){
        Helpers.shared.impactFeedbackGenerator.medium.prepare()
        Helpers.shared.impactFeedbackGenerator.medium.impactOccurred()
        Protocols.practiceDelegate?.addLoading()
        Protocols.phraseDelegate?.showLoading()
        NetworkModel.shared.updatePracticeList(row: "\(sender.accessibilityIdentifier!)", table: "\(sender.restorationIdentifier!)", refreshData: false){ value in
            if value == true{
                UserData.deletingStudyList = true
                if UserData.deletingStudyList == true{
                    Protocols.phraseDelegate?.showLoading()
                }
                if DataModel.shared.deleteFromProList(PROENG: "\(sender.accessibilityHint!)") == true{
                    UserData.proRemoved = true
                    Protocols.practiceDelegate?.updatePracticeTV()
                    Protocols.practiceDelegate?.updatePStat()
                    Protocols.phraseDelegate?.retrieveData()
                }
            }
            Protocols.practiceDelegate?.removeLoading()
        }
    }
    
}

