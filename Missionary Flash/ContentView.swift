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
  @Environment(\.dismiss) var dismiss
  @Query private var missionaries: [Missionary]
  @State private var selectedCategory: String? = nil
  @State private var filteredMissionaries: [Missionary] = []
  @State private var selectedViewType: ViewType = .detail // Selected view type
  @State private var selectedMissionary: Missionary? = nil
  @State private var showPopover: Bool = false
  
  let categories = ["All", "Elder", "Sister", "Senior"]
  enum ViewType: String, CaseIterable, Identifiable {
    case detail = "Card"
    case grid = "Grid"
    case groupedList = "Dates"
    case alphabetical = "Alpha"
    case matchingGrid = "Match"
    
    var id: String { self.rawValue }
  }
  var body: some View {
     NavigationSplitView {
       // **Master View (Left Side)**
       VStack {
         HStack {
           Text("Mérida")
             .font(.largeTitle)
           Button(action: {
             showPopover.toggle()
           }) {
             Image(systemName: "info.circle")
               .foregroundColor(.blue)
           }
           .buttonStyle(.plain) // Ensures it blends seamlessly
           .popover(isPresented: self.$showPopover,
                    attachmentAnchor: .point(.center),
                    arrowEdge: .top,
                    content: {
             InfoView()
               .padding()
               .presentationCompactAdaptation(.none)
           })
           .onTapGesture {
             dismiss()
           }
         }
         .padding(.bottom, 8)
         Spacer()
         Picker("View Type", selection: $selectedViewType) {
           ForEach(UIDevice.current.userInterfaceIdiom == .pad ? ViewType.allCases : [.detail, .groupedList, .alphabetical]) { viewType in
             Text(viewType.rawValue)
               .font(.title2)
               .tag(viewType)
           }
         }
         .pickerStyle(SegmentedPickerStyle())
         .padding(.bottom, 10)
         .frame(height: 60)
         // Category List
         List(categories, id: \.self, selection: $selectedCategory) { category in
           Text(category)
             .frame(height: 60)
             .padding()
             .font(.title2)
             .onTapGesture {
               selectedCategory = category
               applyFilter(for: category)
               selectedMissionary = nil
             }
         }
         Spacer()
         HStack {
           Spacer()
           Image("pink")
             .resizable()
             .scaledToFit()
             .frame(width: 120, height: 120)
             .clipShape(Circle())
             .scaleEffect(x: -1, y: 1)
           Spacer()
           Image("ltblue")
             .resizable()
             .scaledToFit()
             .frame(width: 120, height: 120)
             .clipShape(Circle())
           Spacer()
         }
         .padding(.top, 40)
         Spacer()
       }
     } detail: {
       // **Detail View (Right Side)**
       switch selectedViewType {
       case .detail:
         if let selectedCategory, !filteredMissionaries.isEmpty {
           DetailView(category: selectedCategory, missionaries: $filteredMissionaries)
         } else {
           Text("Select a Category")
             .font(.title)
             .foregroundColor(.secondary)
         }
       case .grid:
         FlashCardGridView(missionaries: $filteredMissionaries)
       case .groupedList:
         GroupedListView(missionaries: $filteredMissionaries, selectedMissionary: $selectedMissionary)
       case .alphabetical:
         AlphabeticalListView(missionaries: filteredMissionaries, selectedMissionary: $selectedMissionary)
           .navigationBarTitle("Missionaries", displayMode: .inline)
       case .matchingGrid:
         MatchingGridView(missionaries: $filteredMissionaries)
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
