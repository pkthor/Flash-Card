//
//  InfoView.swift
//  Missionaries
//
//  Created by P. Kurt Thorderson on 2/13/25.
//

import SwiftUI

struct InfoView: View {
  let dateofTransfer: String = "16 Mar 2025"
  var body: some View {
    Text("Updated: ")
    Text(dateofTransfer)
      .foregroundColor(.yellow)
  }
}

