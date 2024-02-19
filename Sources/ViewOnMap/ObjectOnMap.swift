import Foundation
import MapKit

/// Object on map
/// camera or ray/relay or anything else.
/// physical.
public protocol ObjectOnMap {
    var id: String { get }
    var name: String { get }
    var location: CLLocationCoordinate2D { get }
    //var heading: Double { get } 0..<360.
    ///  on/off/undefined
    var state: Bool? { get }
}
