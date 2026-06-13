import Foundation

extension Date {
    func dayLabel() -> String {
        if Calendar.current.isDateInToday(self) { return "Today" }
        if Calendar.current.isDateInTomorrow(self) { return "Tomorrow" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }

    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }

    var isDay: Bool {
        let h = hour
        return h >= 5 && h < 18
    }

    static func from(apiTimeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: apiTimeString)
    }

    static func from(apiDateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: apiDateString)
    }

    func hourLabel() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter.string(from: self)
    }
}
