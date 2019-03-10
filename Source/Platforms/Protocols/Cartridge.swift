import Foundation

public protocol Cartridge: PlatformMemory {
    associatedtype Header: Gibby.Header where Header.Platform == Self.Platform
    
    var fileExtension: String { get }
    
    func write(to: URL, options: Data.WritingOptions) throws
}

extension Cartridge {
    public var header: Header {
        let lowerBound = Self.Index(Platform.headerRange.lowerBound)
        let upperBound = Self.Index(Platform.headerRange.upperBound)
        
        let headerRange = lowerBound..<upperBound
        var headerData  = Data(count: headerRange.count)

        guard self.isEmpty == false else {
            return Header(bytes: headerData)
        }
        
        headerData = Data(self[headerRange])
        return Header(bytes: headerData)
    }
}
