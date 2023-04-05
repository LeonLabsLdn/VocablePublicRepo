import UIKit

class MasteredDelegate:NSObject,UITableViewDelegate, UITableViewDataSource{
    
    var isExpanded      = [IndexPath]()
    var isSelected      = [Int]()
    var test            = false
    static let shared   = MasteredDelegate()
    
    @objc func headerSelected(sender:UITapGestureRecognizer){
        if UserData.masteredTables.count != 0{
            let value = Int("\(sender.view!.restorationIdentifier!)")
            if isSelected.contains(value!){
                isSelected.remove(at: isSelected.firstIndex(of: value!)!)
                Protocols.practiceDelegate?.masteredSectionTapped(add:false,section: value!)
            }else{
                isSelected.append(value!)
                Protocols.practiceDelegate?.masteredSectionTapped(add:true,section: value!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserData.masteredTables.count != 0{
            let cell = tableView.cellForRow(at: indexPath) as! MasteredTableViewCell
            let value = UserData.masteredTables[indexPath.section]
            if UserData.expandTest == true{
                UserData.expandTest = false
                if isExpanded.contains(indexPath){
                    tableView.beginUpdates()
                    isExpanded.remove(at: isExpanded.firstIndex(of: indexPath)!)
                    cell.mainView.exampleEngTop.constant = 0
                    cell.mainView.exampleItaTop.constant = 0
                    cell.mainView.exampleItaBottom.constant = 0
                    cell.mainView.ukExampleIconTop.constant = 0
                    cell.mainView.ukExampleIconHeight.constant = 0
                    cell.mainView.itaExampleIconTop.constant = 0
                    cell.mainView.itaExampleIconHeight.constant = 0
                    cell.mainView.exampleSpeakerButton.isHidden = true
                    cell.mainView.expandButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                    cell.mainView.exEngLabel.text = ""
                    cell.mainView.exItaLabel.text = ""
                    tableView.endUpdates()
                }else{
                    tableView.beginUpdates()
                    isExpanded.append(indexPath)
                    cell.mainView.exampleEngTop.constant = 12
                    cell.mainView.exampleItaTop.constant = 11
                    cell.mainView.exampleItaBottom.constant = 12
                    cell.mainView.ukExampleIconTop.constant = 14
                    cell.mainView.ukExampleIconHeight.constant = 14
                    cell.mainView.itaExampleIconTop.constant = 13
                    cell.mainView.itaExampleIconHeight.constant = 14
                    cell.mainView.exampleSpeakerButton.isHidden = false
                    cell.mainView.expandButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                    cell.mainView.exEngLabel.text = "\(DataModel.shared.proListDataQuery(value: "proEngExampleArr", mastered: "1",tableNo: "\(value)")[indexPath.item])"
                    cell.mainView.exItaLabel.text = "\(DataModel.shared.proListDataQuery(value: "proItaExampleArr", mastered: "1",tableNo: "\(value)")[indexPath.item])"
                    tableView.endUpdates()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserData.masteredTables.count != 0{
            if isSelected.contains(section){
                let value = UserData.masteredTables[section]
                return DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "1",tableNo: "\(value)").count
            }
            return 0
        }
        return 1
    }
    
    @objc func expandCard(sender:UIButton){
        let indexPath = IndexPath(row: Int(sender.accessibilityIdentifier!)!, section: Int(sender.restorationIdentifier!)!)
        Protocols.practiceDelegate?.masteredCellTapped(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if UserData.masteredTables.count != 0{
            let masteredHeader = MasteredSectionHeaderView()
            let tapGesture = UITapGestureRecognizer(target: self, action:#selector(headerSelected(sender:)))
            masteredHeader.restorationIdentifier = "\(section)"
            masteredHeader.addGestureRecognizer(tapGesture)
            let v  = Int("\(UserData.masteredTables[section])")
            masteredHeader.imageView.image = UIImage(named: UserData.icons[v ?? 0])
            masteredHeader.engLabel.text = PhraseData.shared.categoriesEng[v ?? 0]
            masteredHeader.itaLabel.text = PhraseData.shared.categoriesTranslated[v ?? 0]
            let value = UserData.masteredTables[section]
            masteredHeader.amountLabel.text = "\(DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "1",tableNo: "\(value)").count)"
            let position = Int("\(value)")
            let percent = Float(DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "1",tableNo: "\(value)").count) / Float(UserData.catTotals[position ?? 0])! * Float(100).rounded()
            var percentage = String()
            if percent < 1{
                percentage = "-%"
            }else{
                percentage = "\(Int(percent))%"
            }
            masteredHeader.percentageLabel.text = percentage
            masteredHeader.progressBar.progress = percent / 100
            if isSelected.contains(section){
                masteredHeader.expandImage.image = UIImage(systemName: "chevron.up")
                masteredHeader.mainView.layer.cornerRadius = 10
                masteredHeader.mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }else{
                masteredHeader.mainView.layer.cornerRadius = 10
                masteredHeader.expandImage.image = UIImage(systemName: "chevron.down")
            }
            return masteredHeader
        }
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let height = scrollView.frame.size.height + 10
//        let contentYoffset = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//        if distanceFromBottom < height {
//            if test != false{
//                Protocols.practiceDelegate?.setNavBar(isTop: true,view:"mastered")
//            }else{
//                test = true}
//        }else{
//            Protocols.practiceDelegate?.setNavBar(isTop: false,view:"mastered")
//        }
    }
    
    var cellHeights = [IndexPath: CGFloat]()

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 120
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if UserData.masteredTables.count != 0{
          return 129
        }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if UserData.masteredTables.count != 0{
            return UserData.masteredTables.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "masteredcell", for: indexPath) as! MasteredTableViewCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "emptymastered", for: indexPath) as! EmptyMasteredTableViewCell
        if UserData.masteredTables.count == 0{
            cell1.selectionStyle = .none
            cell1.backgroundColor = .clear
            cell1.contentView.backgroundColor = #colorLiteral(red: 0.9728776813, green: 0.972877562, blue: 0.9728776813, alpha: 1)
            tableView.backgroundColor = #colorLiteral(red: 0.9728776813, green: 0.972877562, blue: 0.9728776813, alpha: 1)
            return cell1
        }else{
            if isSelected.contains(indexPath.section){
                let value = UserData.masteredTables[indexPath.section]
                if indexPath.item == DataModel.shared.proListDataQuery(value: "proItaArr", mastered: "1",tableNo: "\(value)").count - 1 {
                    cell.contentView.layer.cornerRadius = 10
                    cell.contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                }else{
                    cell.contentView.layer.cornerRadius = 0
                }
            }
            cell.mainView.expandButton.addTarget(self, action: #selector(expandCard(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .white
            tableView.backgroundColor = #colorLiteral(red: 0.9728776813, green: 0.972877562, blue: 0.9728776813, alpha: 1)
            cell.mainView.expandButton.restorationIdentifier = "\(indexPath.section)"
            cell.mainView.expandButton.accessibilityIdentifier = "\(indexPath.row)"
            let value = UserData.masteredTables[indexPath.section]
            cell.mainView.engLabel.text = "\(DataModel.shared.proListDataQuery(value: "proEngArr", mastered: "1",tableNo: "\(value)")[indexPath.item])"
            cell.mainView.itaLabel.text = "\(DataModel.shared.proListDataQuery(value: "proItaArr", mastered: "1",tableNo: "\(value)")[indexPath.item])"
            cell.mainView.pronounceLabel.text = "\(DataModel.shared.proListDataQuery(value: "proPronounceArr", mastered: "1",tableNo: "\(value)")[indexPath.item])"
            var count = 0
            let bottomElements = [cell.mainView.exampleEngTop,cell.mainView.exampleItaTop,cell.mainView.exampleItaBottom,cell.mainView.ukExampleIconTop,cell.mainView.ukExampleIconHeight,cell.mainView.itaExampleIconTop,cell.mainView.itaExampleIconHeight]
            let bottomValues = [12,11,12,14,14,13,14]
            if isExpanded.contains(indexPath){
                cell.mainView.exampleSpeakerButton.isHidden = false
                cell.mainView.expandButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                for v in bottomElements{v?.constant = CGFloat(bottomValues[count]);count += 1}
                cell.mainView.exEngLabel.text = "\(DataModel.shared.proListDataQuery(value: "proEngExampleArr", mastered: "1",tableNo: "\(value)")[indexPath.item])"
                cell.mainView.exItaLabel.text = "\(DataModel.shared.proListDataQuery(value: "proItaExampleArr", mastered: "1",tableNo: "\(value)")[indexPath.item])"
            }else{
                cell.mainView.expandButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                cell.mainView.exampleSpeakerButton.isHidden = true
                for v in bottomElements{
                    v?.constant = 0
                }
                cell.mainView.exEngLabel.text = ""
                cell.mainView.exItaLabel.text = ""
            }
            return cell
        }
    }
    
}
