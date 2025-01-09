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
  @State private var showFlashCards: Bool = false // Toggle for FlashCardGridView mode
  
  let categories = ["All", "Elder", "Sister", "Senior"]
  
  var body: some View {
    VStack {
      
      
      NavigationSplitView {
        
        Image("pink") // Use the image name directly if it's in the assets folder
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100) // Adjust the size as needed
          .clipShape(Circle())
        
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
        
          .safeAreaInset(edge: .bottom) {
            //Switch for selecting view type
            VStack {
              Divider()
              Toggle(isOn: $showFlashCards) {
                Text("Flash Card Mode")
                  .font(.headline)
              }
              .padding()
            }
            .background(Color(UIColor.secondarySystemBackground))
          }
        
        
      } detail: {
        // Toggle between DetailView and FlashCardGridView
        if showFlashCards {
          FlashCardGridView(missionaries: $filteredMissionaries) // Pass filtered missionaries
        } else {
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
