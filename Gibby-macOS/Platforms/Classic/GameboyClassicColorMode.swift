extension GameboyClassic {
    public enum ColorMode: RawRepresentable, Codable {
        public init(rawValue: UInt8) {
            switch rawValue {
            case 0x80:
                self = .some
            case 0xC0:
                self = .exclusive
            default:
                self = .unknown(rawValue)
            }
        }
        
        case unknown(UInt8)
        case some
        case exclusive
        
        public var rawValue: UInt8 {
            switch self {
            case .some:
                return 0x80
            case .exclusive:
                return 0xC0
            case .unknown(let value):
                return value
            }
        }
    }
}
