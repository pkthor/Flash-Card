//
//  InfoView.swift
//  Missionaries
//
//  Created by P. Kurt Thorderson on 2/13/25.
//

import SwiftUI

struct InfoView: View {
  let dateofTransfer: String = "23 Feb 2025"
  var body: some View {
    Text("Updated: ")
    Text(dateofTransfer)
      .foregroundColor(.yellow)
  }
}

