struct UserData{
    static var offline = Bool()
    static let days = ["MON","TUE","WED","THU","FRI","SAT","SUN"]
    static var updateList:Bool?
    static var qCount:Int?
    static var proPoints = Array<Int>()
    static var isPurchasing = false
    static var deletingStudyList = Bool()
    static var userErrorData = String()
    static var logout: Bool?
    static var masteredSelected:Bool?
    static var proRemoved:Bool?
    static var expandTest:Bool?
    static var isSelected = [Int]()
    static var isFave:Bool?
    static var catPhrase:String?
    static var isLoading = [String]()
    static var masteredData = Array<String>()
    static var icons = ["basics","animals","food","travel","leisure","clothing","time","work","science","object","vocabulary","geography"]
    static var catTotals: [String] = []
    static var masteredTables:[String] = []
    static var restoreCheck:Bool?
    static var restoreCheck1:Bool?
    static var restoreCheck2:Bool?
    static var productsReturned = false
    static var imageRecognitionActive = false
    static var email:String?
    static var password:String?
    static var name = "-"
    static var id = 0
    static var vcode:String?
    static var totalRows = 0
    static var listSegue = false
    static var lang = String()
    static var loginVC = false
    static var exists:Bool?
}

class UserStats{
    static var lives = Int()
    static var now = ""
    static var lastLogin = ""
    static var xp = Int()
    static var streakCount = Int()
    static var streak = [""]
    static var stats = [Int]()
}
