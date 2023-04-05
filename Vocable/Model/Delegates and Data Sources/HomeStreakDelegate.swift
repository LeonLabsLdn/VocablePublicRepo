import UIKit

class HomeStreakDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    static let shared = HomeStreakDelegate()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let screenWidth = UIScreen.main.bounds.size.width
        let inset = (screenWidth - 355) / 2
        return UIEdgeInsets(top: 13, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "streakCell", for: indexPath) as! HomeStreakCollectionViewCell
        cell.roundView.layer.cornerRadius = 20
        cell.roundView.removeLayer(layerName: "dotted")
        cell.dayLabel.text = UserData.days[indexPath.item]
        cell.dayLabel.font = UIFont(name: "Roboto-Bold", size: 10)
        cell.pointsLabel.font = UIFont(name: "Roboto-Bold", size: 13)
        cell.dayLabel.textAlignment = .center
        cell.pointsLabel.textAlignment = .center
        switch UserStats.streak[indexPath.item]{
        case "0":
            cell.roundView.backgroundColor = .clear
            cell.roundView.addDashedBorder(width: 2)
            cell.pointsLabel.text = "-"
            cell.dailyStreakImage.image = UIImage(systemName: "xmark")
            cell.dailyStreakImage.tintColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
            cell.pointsLabel.text = "0xp"
            cell.pointsLabel.textColor = .white
            cell.dayLabel.textColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
        case "1":
            cell.roundView.backgroundColor = .white
            cell.pointsLabel.textColor = .white
            cell.dayLabel.textColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
            cell.dailyStreakImage.image = UIImage(systemName: "checkmark")
            cell.dailyStreakImage.tintColor = #colorLiteral(red: 0.2172500789, green: 0.127109915, blue: 0.4073011875, alpha: 1)
            cell.pointsLabel.text = "24xp"
        case"-":
            cell.roundView.addDashedBorder(width: 1)
            cell.roundView.backgroundColor = .clear
            cell.dailyStreakImage.image = nil
            cell.dayLabel.textColor = .white
            cell.pointsLabel.textColor = .white
            cell.dailyStreakImage.image = UIImage(systemName: "minus")
            cell.dailyStreakImage.tintColor = .white
            cell.pointsLabel.text = "-"
        default:break
        }
        return cell
    }
    
}
