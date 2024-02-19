import SwiftUI
import MapKit

//TODO: Read
///https://swiftwithmajid.com/2023/11/28/mastering-mapkit-in-swiftui-basics/
///https://swiftwithmajid.com/2023/12/05/mastering-mapkit-in-swiftui-customizations/
///https://swiftwithmajid.com/2023/12/12/mastering-mapkit-in-swiftui-camera/
///https://swiftwithmajid.com/2023/12/19/mastering-mapkit-in-swiftui-interactions/

//TODO: Annotations, MapType, Overlays
/// MKClusterAnnotation
/// MKAnnotationView
/// MKMapType
/// MKTileOverlay

//TODO: Show snapshot/video when object selected.
//TODO: Show event details when event selected.

@MainActor
public struct ObjectOnMapView: View {
    
    @State private var region = MKCoordinateRegion()
    
    @Binding var objects: [ObjectOnMap]
    
    /// items: list of the objects to display on map
    /// states: the state of the object - on/off/undefined
    public init(objects: Binding<[ObjectOnMap]>) {
        self._objects = objects
    }
    
    public var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                setRegion()
            }
    }
    
    private func setRegion() {
        guard objects.count > 0 else {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
                span: MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
            )
            return
        }
        let latMin: CLLocationDegrees = objects
            .map({ $0.location })
            .min(by: { $0.latitude < $1.latitude })?.latitude ?? 0.0
        let latMax: CLLocationDegrees = objects
            .map({ $0.location })
            .max(by: { $0.latitude < $1.latitude })?.latitude ?? 0.0
        let lonMin: CLLocationDegrees = objects
            .map({ $0.location })
            .min(by: { $0.longitude < $1.longitude })?.longitude ?? 0.0
        let lonMax: CLLocationDegrees = objects
            .map({ $0.location })
            .max(by: { $0.longitude < $1.longitude })?.longitude ?? 0.0
        
        let center = CLLocationCoordinate2D(latitude: (latMin + latMax) / 2, longitude: (lonMin + lonMax) / 2)
        let span = MKCoordinateSpan(latitudeDelta: latMax - latMin, longitudeDelta: lonMax - lonMin)
        
        region = MKCoordinateRegion(
            center: center,
            span: span
        )
    }
    
}

struct TestObject : ObjectOnMap {
    let id: String
    let name: String
    let location: CLLocationCoordinate2D
    let state: Bool?
}

#Preview {
    ObjectOnMapView(objects: .constant([
        TestObject(id: "1", name: "Item 100500", location: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868), state: false),
        TestObject(id: "2", name: "Item 2", location: CLLocationCoordinate2D(latitude: 35.011_286, longitude: -115.166_868), state: true),
        TestObject(id: "3", name: "Item 3", location: CLLocationCoordinate2D(latitude: 35.501_286, longitude: -115.166_868), state: nil)
    ]))
}

