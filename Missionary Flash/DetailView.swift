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
  
  var body: some View {
    VStack(spacing: 20) {
      if let missionary = currentMissionary {
        VStack {
          // Header Section
          Text(missionary.startDate)
            .font(.title)
            .foregroundColor(.gray)
            .padding()
          
          // Image Section
          Image(missionary.photoName)
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
            .padding()
          
          // Details Section
          if showDetails {
            VStack(spacing: 20) {
              Text(missionary.shortname)
                .font(.custom("HelveticaNeue-Light", size: 60))
                .foregroundColor(.yellow)
              Grid {
                GridRow {
                  Text("Hobbies:")
                    .font(.headline)
                  Text(missionary.hobbies)
                    .font(.headline)
                    .padding(.leading, 10)
                }
                Spacer()
                GridRow {
                  Text("Location:")
                    .font(.headline)
                  Text("\(missionary.city), \(missionary.state), \(missionary.country)")
                    .font(.title)
                    .padding(.leading, 10)
                    .foregroundColor(.indigo)
                }
              }
              .padding()
              .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor.secondarySystemBackground)))
              .shadow(radius: 3)
            }
            .padding()
            .transition(.opacity)
          }
          // Buttons
          HStack(spacing: 20) {
            Button(showDetails ? "Hide Details" : "Show Details") {
              withAnimation {
                showDetails.toggle()
              }
            }
            .buttonStyle(PrimaryButtonStyle(color: .blue))
          }
          .padding()
        }
      } else {
        Text("No missionaries available")
          .font(.title)
          .foregroundColor(.gray)
      }
    }
    
    .onAppear {
      loadNextMissionary()
    }
    .padding()
    .background(Color(UIColor.secondarySystemBackground))
    //    .background(Color(UIColor.systemGray5))
    .navigationTitle("\(category) (\(missionaries.count))")
    
    // Next Button
    Button("Next") {
      loadNextMissionary()
    }
    .font(.headline)
    .padding(20)
    .frame(maxWidth: 200)
    .background(Color.blue)
    .foregroundColor(.white)
    .cornerRadius(8)
  }
  
  struct PrimaryButtonStyle: ButtonStyle {
    var color: Color = .teal
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .padding()
        .frame(maxWidth: 200)
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(10)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .animation(.spring(), value: configuration.isPressed)
    }
  }
  private func loadNextMissionary() {
    guard !missionaries.isEmpty else { return }
    let randomIndex = Int.random(in: 0..<missionaries.count)
    //        currentMissionary = missionaries.remove(at: randomIndex)
    currentMissionary = missionaries[randomIndex]
    showDetails = false // Hide details when the next missionary is loaded
  }
}
