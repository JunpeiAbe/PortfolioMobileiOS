import Foundation

struct AppVersion: Comparable {
    /// バージョン情報
    var value: String
    /// ドットで区切ったバージョン情報
    var splitValue: [Int] {
        value.split(separator: ".").map {
            Int($0) ?? .zero
        }
    }
    static func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
        let count = max(lhs.splitValue.count, rhs.splitValue.count)
        for i in .zero..<count {
            let lv = (i < lhs.splitValue.count) ? lhs.splitValue[i] : .zero
            let rv = (i < rhs.splitValue.count) ? rhs.splitValue[i] : .zero
            if lv != rv {
                return false
            }
        }
        return true
    }
    static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        let count = max(lhs.splitValue.count, rhs.splitValue.count)
        for i in 0..<count {
            let lv = (i < lhs.splitValue.count) ? lhs.splitValue[i] : .zero
            let rv = (i < rhs.splitValue.count) ? rhs.splitValue[i] : .zero
            if lv != rv {
                return lv < rv
            }
        }
        return false
    }
}
