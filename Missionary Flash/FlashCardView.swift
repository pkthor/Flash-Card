//
//  FlashCardView.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/9/25.
//
import SwiftUI
import SwiftData

struct FlashCardView: View {
  let missionary: Missionary
  let isTapped: Bool
  
  var body: some View {
    ZStack {
      // Missionary Photo (Full Size of the Card)
      Image(missionary.photoName)
        .resizable()
        .scaledToFill()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .cornerRadius(12)
        .shadow(radius: 4)
      
      // Name Overlay (Visible Only When Tapped)
      if isTapped {
        VStack {
          Spacer()
          Text(missionary.fnamelname)
            .font(.headline)
            .foregroundColor(.white)
            .padding(8)
            .background(Color.blue.opacity(0.4))
            .cornerRadius(8)
            .transition(.opacity) // Smooth fade-in transition
        }
      }
    }
    .aspectRatio(1, contentMode: .fit) // Maintain a square card
    .animation(.easeInOut, value: isTapped)
    .padding(8)
  }
}
