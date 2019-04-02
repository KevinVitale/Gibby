extension GameboyClassic {
    public struct Cartridge: Gibby.Cartridge, PlatformMemory {
        public init(bytes: Data) {
            self.bytes = bytes
        }
        
        public typealias Platform = GameboyClassic
        public typealias Index    = Int
        
        private let bytes: Data
        
        public subscript(position: Index) -> Data.Element {
            return bytes[Int(position)]
        }
        
        public var startIndex: Index {
            return Index(bytes.startIndex)
        }
        
        public var endIndex: Index {
            return Index(bytes.endIndex)
        }
        
        public func index(after i: Index) -> Index {
            return Index(bytes.index(after: Int(i)))
        }
        
        public var fileExtension: String {
            switch header.colorMode {
            case .unknown:
                return "gb"
            default:
                return "gbc"
            }
        }
        
        public func write(to url: URL, options: Data.WritingOptions = []) throws {
            try self.bytes.write(to: url, options: options)
        }
    }
}

