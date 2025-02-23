//
//  InfoView.swift
//  Missionaries
//
//  Created by P. Kurt Thorderson on 2/13/25.
//

import SwiftUI

struct InfoView: View {
  let dateofTransfer: String = "20 Feb 25"
  var body: some View {
    Text("For transfer date: ")
    Text(dateofTransfer)
      .foregroundColor(.yellow)
  }
}

