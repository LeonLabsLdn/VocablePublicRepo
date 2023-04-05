import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar    : UISearchBar!
    @IBOutlet weak var tableView    : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadListTableView(_:)), name: NSNotification.Name(rawValue: "reloadSearchResults"), object: nil)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_:Any) {
        view.endEditing(true)
    }
    
    @objc func removeLoading(_:Any){

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text!.count > 1{
//            data.runSearch(search: "\(searchBar.text!)")
//        }else{
//            tableView.reloadData()
//        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        if searchBar.text!.count > 1{
//            addLoading()
//            data.runSearch(search: "\(searchBar.text!)")
//        }
    }

    func addLoading(){}
    @objc func reloadListTableView(_:Any){removeLoading(self);tableView.reloadData()}
    override func viewDidAppear(_ animated: Bool) {navigationController!.tabBarItem.image = UIImage(systemName: "tray.2.fill")}
    override func viewWillDisappear(_ animated: Bool) {navigationController!.tabBarItem.image = UIImage(systemName: "tray.2")}
    @objc func selectFave (sender:UITapGestureRecognizer){}
    @objc func sayPhrase (sender:UITapGestureRecognizer){Helpers.shared.speak(phrase: "\(sender.view?.restorationIdentifier ?? "")")}
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhraseData.shared.engListArr.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 16))
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath) as! CategoryPhrasesTableViewCell
        return cell
    }
}

