import UIKit
import Foundation

class SubCategoryViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var category        : String?
    var catPhrase       : String?
    var rowSelected     : Int?
    var subPos          : [Int] = []
    var isFave          : Bool?
    var catID           : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category
        self.tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        Protocols.subCategoryDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.tabBarItem.image = UIImage(systemName: "tray.2.fill")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.tabBarItem.image = UIImage(systemName: "tray.2")
    }
    
    @objc func reloadTableView (_: Any){
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let phraseView = segue.destination as? CategoryPhrasesViewController
        UserData.catPhrase = catPhrase!
        phraseView!.selectedCat = category!
        UserData.isFave = isFave
        if isFave == true{
            phraseView?.faveSubAmount = subPos.count
            phraseView?.selectedTableNumber = "\(rowSelected!)"
            phraseView?.catID = catID
        }
    }
}

extension SubCategoryViewController: UITableViewDelegate, UITableViewDataSource, SubCategoryDelegate {
    
    func popToRoot(){
        navigationController?.popToRootViewController(animated: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as! SubCategoryTableViewCell
        catPhrase = cell.subCategoryView.engLabel.text
        if isFave == true{
            catID = "\(subPos[indexPath.item])"
        }
        self.performSegue(withIdentifier: "phrase", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFave == true{
            return PhraseData.shared.faveSubcats[rowSelected!].components(separatedBy: ",").map { Int($0)!}.count
        }
        return PhraseData.shared.subCategoriesEng[PhraseData.shared.categoriesEng.firstIndex(of: category!)!].components(separatedBy: ",").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcell", for: indexPath) as! SubCategoryTableViewCell
        if isFave == true{
            subPos = PhraseData.shared.faveSubcats[rowSelected!].components(separatedBy: ",").map { Int($0)! }
            cell.subCategoryView.engLabel.text = PhraseData.shared.subCategoriesEng[PhraseData.shared.categoriesEng.firstIndex(of: category!)!].components(separatedBy: ",")[subPos[indexPath.item]]
            cell.subCategoryView.itaLabel.text = PhraseData.shared.subCategoriesTranslated[PhraseData.shared.categoriesEng.firstIndex(of: category!)!].components(separatedBy: ",")[subPos[indexPath.item]]
            return cell
        }
        cell.subCategoryView.engLabel.text = PhraseData.shared.subCategoriesEng[PhraseData.shared.categoriesEng.firstIndex(of: category!)!].components(separatedBy: ",")[indexPath.item]
        cell.subCategoryView.itaLabel.text = PhraseData.shared.subCategoriesTranslated[PhraseData.shared.categoriesEng.firstIndex(of: category!)!].components(separatedBy: ",")[indexPath.item]
        return cell
    }
}
