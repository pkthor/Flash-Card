//
//  ContentView.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var missionaries: [Missionary]
  @State private var selectedCategory: String? = nil
  @State private var filteredMissionaries: [Missionary] = []
  @State private var selectedViewType: ViewType = .detail // Selected view type
  
  let categories = ["All", "Elder", "Sister", "Senior"]
  enum ViewType: String, CaseIterable, Identifiable {
    case detail = "Single Photo"
    case grid = "Flash Cards"
    case groupedList = "Grouped List"
    
    var id: String { self.rawValue }
  }
  var body: some View {
    VStack {
      NavigationSplitView {
        
        Image("pink") // Use the image name directly if it's in the assets folder
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100) // Adjust the size as needed
          .clipShape(Circle())
        
        // Picker for selecting the view type
        Picker("View Type", selection: $selectedViewType) {
            ForEach(ViewType.allCases) { viewType in
                Text(viewType.rawValue)
                    .font(.title2) // Adjust font size
                    .tag(viewType)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .frame(height: 60)

        // Master View
        List(categories, id: \.self, selection: $selectedCategory) { category in
          Text(category)
            .frame(height: 60)
            .padding()
            .font(.title2)
            .onTapGesture {
              selectedCategory = category
              applyFilter(for: category)
            }
        }
        
        Image("ltblue") // Use the image name directly if it's in the assets folder
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100) // Adjust the size as needed
          .clipShape(Circle())
        
      } detail: {
        switch selectedViewType {
        case .detail:
            if let selectedCategory, !filteredMissionaries.isEmpty {
                DetailView(
                    category: selectedCategory,
                    missionaries: $filteredMissionaries
                )
            } else {
                Text("Select a Category")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        case .grid:
            FlashCardGridView(missionaries: $filteredMissionaries)
        case .groupedList:
            GroupedListView(missionaries: $filteredMissionaries)
        }
    }
}
    .onAppear {
      applyFilter(for: "All") // Default filter
    }
  }
  
  private func applyFilter(for category: String) {
    switch category {
    case "Elder":
      filteredMissionaries = missionaries.filter { $0.title == "Elder" }
    case "Sister":
      filteredMissionaries = missionaries.filter { $0.title == "Sister" }
    case "Senior":
      filteredMissionaries = missionaries.filter { $0.title == "Senior" }
    default:
      filteredMissionaries = missionaries
    }
  }
}
