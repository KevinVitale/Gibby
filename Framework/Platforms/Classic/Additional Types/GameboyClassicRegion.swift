extension GameboyClassic {
    public enum Region: UInt8, ExpressibleByStringLiteral, CustomStringConvertible {
        case japanese    = 0x00
        case nonJapanese = 0x01
        
        public init(stringLiteral value: String) {
            if value.capitalized == "Japanese" {
                self = .japanese
            }
            else {
                self = .nonJapanese
            }
        }
        
        public var description: String {
            switch self {
            case .japanese: return "Japanese"
            case .nonJapanese: return "Non-Japanese"
            }
        }
    }
}
