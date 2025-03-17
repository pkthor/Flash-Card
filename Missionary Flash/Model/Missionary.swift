//
//  Missionary.swift
//  Missionary Flash
//
//  Created by P. Kurt Thorderson on 1/8/25.
//

import SwiftUI
import SwiftData

@Model
class Missionary: Identifiable, Codable {
  @Attribute(.unique) var name: String // Unique attribute to avoid duplicates
  var surname: String
  var photoName: String
  var city: String
  var state: String
  var country: String
  var startDate: String
  var endDate: String
  var hobbies: String
  var title: String
  
  var fnamelname: String {
    let parts = name.split(separator: ",")
    guard parts.count == 2 else { return name }
    let firstNames = parts[1].trimmingCharacters(in: .whitespaces)
    let lastName = parts[0].split(separator: " ").first ?? ""
    return "\(firstNames) \(lastName)"
  }
  
  var fnamesurname: String {
    let parts = name.split(separator: ",")
    guard parts.count == 2 else { return name }
    let firstNames = parts[1].trimmingCharacters(in: .whitespaces)
    return "\(firstNames) \(surname)"
  }
  
  // Computed property for last name only
  var lname: String {
    return name.split(separator: ",").first?.split(separator: " ").first.map(String.init) ?? name
  }
  
  // Computed property to determine the short name
  var shortname: String {
    let genderPrefix = title == "Sister" ? "Hermana" : "Elder"
    return "\(genderPrefix) \(surname)"
  }
  
  
  // Computed property for full name in correct order
  var fullOrderedName: String {
    let parts = name.split(separator: ",")
    guard parts.count == 2 else { return name }
    let firstNames = parts[1].trimmingCharacters(in: .whitespaces)
    let lastNames = parts[0].trimmingCharacters(in: .whitespaces)
    return "\(firstNames) \(lastNames)"
  }
  
  var startDateAsDate: Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MMM-yyyy"
    return dateFormatter.date(from: startDate)
  }
  
  var endDateAsDate: Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MMM-yyyy"
    return dateFormatter.date(from: endDate)
  }
  
  init(id:UUID, name: String, surname: String, photoName: String, city: String, state: String, country: String, startDate: String, endDate: String, hobbies: String, title: String) {
    self.name = name
    self.surname = surname
    self.photoName = photoName
    self.city = city
    self.state = state
    self.country = country
    self.startDate = startDate
    self.endDate = endDate
    self.hobbies = hobbies
    self.title = title
  }
  
  // MARK: - Codable Conformance
  
  enum CodingKeys: String, CodingKey {
    case name, surname, photoName, city, state, country, startDate, endDate, hobbies, title
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.surname = try container.decode(String.self, forKey: .surname)
    self.photoName = try container.decode(String.self, forKey: .photoName)
    self.city = try container.decode(String.self, forKey: .city)
    self.state = try container.decode(String.self, forKey: .state)
    self.country = try container.decode(String.self, forKey: .country)
    self.startDate = try container.decode(String.self, forKey: .startDate)
    self.endDate = try container.decode(String.self, forKey: .endDate)
    self.hobbies = try container.decode(String.self, forKey: .hobbies)
    self.title = try container.decode(String.self, forKey: .title)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(surname, forKey: .surname)
    try container.encode(photoName, forKey: .photoName)
    try container.encode(city, forKey: .city)
    try container.encode(state, forKey: .state)
    try container.encode(country, forKey: .country)
    try container.encode(startDate, forKey: .startDate)
    try container.encode(endDate, forKey: .endDate)
    try container.encode(hobbies, forKey: .hobbies)
    try container.encode(title, forKey: .title)
  }
}
