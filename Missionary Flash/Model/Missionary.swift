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
  var photoName: String
  var city: String
  var state: String
  var country: String
  var startDate: String
  var endDate: String
  var hobbies: String
  var title: String
  
  // Computed property for first and last name only
  var fnamelname: String {
    let nameComponents = name.split(separator: " ")
    guard var first = nameComponents.first, let last = nameComponents.last else {
      return name // Fallback to full name if splitting fails
    }
    if first == "Sister" {
      first = "Hermana"
    }
    return "\(first) \(last)"
  }
  
  // Computed property for last name only
  var lname: String {
    let nameComponents = name.split(separator: " ")
    guard let last = nameComponents.last else {
      return name
    }
    return "\(last)"
  }
  
  // Computed property to determine the short name
  var shortname: String {
      var genderPrefix = "Elder" // Default value
      
      switch title {
      case "Sister":
          genderPrefix = "Hermana"
          return "\(genderPrefix) \(lname)"
      case "Elder":
          genderPrefix = "Elder"
          return "\(genderPrefix) \(lname)"
      case "Senior":
          let nameComponents = name.split(separator: " ")
          guard let first = nameComponents.first else {
              return name // Fallback to full name if splitting fails
          }
          if first == "Sister" {
              genderPrefix = "Hermana"
          } else if first == "Elder" {
              genderPrefix = "Elder"
          }
          return "\(genderPrefix) \(lname)"
      default:
          genderPrefix = "Elder"
          return "\(genderPrefix) \(lname)"
      }
  }

  
  init(id:UUID, name: String, photoName: String, city: String, state: String, country: String, startDate: String, endDate: String, hobbies: String, title: String) {
    self.name = name
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
    case name, photoName, city, state, country, startDate, endDate, hobbies, title
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
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
