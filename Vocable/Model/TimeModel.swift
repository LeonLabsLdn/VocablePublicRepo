import UIKit

class TimeModel{
    
    var result              : Int?
    static var pos          : Int?
    let formatter           = DateFormatter()
    let days                = ["MON","TUE","WED","THU","FRI","SAT","SUN"]
    static let shared       = TimeModel()
    
    func checkDate() -> Bool{
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let fromDates = formatter.date(from:UserStats.lastLogin) ?? Date.now
        let toDates = formatter.date(from:UserStats.now) ?? Date.now
        let str = formatter.string(from: fromDates).trunc(length: 10)
        let str1 = formatter.string(from: toDates).trunc(length: 10)
        formatter.dateFormat = "yyyy-MM-dd"
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        calendar.firstWeekday = 2
        let isSameWeek = calendar.isDate(formatter.date(from: str)!, equalTo: formatter.date(from: str1)!, toGranularity: .weekOfYear)
        result = calendar.dateComponents([.day], from: formatter.date(from: str)!, to: formatter.date(from: str1)!).day
        let dayFormat = DateFormatter()
        dayFormat.dateFormat = "E"
        TimeModel.pos = days.firstIndex(of: "\(dayFormat.string(from: formatter.date(from: str1)!).uppercased())")!
        if result == 0{
            var count = 0
            while count < TimeModel.pos!{
                if UserStats.streak[count] != "1"{
                    UserStats.streak[count] = "0"
                }
                count += 1
            }
            return true
        }else if isSameWeek == true{
            if UserStats.lives < 10{
                UserStats.lives = 10
            }
            UserStats.streak[TimeModel.pos!] = "-"
            var count = 0
            while count < TimeModel.pos!{
                if UserStats.streak[count] != "1"{
                    UserStats.streak[count] = "0"
                }
                count += 1
            }
            if result != 1{
                UserStats.streakCount = 0
            }
            UserStats.stats[0] = 0
            UserStats.stats[1] = 0
            UserStats.stats[2] = 0
            UserStats.stats[6] = 0
            PhraseData.shared.retrieveDailyPhrase()
        }else if isSameWeek == false || UserStats.streak == ["-","-","-","-","-","-","-"]{
            if UserStats.lives < 10{
                UserStats.lives = 10
            }
            if result != 1{
                UserStats.streakCount = 0
            }
            UserStats.stats = [0,0,0,0,0,0,0]
            UserStats.streak[TimeModel.pos!] = "-"
            var count = 0
            while count < TimeModel.pos!{
                UserStats.streak[count] = "0"
                count += 1
            }
            count = TimeModel.pos! + 1
            while count < 7{
                UserStats.streak[count] = "-"
                count += 1
            }
        }
        PhraseData.shared.retrieveDailyPhrase()
        return true
    }
    
    func resetStreak(){
        
    }
    
    func updateStreak(){
        if UserStats.streak[TimeModel.pos!] != "1"{
            UserStats.xp += 24
            UserStats.stats[1] = UserStats.stats[1] + 24
            UserStats.stats[4] = UserStats.stats[4] + 24
            UserStats.streak[TimeModel.pos!] = "1"
                UserStats.streakCount += 1
            var count = 0
            while count < TimeModel.pos!{
                if UserStats.streak[count] != "1"{
                    UserStats.streak[count] = "0"
                }
                count += 1
            }
            count = TimeModel.pos! + 1
            while count < 7{
                UserStats.streak[count] = "-"
                count += 1
            }
            NetworkModel.shared.updateUserData {
                value in
            }
        }
    }
}
