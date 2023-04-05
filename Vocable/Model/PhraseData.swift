import Alamofire

class PhraseData{
    
    static let shared       = PhraseData()
    
    var engListArr                  : [String] = []
    var itaListArr                  : [String] = []
    var pronounceListArr            : [String] = []
    var rowIDListArr                : [String] = []
    var tablePhraseListArr          : [String] = []
    var subPhraseListArr            : [String] = []
    var starListArr                 : [String] = []
    var studyingListArr             : [String] = []
    var engExpandedListArr          : [String] = []
    var itaExpandedListArr          : [String] = []
    var categoriesEng               : [String] = []
    var categoriesTranslated        : [String] = []
    var subCategoriesEng            : [String] = []
    var subCategoriesTranslated     : [String] = []
    var faveTables                  : [String] = []
    var faveSubcats                 : [String] = []
    var catID                       : Int?
    
    func retrieveData(completion: @escaping (Bool) -> ()){
        let parameters: Parameters=["key":Constants.key,"id":"\(UserData.id)","lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)getCategories.php", method: .post, parameters: parameters).responseDecodable(of:Array<Array<String>>.self) { [self]
            response in
            switch response.result {
            case.success(let value):
                print(value)
                categoriesEng               = value[0]
                subCategoriesEng            = value[1]
                categoriesTranslated        = value[2]
                subCategoriesTranslated     = value[3]
                faveTables                  = value[4]
                faveSubcats                 = value[5]
                if faveTables.count == 1 && faveTables[0] == ""{
                    faveTables.remove(at: 0)
                }
                Protocols.homeDelegate?.updateHomeQuiz()
                Protocols.categoriesDelegate?.reloadCatTableView()
                Protocols.practiceDelegate?.updatePracticeTV()
                completion(true)
            case .failure(let error):
                print("this is the errorrrrrrr\(error)")
            }
        }
    }
    
    func retrieveCategoryList(subCat: String, tableName: String){
        print(tableName)
        print(subCat)
        let parameters: Parameters=["subCat":"\(subCat)","tableName":"\(tableName)","id":"\(UserData.id)","key":Constants.key,"tableID":"\(PhraseData.shared.catID!)","lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)phraseList.php", method: .post, parameters: parameters).responseDecodable(of: Array<Array<String>>.self) { [self]
            response in
            switch response.result {
            case.success(let value):
                engListArr          = value[0]
                itaListArr          = value[1]
                pronounceListArr    = value[2]
                starListArr         = value[3]
                rowIDListArr        = value[4]
                tablePhraseListArr  = value[5]
                subPhraseListArr    = value[6]
                engExpandedListArr  = value[7]
                itaExpandedListArr  = value[8]
                studyingListArr     = value[9]
                Protocols.phraseDelegate?.updatePhraseList()
                case .failure(let error):print(error)
            }
        }
    }
    
    func retrieveFaveCategoryList(sub: String, tableName: String, table: String){
        let parameters: Parameters=["sub":"\(sub)","tableName":"\(tableName)","table":"\(table)","id":"\(UserData.id)","key":Constants.key,"tableID":"\(PhraseData.shared.catID!)","lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)getFavePhraseList.php", method: .post, parameters: parameters).responseDecodable(of:Array<Array<String>>.self) { [self]
            response in
            switch response.result {
            case.success(let value):
                engListArr          = value[0]
                itaListArr          = value[1]
                pronounceListArr    = value[2]
                rowIDListArr        = value[3]
                tablePhraseListArr  = value[4]
                subPhraseListArr    = value[5]
                engExpandedListArr  = value[6]
                itaExpandedListArr  = value[7]
                studyingListArr     = value[8]
                Protocols.phraseDelegate?.updatePhraseList()
            case .failure(let error):
                print("this is fave cat list error \(error)")
                Protocols.phraseDelegate?.popToRoot()
            }
        }
    }
    
    func retrieveDailyPhrase(){
        let parameters: Parameters=["key":Constants.key,"lang":UserData.lang]
        AF.request("\(Constants.scriptAddress)newphrase.php", method: .post, parameters: parameters).responseDecodable(of: Dictionary<String, String>.self){
            response in
            switch response.result {
            case.success(let value):
                print(value)
                print(value)
                print(value)
                print(value)
                UserDefaults.standard.setValue("\(value["english"] ?? "")", forKey: "dEnglish")
                UserDefaults.standard.setValue("\(value["translation"] ?? "")", forKey: "translation")
                UserDefaults.standard.setValue("\(value["englishexample"] ?? "")", forKey: "dEngExample")
                UserDefaults.standard.setValue("\(value["exampleTranslated"] ?? "")", forKey: "dItaExample")
                UserDefaults.standard.setValue("\(value["pronounciation"] ?? "")", forKey: "dPronounciation")
                UserDefaults.standard.setValue("\(value["tableNo"] ?? "")", forKey: "dTableNo")
                UserDefaults.standard.setValue("\(value["id"] ?? "")", forKey: "dID")
                UserDefaults.standard.setValue("\(value["catNo"] ?? "")", forKey: "dCatNo")
                Protocols.homeDelegate?.updateDaily()
                case .failure(let error):
                print("daily error\(error)")
                print("daily error\(error)")
                print("daily error\(error)")
                print("daily error\(error)")
            }
        }
    }
}

