import Foundation

public protocol Cartridge: PlatformMemory {
    associatedtype Header: Gibby.Header where Header.Platform == Self.Platform
    
    var header: Header { get }
    var fileExtension: String { get }
    
    func write(to: URL, options: Data.WritingOptions) throws
}
