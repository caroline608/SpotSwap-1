import Foundation

class DateProvider {
    //    static let manager = DateProvider()
    static let dateFormatter = DateFormatter()
    
    //    private init() {
    //        dateFormatter = DateFormatter()
    //    }
    static let expirationTime: TimeInterval = 600
    static public func currentTime() -> String {
        let date = Date()
        dateFormatter.dateFormat = "h:mm a"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    static public func yearsSince1919() -> [String]{
        let date = Date()
        dateFormatter.dateFormat = "yyyy"
        let currentYearString = dateFormatter.string(from: date)
        guard var startingYear = Int(currentYearString) else{
            return [""]
        }
        var yearsSince1919 = [String]()
        while startingYear != 1919 {
            yearsSince1919.append(String(startingYear))
            startingYear -= 1
        }
        return yearsSince1919
    }
    
    static func currentTimeSince1970()->TimeInterval{
        let date = Date()
        return date.timeIntervalSince1970
    }
    
    static func randomTimeForSpot(_ upperlimit: Int = 5) -> String {
        
        let seconds = ["05", "15", "30", "45"]
        let randomIndex = Int(arc4random_uniform(4))
        
        let randomMinute = arc4random_uniform(4) + 1
        let randomSeconds = seconds[randomIndex]
        
        let time = "\(randomMinute):\(randomSeconds)"
        return time
    }
    
    static func parseIntoSeconds(duration: String) -> TimeInterval {
        guard let numericDurationInMinutes = Double(duration) else { return 0.0 }
        let secondsInAMinute = 60.0
        let secondsInDuration = numericDurationInMinutes * secondsInAMinute
        return secondsInDuration
    }
    
    static func parseIntoFormattedString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let formattedString = String(format:"%02i:%02i", minutes, seconds)
        return formattedString
    }
}
