//
//  GroupedListView.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/9/25.
//
import SwiftUI
struct GroupedListView: View {
    @Binding var missionaries: [Missionary]
    @Binding var selectedMissionary: Missionary?
    @State private var groupBy: GroupingCriterion = .startDate

    enum GroupingCriterion: String, CaseIterable, Identifiable {
        case startDate = "Start Date"
        case endDate = "End Date"

        var id: String { self.rawValue }
    }

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 20)] // Responsive grid layout

  var groupedMissionaries: [(key: String, value: [Missionary])] {
      let grouped: [(key: String, value: [Missionary])] = Dictionary<String, [Missionary]>(grouping: missionaries) { missionary in
          switch groupBy {
          case .startDate: return missionary.startDate
          case .endDate: return missionary.endDate
          }
      }
      .map { (key: String, value: [Missionary]) -> (String, [Missionary]) in
          (key, value.sorted { $0.fnamesurname < $1.fnamesurname })
      }
      .sorted { (lhs: (key: String, value: [Missionary]), rhs: (key: String, value: [Missionary])) -> Bool in
          let lhsDate = dateFromString(lhs.key)
          let rhsDate = dateFromString(rhs.key)
          return (lhsDate ?? Date.distantFuture) < (rhsDate ?? Date.distantFuture)
      }
      
      return grouped
  }


    // Helper function to convert date string to Date
    private func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.date(from: dateString)
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

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(groupedMissionaries, id: \.key) { group in
                        VStack(alignment: .leading) {
                            Text(group.key) // Section header (date string)
                            .font(.title2)
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
        }
        .navigationTitle("Missionaries")
        .sheet(isPresented: Binding(
            get: { selectedMissionary != nil },
            set: { if !$0 { selectedMissionary = nil } }
        )) {
            if let missionary = selectedMissionary {
                MissionaryDetailView(missionary: missionary)
            }
        }
    }

    private func selectMissionary(_ missionary: Missionary) async {
        selectedMissionary = missionary
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms delay
    }
}