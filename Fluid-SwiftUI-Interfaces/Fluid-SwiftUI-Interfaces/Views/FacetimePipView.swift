//
//  FacetimePipView.swift
//  Fluid-SwiftUI-Interfaces
//
//  Created by Wayne Dahlberg on 1/13/23.
//

import SwiftUI

struct FacetimePipView: View {
  
  @Environment(\.colorScheme) private var colorScheme
  
  @State private var roundedRectanglePosition: RoundedRectanglePosition = .topLeading
  @State private var predictedEndLocation: CGPoint = .zero
  @State private var currentVelocity: CGFloat = .zero
  @State private var currentPosition: CGSize = .zero
  @State private var newPosition: CGSize = .zero
  
  var body: some View {
    ZStack {
      GeometryReader { geo in
        let geometryWidth = geo.size.width
        let geometryHeight = geo.size.height
        
        background
        filledRoundedRectangle
          .offset(x: currentPosition.width,
                  y: currentPosition.height)
          .gesture(
            DragGesture()
              .onChanged { value in
                self.currentPosition = CGSize(
                  width: value.translation.width + self.newPosition.width,
                  height: value.translation.height + self.newPosition.height)
              }
              .onEnded { value in
                self.predictedEndLocation = value.predictedEndLocation
                
                let currentVelocityX = (value.predictedEndLocation.x - value.location.x) / value.predictedEndLocation.x
                
                let currentVelocityY = (value.predictedEndLocation.y - value.location.y) / value.predictedEndLocation.y
                
                self.currentVelocity = sqrt(pow(currentVelocityX, 2) + pow(currentVelocityY, 2))
                
                self.roundedRectanglePosition = getRoundedRectPosition(geo, predictedEndLocation) ?? .topLeading
                
                switch roundedRectanglePosition {
                case .topLeading:
                  newPosition = CGSize(width: 0, height: 0)
                case .topTrailing:
                  newPosition = CGSize(width: geometryWidth - 120, height: 0)
                case .bottomLeading:
                  newPosition = CGSize(width: 0, height: geometryHeight - 180)
                case .bottomTrailing:
                  newPosition = CGSize(width: geometryWidth, height: geometryHeight)
                }
                
                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 134.0, damping: 16.0, initialVelocity: Double(currentVelocity)
                                                  )) {
                  self.currentPosition = self.newPosition
                }
              }
          )
      }
    }
  }
  
  private enum RoundedRectanglePosition {
    case topLeading, topTrailing, bottomLeading, bottomTrailing
  }
  
  // Views
  
  // MARK: - RoundedRectangleView
  
  
  
  // functions
  
  // get quadrant orientation
  private func getRoundedRectPosition(_ geometry: GeometryProxy, _ predictedEndLocation: CGPoint) -> RoundedRectanglePosition? {
    let geometryX = geometry.size.width
    let geometryY = geometry.size.height
    let predictedX = predictedEndLocation.x
    let predictedY = predictedEndLocation.y
    
    if predictedX < geometryX / 2, predictedY < geometryY / 2 {
      return .topLeading
    } else if predictedX > geometryX / 2, predictedY < geometryY / 2 {
      return .topTrailing
    } else if predictedX < geometryX / 2, predictedY > geometryY {
      return .bottomLeading
    } else if predictedX > geometryX, predictedY > geometryY {
      return .bottomTrailing
    } else {
      return nil
    }
  }
}

// MARK: - custom views

struct FormattedNumberView: View {
  @Binding var num: CGFloat
  
  var body: some View {
    Text("\(num, specifier: "%.2f")")
      .font(.system(.body).monospacedDigit().bold())
      .animation(nil)
  }
}

struct RoundedRectangleView: View {
  @State var isFilled: Bool
  
  let linearGradient = LinearGradient(colors: [.topColor, .bottomColor], startPoint: .top, endPoint: .bottom)
  
  var body: some View {
    Group {
      if isFilled {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .fill(linearGradient)
      } else {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .fill(Color.clear)
          .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
              .stroke(Color.gray, lineWidth: 2)
          }
      }
    }
    .frame(width: 120, height: 180, alignment: .center)
  }
}

// MARK: - Extensions

extension FacetimePipView {
  var roundedRectangle: some View {
    RoundedRectangleView(isFilled: false)
  }
  
  var filledRoundedRectangle: some View {
    RoundedRectangleView(isFilled: true)
  }
  
  var background: some View {
    HStack {
      VStack {
        roundedRectangle
        Spacer()
        roundedRectangle
      }
      Spacer()
      VStack {
        roundedRectangle
        Spacer()
        roundedRectangle
      }
    }
  }
  
  var debugView: some View {
    VStack(alignment: .center, spacing: 8) {
      Text("Current Velocity")
        .textCase(.uppercase)
      
      FormattedNumberView(num: $currentVelocity)
      
      Text("Current Position")
        .textCase(.uppercase)
      HStack(spacing: 0) {
        Text("(")
        FormattedNumberView(num: $currentPosition.height)
        Text(", ")
        FormattedNumberView(num: $currentPosition.width)
        Text(")")
      }
    }
    .foregroundColor(.white)
    .padding()
    .background(RoundedRectangle(cornerRadius: 8)
      .fill(
        colorScheme == .dark ?
        Color.white.opacity(0.3) : Color.black.opacity(0.3)
      ))
  }
}

private extension Color {
  static let topColor = Color(red: 0.95, green: 0.95, blue: 0.23)
  static let bottomColor = Color(red: 0.97, green: 0.65, blue: 0.11)
}


struct FacetimePipView_Previews: PreviewProvider {
  static var previews: some View {
    FacetimePipView()
  }
}
