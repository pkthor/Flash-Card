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
                            .foregroundColor(.mint)
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
