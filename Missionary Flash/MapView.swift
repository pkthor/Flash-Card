//
//  MapView.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 2/1/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var coordinate: CLLocationCoordinate2D?
    @State private var errorMessage: String?
    
    var locationName: String
    let missionary: Missionary
    
    var body: some View {
        VStack {
            Text(missionary.shortname)
                .font(.largeTitle)
                .foregroundColor(.yellow)
                .padding(.top)
            
            if let coordinate = coordinate {
                Map(position: $cameraPosition) {
                    Marker(locationName, coordinate: coordinate)
                }
                .frame(maxWidth: .infinity)  // Full width within safe area
                .frame(height: deviceSpecificHeight()) // Adjust height based on device
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .onTapGesture {
                    dismiss()
                }
                .padding(.bottom)  // Optional: Space between map and text
            } else {
                ProgressView() // Show a loading indicator while fetching coordinates
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.width * 0.6)
                    .padding(.bottom)
            }
            
            Text(locationName)
                .font(.headline)
                .padding(.top, 10)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer() // Ensure the layout doesn't get cut off
        }
        .padding(.horizontal) // Ensure spacing from screen edges
        .onAppear {
            geocodeLocation()
        }
    }
    
    private func geocodeLocation() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { placemarks, error in
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
                return
            }
            
            if let location = placemarks?.first?.location {
                let coordinate = location.coordinate
                self.coordinate = coordinate
                self.cameraPosition = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0) // Adjusted for a wider zoom-out
                    )
                )
            } else {
                errorMessage = "Location not found."
            }
        }
    }
  private func deviceSpecificHeight() -> CGFloat {
          if UIDevice.current.userInterfaceIdiom == .pad {
              // For iPad, use 35% of the screen width
              return UIScreen.main.bounds.width * 0.35
          } else {
              // For iPhone, use the full width of the screen
              return UIScreen.main.bounds.width
          }
      }
}
