//
//  Missionary_FlashApp.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/8/25.
//

import SwiftUI
import SwiftData

@main
struct Missionary_FlashApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Missionary2.self)
                .onAppear {
                    importJSONData()
                }
        }
    }

  private func importJSONData() {
      guard let container = try? ModelContainer(for: Missionary2.self) else {
          print("Failed to configure ModelContainer")
          return
      }

      let context = container.mainContext

      // Check if data already exists
      do {
          let missionaryCount = try context.fetch(FetchDescriptor<Missionary2>()).count
          print("missionary.count: \(missionaryCount)")
          if missionaryCount > 0 {
              return
          }
      } catch {
          print("Error checking existing data: \(error.localizedDescription)")
          return
      }

      // Import JSON data
    guard let url = Bundle.main.url(forResource: "outputPKT", withExtension: "json") else {
        print("Failed to find JSON file.")
        return
    }
    // Log the file URL to verify
    print("JSON file found at: \(url)")
    do {
        let jsonData = try Data(contentsOf: url)
        let missionaries = try JSONDecoder().decode([Missionary2].self, from: jsonData)
        missionaries.forEach { context.insert($0) }

        // Save to persistent storage
        try context.save()
        print("JSON data imported successfully")
      print(missionaries)
    } catch {
        print("Failed to import JSON data: \(error.localizedDescription)")
    }

  }


    private func parseJSON(_ jsonData: Data) throws -> [Missionary2] {
        let decoder = JSONDecoder()

        do {
            // Decode the JSON into an array of dictionaries
            let missionaries = try decoder.decode([Missionary2].self, from: jsonData)
            return missionaries
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
            throw error
        }
    }
}
