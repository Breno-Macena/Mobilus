

import Foundation

extension Date {
    func getDateFor(days:Int) -> Date? {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        guard let date = Calendar.current.date(from: components) else { return nil }
        return Calendar.current.date(byAdding: .day, value: days, to: date)
    }
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    private func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toBrazilianFormat() -> String {
        return toString(format: "dd/MM/yyyy")
    }
}
