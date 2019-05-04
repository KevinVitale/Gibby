import Foundation

public protocol Cartridge: PlatformMemory {
}

extension Cartridge {
    public var header: Platform.Header {
        let lowerBound = Self.Index(Platform.headerRange.lowerBound)
        let upperBound = Self.Index(Platform.headerRange.upperBound)
        
        let headerRange = lowerBound..<upperBound
        var headerData  = Data(count: headerRange.count)

        guard self.isEmpty == false else {
            return Platform.Header(bytes: headerData)
        }
        
        headerData = Data(self[headerRange])
        return Platform.Header(bytes: headerData)
    }
}
