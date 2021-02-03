

import Foundation

extension DateFormatter {
  static let webserviceDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale =  Locale(identifier: "pt_BR")
    return formatter
  }()
}
