import Foundation

extension Cartridge {
    public enum LegacyLicensee: RawRepresentable, Codable, ExpressibleByIntegerLiteral {
        case newFormat
        case legacy(code: Int)
        case none
        
        public var rawValue: Int {
            switch self {
            case .legacy(let code): return code
            case .newFormat: return 0x33
            case .none: return 0x00
            }
        }
        
        public init(rawValue: Int) {
            switch rawValue {
            case 0x33: self = .newFormat
            case 0x00: self = .none
            default: self = .legacy(code: rawValue)
            }
        }
        
        public init(integerLiteral value: Int) {
            self.init(rawValue: value)
        }
    }
}
