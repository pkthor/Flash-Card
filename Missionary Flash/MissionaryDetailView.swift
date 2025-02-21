//
//  Untitled.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/15/25.
//

import SwiftUI
import SwiftData

struct MissionaryDetailView: View {
  let missionary: Missionary
  @Environment(\.dismiss) var dismiss
  @State private var selectedLocation: String? = nil
  
  var body: some View {
    VStack(spacing: 20) {
      Image(missionary.photoName)
        .resizable()
        .scaledToFit()
        .frame(width: 250, height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        .onTapGesture {
          dismiss()
        }
      
      Text(missionary.fnamesurname)
        .font(.largeTitle)
        .foregroundColor(.primary)
      
      VStack(alignment: .leading, spacing: 10) {
        Text("Hobbies:")
          .font(.headline)
          .foregroundColor(.accentColor)
        
        ScrollView {
          Text(missionary.hobbies)
            .font(.body)
            .multilineTextAlignment(.leading)
        }
        .frame(height: 120)
        .frame(maxHeight: 300) // Limit the height of the scrollable area
      }
      .padding()
      VStack {
        Text("\(missionary.city), \(missionary.state), \(missionary.country)")
          .font(.headline)
          .foregroundColor(.mint)
          .onTapGesture {
            selectedLocation = "\(missionary.city), \(missionary.state), \(missionary.country)"
          }
      }
      .sheet(item: $selectedLocation) { location in
        MapView(locationName: location, missionary: missionary)
      }
      
      Text("Start: \(missionary.startDate)")
        .font(.headline)
      
      Text("End: \(missionary.endDate)")
        .font(.headline)
      
      Spacer()
    }
    .padding()
  }
}

extension String: @retroactive Identifiable {
  public var id: String { self }
}
