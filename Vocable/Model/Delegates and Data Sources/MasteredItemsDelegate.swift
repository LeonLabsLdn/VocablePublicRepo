import UIKit

class MasteredItemsDelegate:NSObject,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MasteredItemsView.shared.pageControl.numberOfPages = UserData.masteredData.count
        return UserData.masteredData.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        MasteredItemsView.shared.pageControl.currentPage = Int(Float(MasteredItemsView.shared.collectionView!.contentOffset.x / MasteredItemsView.shared.collectionView!.frame.width).rounded())
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MasteredItemsCollectionViewCell
        cell.masteredItemsCell.ukLabel.text = UserData.masteredData[indexPath.item].components(separatedBy: "_")[0]
        cell.masteredItemsCell.itaLabel.text = UserData.masteredData[indexPath.item].components(separatedBy: "_")[1]
        cell.masteredItemsCell.pronounceLabel.text = ""
        return cell
    }
    
}
