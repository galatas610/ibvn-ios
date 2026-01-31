//
//  CampusMap.swift
//  ibvn
//
//  Created by José Letona Rodríguez on 1/30/26.
//

import SwiftUI
import _MapKit_SwiftUI

struct CampusMapView: View {
    let campus: Campus
    let locations: [CampusLocation]

    @State private var region: MKCoordinateRegion

    init(campus: Campus, locations: [CampusLocation]) {
        self.campus = campus
        self.locations = locations

        _region = State(
            initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: campus.latitude ?? 0,
                    longitude: campus.longitude ?? 0
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
        )
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locations) { loc in
            MapAnnotation(
                coordinate: CLLocationCoordinate2D(
                    latitude: loc.latitude,
                    longitude: loc.longitude
                )
            ) {
                VStack(spacing: 4) {
                    ZStack {
                        Image("logoShort")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 30, height: 30)

                        Circle()
                            .strokeBorder(Constants.primary, lineWidth: 2)
                            .frame(width: 32, height: 32)
                    }

                    Text("Campus\nIBVN")
                        .font(.caption2)
                        .foregroundColor(Constants.primary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}
