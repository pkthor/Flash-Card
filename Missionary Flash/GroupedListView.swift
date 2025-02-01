//
//  GroupedListView.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/9/25.
//
import SwiftUI

struct GroupedListView: View {
    @Binding var missionaries: [Missionary]
    @State private var selectedMissionary: Missionary?
    @State private var groupBy: GroupingCriterion = .startDate // Default grouping

    enum GroupingCriterion: String, CaseIterable, Identifiable {
        case startDate = "Start Date"
        case endDate = "End Date"

        var id: String { self.rawValue }
    }

    var groupedMissionaries: [(String, [Missionary])] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy" // Adjust format to match your dates

        return Dictionary(grouping: missionaries) { missionary in
            switch groupBy {
            case .startDate:
                return missionary.startDate
            case .endDate:
                return missionary.endDate
            }
        }
        .map { key, value in
            // Sort each group alphabetically by missionary's full name
            (key, value.sorted { $0.fnamelname < $1.fnamelname })
        }
        .sorted { lhs, rhs in
            // Sort groups by date
            guard let lhsDate = dateFormatter.date(from: lhs.0),
                  let rhsDate = dateFormatter.date(from: rhs.0) else {
                return lhs.0 < rhs.0 // Fallback to string comparison
            }
            return lhsDate < rhsDate
        }
    }

    var body: some View {
        VStack {
            // Picker to toggle between grouping by startDate or endDate
            Picker("Group By", selection: $groupBy) {
                ForEach(GroupingCriterion.allCases) { criterion in
                    Text(criterion.rawValue).tag(criterion)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            List {
                ForEach(groupedMissionaries, id: \.0) { date, missionaries in
                    Section(header: Text(date).font(.headline).foregroundColor(.mint)) {
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
                                .onTapGesture {
                                    selectedMissionary = missionary
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Missionaries by \(groupBy.rawValue)")
            .sheet(item: $selectedMissionary) { missionary in
                MissionaryDetailView(missionary: missionary)
            }
        }
    }
}
