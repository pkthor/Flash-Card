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
    @Binding var selectedMissionary: Missionary?
    @State private var showDetailView: Bool = false

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 20)] // Responsive grid layout

    private var groupedMissionaries: [(key: String, value: [Missionary])] {
      Dictionary(grouping: missionaries.sorted { $0.surname < $1.surname }) {
            String($0.surname.prefix(1))
        }
        .sorted { $0.key < $1.key }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(groupedMissionaries, id: \.key) { group in
                    VStack(alignment: .leading) {
                        Text(group.key)
                            .font(.title)
                            .bold()
                            .padding(.leading)
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(group.value) { missionary in
                                VStack {
                                    if !missionary.photoName.isEmpty {
                                        Image(missionary.photoName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 120, height: 120)
                                    }
                                    
                                    Text(missionary.shortname)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 150)
                                .padding()
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 3)
                                .onTapGesture {
                                    Task {
                                        await selectMissionary(missionary)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Missionaries")
        .sheet(isPresented: Binding(
            get: { showDetailView && selectedMissionary != nil },
            set: { if !$0 { showDetailView = false; selectedMissionary = nil } }
        )) {
            if let missionary = selectedMissionary {
                MissionaryDetailView(missionary: missionary)
            } else {
                Text("No missionary selected")
            }
        }
    }

    private func selectMissionary(_ missionary: Missionary) async {
        selectedMissionary = missionary
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms delay
        showDetailView = true
    }
}

//struct AlphabeticalListView: View {
//    let missionaries: [Missionary]
//    @Binding var selectedMissionary: Missionary?
//    @State private var showDetailView: Bool = false
//
//    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 20)] // Responsive grid layout
//
//    private var groupedMissionaries: [(key: String, value: [Missionary])] {
//        Dictionary(grouping: missionaries.sorted { $0.lname < $1.lname }) {
//            String($0.lname.prefix(1))
//        }
//        .sorted { $0.key < $1.key }
//    }
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(alignment: .leading, spacing: 20) {
//                ForEach(groupedMissionaries, id: \.key) { group in
//                    VStack(alignment: .leading) {
//                        Text(group.key)
//                            .font(.title)
//                            .bold()
//                            .padding(.leading)
//                        
//                        LazyVGrid(columns: columns, spacing: 20) {
//                            ForEach(group.value) { missionary in
//                                VStack {
//                                    if !missionary.photoName.isEmpty {
//                                        Image(missionary.photoName)
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 120, height: 120)
//                                            .clipShape(Circle())
//                                    } else {
//                                        Circle()
//                                            .fill(Color.gray)
//                                            .frame(width: 120, height: 120)
//                                    }
//                                    
//                                    Text(missionary.shortname)
//                                        .font(.headline)
//                                        .multilineTextAlignment(.center)
//                                }
//                                .frame(width: 150)
//                                .padding()
//                                .background(Color(.systemBackground))
//                                .clipShape(RoundedRectangle(cornerRadius: 15))
//                                .shadow(radius: 3)
//                                .onTapGesture {
//                                    selectedMissionary = missionary
//                                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                    showDetailView = true
//                                  }
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//            }
//        }
//        .navigationTitle("Missionaries") // Title when in full detail view
//        .sheet(isPresented: Binding(
//                    get: { showDetailView && selectedMissionary != nil },
//                    set: { if !$0 { showDetailView = false; selectedMissionary = nil } }
//                )) {
//                    if let missionary = selectedMissionary {
//                        MissionaryDetailView(missionary: missionary)
//                    } else {
//                        Text("No missionary selected")
//                    }
//        }
//    }
//}

//struct AlphabeticalListView: View {
//    let missionaries: [Missionary]
//    @Binding var selectedMissionary: Missionary? // Bind the selected missionary
//    @State private var showDetailView: Bool = false
//    
//    private var groupedMissionaries: [(key: String, value: [Missionary])] {
//        Dictionary(grouping: missionaries.sorted(by: { $0.surname < $1.surname })) {
//          String($0.surname.prefix(1))
//        }
//        .sorted { $0.key < $1.key }
//    }
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(groupedMissionaries, id: \.key) { group in
//                    Section(header: Text(group.key).font(.title2)) {
//                        ForEach(group.value) { missionary in
//                            HStack {
//                                if !missionary.photoName.isEmpty {
//                                    
//                                    Image(missionary.photoName)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 100, height: 100)
//                                        .clipShape(Circle())
//                                        .padding(.trailing, 10)
//                                } else {
//                                    Circle()
//                                        .fill(Color.gray)
//                                        .frame(width: 100, height: 100)
//                                        .padding(.trailing, 10)
//                                }
//                                
//                                VStack(alignment: .leading) {
//                                    Text(missionary.shortname)
//                                        .font(.headline)
//                                    Text("Start Date: \(missionary.startDate)")
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//                                }
//                            }
//                            .padding(.vertical, 5)
//                            .onTapGesture {
//                                print("Tapped \(missionary.shortname)")
//                                selectedMissionary = missionary
//                                showDetailView = true
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Missionaries")
//            .sheet(isPresented: $showDetailView) {
//                if let missionary = selectedMissionary {
//                    MissionaryDetailView(missionary: missionary)
//                }
//                else {
//                    Text("No missionary selected")
//                }
//            }
//            .task(id: selectedMissionary) {
//                if selectedMissionary != nil {
//                    showDetailView = true
//                }
//            }
//            .onDisappear {
//                // Reset the selectedMissionary when the view disappears
//                selectedMissionary = nil
//            }
//        }
//    }
//}
