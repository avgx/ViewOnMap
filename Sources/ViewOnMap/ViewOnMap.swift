import SwiftUI
import MapKit

public protocol MapItem {
    var id: String { get }
    var name: String { get }
    var location: CLLocationCoordinate2D { get }
}


//TODO: Annotations, MapType, Overlays
/// MKClusterAnnotation
/// MKAnnotationView
/// MKMapType
/// MKTileOverlay

//TODO: Show snapshot/video when item is selected.

@MainActor
public struct ViewOnMap: View {
    
    @State private var region = MKCoordinateRegion()
    
    var items: [MapItem]
    @Binding var states: [String: Bool?]
    
    /// items: list of the objects to display on map
    /// states: the state of the object - on/off/undefined
    public init(items: [MapItem], states: Binding<[String: Bool?]>) {
        self.items = items
        self._states = states
    }
    
    public var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                setRegion()
            }
    }
    
    private func setRegion() {
        guard items.count > 0 else {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
                span: MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
            )
            return
        }
        let latMin: CLLocationDegrees = items
            .map({ $0.location })
            .min(by: { $0.latitude < $1.latitude })?.latitude ?? 0.0
        let latMax: CLLocationDegrees = items
            .map({ $0.location })
            .max(by: { $0.latitude < $1.latitude })?.latitude ?? 0.0
        let lonMin: CLLocationDegrees = items
            .map({ $0.location })
            .min(by: { $0.longitude < $1.longitude })?.longitude ?? 0.0
        let lonMax: CLLocationDegrees = items
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

struct TestItem : MapItem {
    let id: String
    let name: String
    let location: CLLocationCoordinate2D
}

#Preview {
    ViewOnMap(items: [
        TestItem(id: "1", name: "Item 100500", location: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868)),
        TestItem(id: "2", name: "Item 2", location: CLLocationCoordinate2D(latitude: 35.011_286, longitude: -115.166_868))
    ], states: .constant([:]))
}

