import UIKit

class HomePracticeDelegate:NSObject,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    static let shared = HomePracticeDelegate()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {let cell = collectionView.cellForItem(at: indexPath) as! PracticeCell
        if cell.ukLabel.text != "-"{
            Protocols.homeDelegate?.startQuiz(cat: "\(cell.ukLabel.text!)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PracticeCell
        let catsEng = PhraseData.shared.categoriesEng
        let catsIta = PhraseData.shared.categoriesTranslated
        cell.itaIcon.image = UIImage(named: UserData.lang)
        if catsEng.count < 12{
            cell.itaLabel.text = "-"
            cell.ukLabel.text = "-"
        }else{
            cell.itaLabel.text = "\(catsIta[indexPath.item])"
            cell.ukLabel.text = "\(catsEng[indexPath.item])"
        }
        cell.icon.image = UIImage(named: UserData.icons[indexPath.item])
        return cell
    }
    
}
