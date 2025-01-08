//
//  Missionary_FlashApp.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/6/25.
//

import SwiftUI
import SwiftData

@main
struct Missionary_FlashApp
: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Missionary.self)
                .onAppear {
                    importCSVData()
                }
        }
    }

    private func importCSVData() {
        guard let container = try? ModelContainer(for: Missionary.self) else {
            print("Failed to configure ModelContainer")
            return
        }

        let context = container.mainContext

        // Check if data already exists
        do {
            let missionaryCount = try context.fetch(FetchDescriptor<Missionary>()).count
          print("missionary.count: \(missionaryCount)")
            if missionaryCount > 0 {
                return
            }
        } catch {
            print("Error checking existing data: \(error.localizedDescription)")
            return
        }

        // Import CSV data
        guard let csvPath = Bundle.main.path(forResource: "missionaries", ofType: "csv") else {
            return
        }
        do {
            let csvContent = try String(contentsOfFile: csvPath, encoding: .utf8)
            let missionaries = parseCSV(csvContent)
            missionaries.forEach { context.insert($0) }

            // Save to persistent storage
            try context.save()
            print("CSV data imported successfully")
        } catch {
            print("Failed to import CSV data: \(error.localizedDescription)")
        }
    }

    private func parseCSV(_ csvContent: String) -> [Missionary] {
        var missionaries = [Missionary]()
        let rows = csvContent.components(separatedBy: "\n").filter { !$0.isEmpty }

        // Remove the header row
        let dataRows = rows.dropFirst()

        for row in dataRows {
            let columns = row.components(separatedBy: ",") // Adjust delimiter if needed
            if columns.count == 15 {
                let missionary = Missionary(
                    name: columns[0],
                    photoName: columns[1],
                    city: columns[2],
                    state: columns[3],
                    country: columns[4],
                    startDate: columns[5],
                    endDate: columns[6],
                    hobbies: columns[7],
                    title: columns[8],
                    name1: columns[9],
                    name2: columns[10],
                    name3: columns[11],
                    name4: columns[12],
                    name5: columns[13],
                    name6: columns[14]
                )
                missionaries.append(missionary)
            }
        }
        return missionaries
    }
}

