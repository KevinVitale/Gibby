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
    }
}

extension Cartridge where Platform == GameboyClassic {
    public var fileExtension: String {
        switch header.colorMode {
        case .unknown:
            return "gb"
        default:
            return "gbc"
        }
    }
}

extension Cartridge where Platform == GameboyClassic {
    public func romBank(at location: Int) -> Self.SubSequence? {
        guard self.isEmpty == false, (0..<header.romBanks).contains(location) else {
            return nil
        }
        
        let lowerBound   = Self.Index(header.romBankSize * location)
        let bytesInRange = lowerBound..<lowerBound.advanced(by: header.romBankSize)
        let bytesRange   = self.startIndex..<self.endIndex

        guard bytesRange.overlaps(bytesInRange) else {
            return nil
        }
        return self[bytesInRange]
    }
}
