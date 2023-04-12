//
//  CalculatorButtonView.swift
//  Fluid-SwiftUI-Interfaces
//
//  Created by Wayne Dahlberg on 4/16/22.
//

import SwiftUI

struct CalculatorButtonView: View {
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct CalculatorButtonView_Previews: PreviewProvider {
  static var previews: some View {
    CalculatorButtonView()
  }
}

// MARK: - CalculatorButton buttonStyle

struct CalculatorButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .foregroundColor(Color.white)
      .font(.largeTitle)
      .background(
        Circle()
          .foregroundColor(
            configuration.isPressed ? Color("highlightButtonColor") : Color("normalButtonColor"))
      )
      .cornerRadius(8.0)
  }
}
