import Foundation

extension Cartridge {
    public enum ColorMode: RawRepresentable, ExpressibleByIntegerLiteral, Codable {
        case exclusive
        case some
        case none
        case unknown(_ mode: Int)
        
        public var rawValue: Int {
            switch self {
            case .exclusive: return 0xC0
            case .some: return 0x80
            case .none: return 0x00
            case .unknown(let mode): return mode
            }
        }
        public init(rawValue: Int) {
            switch rawValue {
            case 0xC0: self = .exclusive
            case 0x80: self = .some
            case 0x00: self = .none
            default:
                self = .unknown(rawValue)
            }
        }
        
        public init(integerLiteral value: Int) {
            self.init(rawValue: value)
        }
    }
}
