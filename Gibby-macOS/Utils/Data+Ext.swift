import Foundation

extension Data {
    public subscript(section: Header.Section) -> Data {
        let offsetSection = Header.Section.beginning(at: .address(indices.lowerBound), section)
        guard self.indices.overlaps(offsetSection.rawValue) else {
            return .init()
        }
        return self[offsetSection.rawValue]
    }
}
