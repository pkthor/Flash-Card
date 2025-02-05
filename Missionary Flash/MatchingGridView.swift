//
//  MatchingGridView.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 2/4/25.
//

import SwiftUI
import SwiftData

struct MatchingGridView: View {
    @Binding var missionaries: [Missionary]
    @State private var currentSet: [Missionary] = []
    @State private var shuffledNames: [String] = []
    @State private var selectedPhoto: Missionary?
    @State private var matchedPairs: [String: String] = [:]
    @State private var incorrectMatch: String?
    @State private var showCompletionMessage = false
    
    var body: some View {
        VStack {
            if showCompletionMessage {
                Text("Well Done!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .transition(.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 1)) {
                                showCompletionMessage = false
                                loadNewSet()
                            }
                        }
                    }
            } else {
                // Photo Grid (Top 2/3)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                    ForEach(currentSet) { missionary in
                        ZStack {
                            Image(missionary.photoName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: selectedPhoto == missionary ? 3 : 0)
                                )
                                .onTapGesture {
                                    selectedPhoto = missionary
                                }
                            if let matchedName = matchedPairs[missionary.name] {
                                Text(matchedName)
                                .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.blue.opacity(0.4))
                                    .cornerRadius(5)
                                    .offset(y: 70)
                            }
                        }
                    }
                }
                .padding()
                
                // Name Grid (Bottom 1/3)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                    ForEach(shuffledNames, id: \..self) { name in
                        if !matchedPairs.values.contains(name) {
                            Text(name)
                                .foregroundColor(.primary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(incorrectMatch == name ? Color.red.opacity(0.5) : Color.blue.opacity(0.3))
                                .cornerRadius(8)
                                .onTapGesture {
                                    handleSelection(name: name)
                                }
                                .animation(.default, value: incorrectMatch)
                        }
                    }
                }
                .padding()
            }
        }
        .task(id: missionaries) {
          loadNewSet()
        }
        .onAppear {
          loadNewSet()
        }
        .onAppear(perform: loadNewSet)
    }
    
    private func loadNewSet() {
        currentSet = missionaries.shuffled().prefix(12).map { $0 }
        
        // Ensure names are unique by appending a number if needed
        var nameCounts = [String: Int]()
        shuffledNames = currentSet.map { missionary in
            let name = missionary.shortname
            if let count = nameCounts[name] {
                nameCounts[name] = count + 1
                return "\(name) (\(count + 1))"
            } else {
                nameCounts[name] = 1
                return name
            }
        }.shuffled()
        
        matchedPairs.removeAll()
        selectedPhoto = nil
    }
    
    private func handleSelection(name: String) {
        guard let selected = selectedPhoto else { return }
        if selected.shortname == name {
            matchedPairs[selected.name] = name
            selectedPhoto = nil
            shuffledNames.removeAll { $0 == name }
        } else {
            incorrectMatch = name
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                incorrectMatch = nil
            }
        }
        
        if matchedPairs.count == currentSet.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeIn(duration: 1)) {
                    showCompletionMessage = true
                }
            }
        }
    }
}
