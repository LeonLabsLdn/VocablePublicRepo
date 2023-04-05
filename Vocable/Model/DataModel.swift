import SQLite3
import Foundation

class DataModel{
    
    static let shared = DataModel()
    
    func createTable() {
        let db = openDatabase()
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, Constants.proTableString, -1, &createTableStatement, nil) == SQLITE_OK{
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nPractice table created.")
            }else{
                print("\nContact table is not created.")
            }
        }else{
            print("\nCREATE TABLE statement is not prepared.")
        }
        sqlite3_finalize(createTableStatement)
        sqlite3_close(db)
    }
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        guard let part2DbPath = part2DbPath else {
            print("part2DbPath is nil.")
            return nil
        }
        if sqlite3_open(part2DbPath, &db) == SQLITE_OK {
            return db
        }else{
            print("Unable to open database.")
            return nil}
    }
    
    func deleteProList() -> Bool{
        let db = openDatabase()
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, Constants.deletePractice, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
            }else{
                return false
            }
        }
        sqlite3_finalize(insertStatement)
        sqlite3_close(db)
        return true
    }
    
    func deleteFromProList(PROENG: String) -> Bool{
        let db = openDatabase()
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, Constants.deleteFromStudyList, -1, &insertStatement, nil) == SQLITE_OK {
            let PROENG: NSString = PROENG as NSString
            sqlite3_bind_text(insertStatement, 1, PROENG.utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("SUCCESS")
            }else{
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nQuery is not prepared \(errorMessage)")
                return false
            }
        }
        sqlite3_finalize(insertStatement)
        sqlite3_close(db)
        return true
    }
    
    func insertProList(PROENG: String, PROITA: String, PROPRONOUNCE: String, PROENGEXAMPLE: String, PROITAEXAMPLE:String, TABLENO:String, ROWNO:String, ANSWERCOUNT:String, MASTERED:String){
        let db = openDatabase()
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, Constants.insertProStatementString, -1, &insertStatement, nil) ==
            SQLITE_OK {
            let PROENG: NSString            = PROENG as NSString
            let PROITA: NSString            = PROITA as NSString
            let PROPRONOUNCE: NSString      = PROPRONOUNCE as NSString
            let PROENGEXAMPLE: NSString     = PROENGEXAMPLE as NSString
            let PROITAEXAMPLE: NSString     = PROITAEXAMPLE as NSString
            let TABLENO: NSString           = TABLENO as NSString
            let ROWNO: NSString             = ROWNO as NSString
            let ANSWERCOUNT: NSString       = ANSWERCOUNT as NSString
            let MASTERED: NSString          = MASTERED as NSString
            let value                       = [PROENG,PROITA,PROPRONOUNCE,PROENGEXAMPLE,PROITAEXAMPLE,TABLENO,ROWNO,ANSWERCOUNT,MASTERED]
            var count                       = Int32(1)
            for v in value{sqlite3_bind_text(insertStatement, count, v.utf8String, -1, nil);count += 1}
            if sqlite3_step(insertStatement) == SQLITE_DONE {
//                print("\nSuccessfully inserted row.")
            } else {print("\nCould not insert row.")}}
        sqlite3_finalize(insertStatement);sqlite3_close(db)}
    
    func proListDataQuery(value: String, mastered:String, tableNo:String) -> Array<String>{
        var proEngArr: [String] = [];var proItaArr: [String] = [];var proPronounceArr: [String] = [];var proEngExampleArr: [String] = [];var proItaExampleArr: [String] = [];var proTableNoArr: [String] = [];var proRowNoArr: [String] = []
        var proAnswerCountArr: [String] = []
        let db = openDatabase()
        var queryStatement: OpaquePointer?
        var statement = String()
        if mastered == "0"{statement = Constants.practiceTableQuery
        }else{statement = Constants.practiceTableQueryM}
        if sqlite3_prepare_v2(db, statement, -1, &queryStatement, nil) ==
            SQLITE_OK{
            let mastered: NSString = mastered as NSString
            sqlite3_bind_text(queryStatement, 1, mastered.utf8String, -1, nil)
            if mastered == "1"{let tableNo: NSString = tableNo as NSString
                sqlite3_bind_text(queryStatement, 2, tableNo.utf8String, -1, nil)}
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let queryResultCol0 = sqlite3_column_text(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)!
                let queryResultCol2 = sqlite3_column_text(queryStatement, 2)!
                let queryResultCol3 = sqlite3_column_text(queryStatement, 3)!
                let queryResultCol4 = sqlite3_column_text(queryStatement, 4)!
                let queryResultCol5 = sqlite3_column_text(queryStatement, 5)!
                let queryResultCol6 = sqlite3_column_text(queryStatement, 6)!
                let queryResultCol7 = sqlite3_column_text(queryStatement, 7)!
                let PROENG          = String(cString: queryResultCol0!)
                let PROITA          = String(cString: queryResultCol1)
                let PROPRONOUNCE    = String(cString: queryResultCol2)
                let PROENGEXAMPLE   = String(cString: queryResultCol3)
                let PROITAEXAMPLE   = String(cString: queryResultCol4)
                let PROTABLENO      = String(cString: queryResultCol5)
                let PROROWNO        = String(cString: queryResultCol6)
                let PROANSWERCOUNT  = String(cString: queryResultCol7)
                proEngArr.append(PROENG)
                proItaArr.append(PROITA)
                proPronounceArr.append(PROPRONOUNCE)
                proEngExampleArr.append(PROENGEXAMPLE)
                proItaExampleArr.append(PROITAEXAMPLE)
                proTableNoArr.append(PROTABLENO)
                proRowNoArr.append(PROROWNO)
                proAnswerCountArr.append(PROANSWERCOUNT)}
        }else{let errorMessage = String(cString: sqlite3_errmsg(db));print("\nQuery is not prepared \(errorMessage)")}
        sqlite3_finalize(queryStatement);sqlite3_close(db)
        switch value{
        case "proEngArr": return proEngArr
        case "proItaArr": return proItaArr
        case "proPronounceArr": return proPronounceArr
        case "proEngExampleArr": return proEngExampleArr
        case "proItaExampleArr": return proItaExampleArr
        case "proTableNoArr": return proTableNoArr
        case "proRowNoArr": return proRowNoArr
            default:return proAnswerCountArr}}
}
