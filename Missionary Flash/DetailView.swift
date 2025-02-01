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
  @State private var showDetails: Bool = false // Tracks visibility of details
  @State private var showName: Bool = false
  @State private var currentIndex: Int = 0 // Tracks the current index for navigation
  @State private var searchText: String = "" // Text for the search field
  @State private var filteredMissionaries: [Missionary] = [] // Filtered list of missionaries
  var customFont: Font {
    if UIDevice.current.userInterfaceIdiom == .pad {
      return .custom("HelveticaNeue-Light", size: 60)
    } else {
      return .headline
    }
  }
  var customFont2: Font {
    if UIDevice.current.userInterfaceIdiom == .pad {
      return .title
    } else {
      return .headline
    }
  }
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Spacer()
        // Search Field
        TextField("Search by last name", text: $searchText)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
          .foregroundColor(.secondary)
        Spacer()
      }
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
//                      .padding()
                      .onTapGesture {
                          showName.toggle()
                          if showDetails {
                              showName = false
                          }
                      }
                      .onLongPressGesture {
                          showName = false
                          withAnimation {
                              showDetails.toggle()
                          }
                      }
                  
                  if showName {
                      Text(missionary.fnamelname)
                          .font(.headline)
                          .foregroundColor(.white)
                          .padding(8)
                          .background(Color.blue.opacity(0.4))
                          .cornerRadius(8)
                          .position(x: geometry.size.width / 2, y: geometry.size.height * 0.9)  // Adjusts text to lower third
                          .transition(.opacity) // Smooth fade-in transition
                  }
              }
              .frame(width: 300, height: 300)  // Ensure the frame remains consistent
          }
          .aspectRatio(1, contentMode: .fit)
          .animation(.easeInOut, value: showName)
          .padding(8)
          
          if showDetails {
            VStack(spacing: 20) {
              Text(missionary.shortname)
                .font(customFont)
                .foregroundColor(.yellow)
              Text("\(missionary.city), \(missionary.state), \(missionary.country)")
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .caption)
                .padding(.leading, 10)
                .foregroundColor(.teal)
              HStack {
                Text("Hobbies:")
                  .font(UIDevice.current.userInterfaceIdiom == .pad ? .headline : .caption)
                //                    .font(.headline)
                ScrollView {
                  Text(missionary.hobbies)
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .headline : .caption)
                    .padding(.leading, 10)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor.secondarySystemBackground)))
                .shadow(radius: 3)
              }
            }
            .padding()
            .transition(.opacity)
          }
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
  }
  private func loadMissionary(at index: Int) {
    guard !filteredMissionaries.isEmpty else { return }
    currentMissionary = filteredMissionaries[index]
    showDetails = false // Hide details when a new missionary is loaded
  }
  
  private func goToNextMissionary() {
    guard !filteredMissionaries.isEmpty else { return }
    currentIndex = (currentIndex + 1) % filteredMissionaries.count
  }
  
  private func goToPreviousMissionary() {
    guard !filteredMissionaries.isEmpty else { return }
    currentIndex = (currentIndex - 1 + filteredMissionaries.count) % filteredMissionaries.count
  }
  
  private func filterMissionaries() {
    if searchText.isEmpty {
      filteredMissionaries = missionaries
    } else {
      filteredMissionaries = missionaries.filter { $0.lname.localizedCaseInsensitiveContains(searchText) }
    }
    currentIndex = 0
    loadMissionary(at: currentIndex)
  }
}
