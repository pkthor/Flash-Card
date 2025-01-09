//
//  FlashCardGridView.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/9/25.
//

import SwiftUI
import SwiftData

struct FlashCardGridView: View {
  @Binding var missionaries: [Missionary]
  @State private var currentSet: [Missionary] = []
  //    @State private var tappedCards: Set<Int> = [] // Tracks which cards have been tapped
  @State private var nameVisibility: [Bool] = []
  
  private let numberOfColumns = 4 // 4 cards per row
  
  var body: some View {
    GeometryReader { geometry in
      let inset: CGFloat = 60
      let availableWidth = geometry.size.width - (inset * 4)
      let availableHeight = geometry.size.height - (inset * 4)
      let cardSize = calculateCardSize(from: availableWidth) - 20
      
      VStack {
        // Missionary Grid
        LazyVGrid(
          columns: Array(repeating: GridItem(.fixed(cardSize), spacing: 2), count: numberOfColumns),
          spacing: 30 // Vertical spacing between rows
        ) {
          ForEach(currentSet.indices, id: \.self) { index in
            FlashCardView(missionary: currentSet[index], isTapped: nameVisibility[index])
              .frame(width: cardSize, height: cardSize)
              .onTapGesture {
                handleCardTap(at: index)
              }
          }
        }
        .frame(width: availableWidth, height: availableHeight) // Ensure the grid fits within insets
        .padding(inset) // Add uniform inset around the grid
      }
    }
    .task(id: missionaries) {
      loadInitialSet()
    }
    .onAppear(perform: loadInitialSet)
  }
  
  private func loadInitialSet() {
    // Shuffle missionaries and take the first 16
    currentSet = Array(missionaries.shuffled().prefix(16))
    nameVisibility = Array(repeating: false, count: currentSet.count) // Reset visibility for all cards
  }
  
  private func handleCardTap(at index: Int) {
    // Toggle the visibility of the tapped card's name
    nameVisibility[index].toggle()
    
    // Check if all names are visible
    if nameVisibility.allSatisfy({ $0 }) {
      loadNextSet() // Load a new set if all names are visible
    }
  }
  
  private func loadNextSet() {
    // Load the next set of 16 cards
    currentSet = Array(missionaries.shuffled().prefix(16))
    nameVisibility = Array(repeating: false, count: currentSet.count) // Reset visibility for new set
  }
  
  private func calculateCardSize(from availableWidth: CGFloat) -> CGFloat {
    let horizontalSpacing: CGFloat = 8 // Horizontal spacing between cards
    let totalSpacing = CGFloat(numberOfColumns - 1) * horizontalSpacing
    let totalWidth = availableWidth - totalSpacing
    return totalWidth / CGFloat(numberOfColumns)
  }
}
