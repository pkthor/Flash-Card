//
//  GroupedListView.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/9/25.
//
import SwiftUI

struct GroupedListView: View {
    @Binding var missionaries: [Missionary]

    var groupedMissionaries: [(String, [Missionary])] {
        // Date formatter to parse string dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy" // Adjust format to match your startDate string

        // Convert strings to dates and sort
        return Dictionary(grouping: missionaries) { $0.startDate }
            .map { key, value in
                (key, value)
            }
            .sorted { lhs, rhs in
                guard let lhsDate = dateFormatter.date(from: lhs.0),
                      let rhsDate = dateFormatter.date(from: rhs.0) else {
                    return lhs.0 < rhs.0 // Fallback to string comparison
                }
                return lhsDate < rhsDate
            }
    }

    var body: some View {
        List {
            ForEach(groupedMissionaries, id: \.0) { startDate, missionaries in
                Section(header: Text(startDate).font(.headline)) {
                    // Two-column layout for each group
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                        ForEach(missionaries) { missionary in
                            VStack {
                                Image(missionary.photoName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .padding(.bottom, 4)

                                Text(missionary.fnamelname)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                    }
                    .padding(.vertical) // Add spacing between groups
                }
            }
        }
        .navigationTitle("Missionaries by Start Date")
    }
}
