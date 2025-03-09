//
//  DetailView.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/8/25.
//

import SwiftUI
import SwiftData
import UIKit
struct DetailView: View {
    let category: String
    @Binding var missionaries: [Missionary]
    @State private var currentMissionary: Missionary?
    @State private var selectedMissionary: Missionary?
    @State private var showDetailView: Bool = false
    @State private var showName: Bool = false
    @State private var currentIndex: Int = 0
    @State private var searchText: String = ""
    @State private var filteredMissionaries: [Missionary] = []

    var body: some View {
        VStack(spacing: 20) {
            // Search Field
            TextField("Search by last name", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Missionary Details
            if let missionary = currentMissionary {
                VStack {
                    ZStack {
                        GeometryReader { geometry in
                            Image(missionary.photoName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 5)
                                .onTapGesture {
                                    showName.toggle()
                                    if showDetailView {
                                        showName = false
                                    }
                                }
                                .onLongPressGesture {
                                    showName = false
                                    selectedMissionary = missionary
                                    showDetailView = true
                                }

                            if showName {
                                Text(missionary.fnamesurname)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.4))
                                    .cornerRadius(8)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.9)
                                    .transition(.opacity)
                            }
                        }
                        .frame(width: 300, height: 300)
                    }
                    .padding(8)
                }
            } else {
                Text("No missionaries available")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .task(id: searchText) {
            filterMissionaries()
        }
        .task(id: missionaries) {
            filteredMissionaries = missionaries
            loadMissionary(at: currentIndex)
        }
        .task(id: currentIndex) {
            loadMissionary(at: currentIndex)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .navigationTitle("\(category) (\(filteredMissionaries.count))")
        .gesture(
          DragGesture()
            .onEnded { value in
              showName = false
              if value.translation.width < -100 { // Swipe left
                goToNextMissionary()
              } else if value.translation.width > 100 { // Swipe right
                goToPreviousMissionary()
              }
            }
        )
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

    private func loadMissionary(at index: Int) {
        guard !filteredMissionaries.isEmpty else { return }
        currentMissionary = filteredMissionaries[index]
    }

    private func goToNextMissionary() {
        guard !filteredMissionaries.isEmpty else { return }
        
        if currentIndex == filteredMissionaries.count - 1 {
            // If at the last missionary, reshuffle the list
            filteredMissionaries.shuffle()
            currentIndex = 0
        } else {
            currentIndex += 1
        }
    }

  private func goToPreviousMissionary() {
    guard !filteredMissionaries.isEmpty else { return }
    currentIndex = (currentIndex - 1 + filteredMissionaries.count) % filteredMissionaries.count
  }
    private func filterMissionaries() {
        if searchText.isEmpty {
            filteredMissionaries = missionaries
        } else {
            filteredMissionaries = missionaries.filter { $0.surname.localizedCaseInsensitiveContains(searchText) }
        }
        currentIndex = 0
        loadMissionary(at: currentIndex)
    }
}
