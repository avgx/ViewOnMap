import Foundation
import MapKit

/// Event on map
/// produced for some object at some date time at the location of the object
//TODO: think about drawing path for the events from the person or car.
public protocol EventOnMap {
    var id: String { get }
    var title: String { get }
    var location: CLLocationCoordinate2D { get }
    var dt: Date { get }
}
