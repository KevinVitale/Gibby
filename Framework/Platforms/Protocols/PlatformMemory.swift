import Foundation

public protocol PlatformMemory {
    associatedtype Platform: Gibby.Platform
    
    init(bytes: Data)
}
