
extension GameboyClassic.Cartridge {
    public enum ColorMode {
        public typealias RawValue = UInt8
        public init(rawValue: RawValue) {
            switch rawValue {
            case 0x80:
                self = .some
            case 0xC0:
                self = .exclusive
            default:
                self = .unknown(rawValue)
            }
        }
        
        case unknown(RawValue)
        case some
        case exclusive
        
        public var rawValue: RawValue {
            switch self {
            case .some:
                return 0x80
            case .exclusive:
                return 0xC0
            case .unknown(let value):
                return value
            }
        }
        
        public static func ==(lhs: ColorMode, rhs: ColorMode) -> Bool {
            switch (lhs, rhs) {
            case (.exclusive, .exclusive):
                return true
            case (.some, .some):
                return true
            case (.unknown, .unknown):
                return true
            default:
                return false
            }
        }
    }
}
