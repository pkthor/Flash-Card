//
//  AlphabeticalListView.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/26/25.
//
import SwiftUI
import SwiftData

struct AlphabeticalListView: View {
    let missionaries: [Missionary]
    @Binding var selectedMissionary: Missionary? // Bind the selected missionary
    @State private var showDetailView: Bool = false
    
    private var groupedMissionaries: [(key: String, value: [Missionary])] {
        Dictionary(grouping: missionaries.sorted(by: { $0.lname < $1.lname })) {
            String($0.lname.prefix(1))
        }
        .sorted { $0.key < $1.key }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedMissionaries, id: \.key) { group in
                    Section(header: Text(group.key).font(.title2)) {
                        ForEach(group.value) { missionary in
                            HStack {
                                if !missionary.photoName.isEmpty {
                                    
                                    Image(missionary.photoName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .padding(.trailing, 10)
                                } else {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 100, height: 100)
                                        .padding(.trailing, 10)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(missionary.shortname)
                                        .font(.headline)
                                    Text("Start Date: \(missionary.startDate)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 5)
                            .onTapGesture {
                                print("Tapped \(missionary.shortname)")
                                selectedMissionary = missionary
                                showDetailView = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("Missionaries")
            .sheet(isPresented: $showDetailView) {
                if let missionary = selectedMissionary {
                    MissionaryDetailView(missionary: missionary)
                }
                else {
                    Text("No missionary selected")
                }
            }
            .task(id: selectedMissionary) {
                if selectedMissionary != nil {
                    showDetailView = true
                }
            }
            .onDisappear {
                // Reset the selectedMissionary when the view disappears
                selectedMissionary = nil
            }
        }
    }
}
