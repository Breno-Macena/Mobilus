

import UIKit

class MediaMovel: NSObject {
    
    static func mediaMovel(cases: [CovidCase]) throws -> Float {
        if cases.count != 8 {
            throw ValidationError.invalidAmountOfData(count: cases.count)
        }
        
        let casesFilter = cases.sorted { $0.date > $1.date }
        let first = casesFilter[0]
        let last = casesFilter[casesFilter.count - 1]
        
        return (Float(first.deaths) - Float(last.deaths)) / 7
    }
    
}
