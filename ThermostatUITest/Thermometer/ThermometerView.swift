import SwiftUI

enum Room: String, CaseIterable {
    case Chambre = "Chambre"
    case TVRoom = "TV Room"
    case Cuisine = "Cuisine"
}

struct ThermometerView: View {
    var room: Room
    var screenSize: CGSize
    private let baseRingSize: CGFloat = 180
    private let baseOuterDialSize: CGFloat = 170
    private let minTemperature: CGFloat = 10
    private let maxTemperature: CGFloat = 30

    @State private var currentTemperature: CGFloat = 0
    @State private var degrees: CGFloat = 36
    @State private var showStatus = false
    @State private var crownRotationValue: Double = 0 // Track digital crown rotation
    @State private var currentRoom: Room = .Chambre
    
    private var ringSize: CGFloat {
        baseRingSize
    }
    private var outerDialSize: CGFloat {
        baseOuterDialSize
    }
    var targetTemperature: CGFloat {
        return min(max(degrees / 360 * 40, minTemperature), maxTemperature)
    }
    var ringValue: CGFloat {
        currentTemperature / 40
    }
    
    var body: some View {
        ZStack {
            ThermometerScaleView()
            // Temperature Ring
            Circle()
                .trim(from: 0.25, to: min(ringValue, 0.75)) //Adjust beginning and end values of drag ring
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("Temperature Ring 1"), Color("Temperature Ring 2")]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round)
                )
                .frame(width: ringSize, height: ringSize)
                .rotationEffect(.degrees(90))
                .animation(.linear(duration: 1), value: ringValue)
            
            // Thermometer Dial
            // Assuming ThermometerDialView is adjusted for scaling
            ThermometerDialView(outerDialSize: outerDialSize, degrees: degrees)
                .focusable()
                .digitalCrownRotation($currentTemperature, from: 10, through: 30, by: 1, sensitivity: .low)
                .gesture(
                      DragGesture()
                          .onChanged { value in
                              let x = min(max(value.location.x, 0), outerDialSize)
                              let y = min(max(value.location.y, 0), outerDialSize)
                              
                              let endPoint = CGPoint(x: x, y: y)
                              let centerPoint = CGPoint(x: outerDialSize / 2, y: outerDialSize / 2)
                              
                              let angle = calculateAngle(centerPoint: centerPoint, endPoint: endPoint)
                              
                              if angle < 90 || angle > 270 { return }  // Minimum and maximum angle of temperature ring
                              
                              degrees = angle - angle.remainder(dividingBy: 9)
                              // Update currentTemperature based on the new degrees
                              let newTemperature = min(max(degrees / 360 * 40, minTemperature), maxTemperature)
                              currentTemperature = newTemperature
                          }
                  )
            
            // Thermometer Summary
            // Assuming ThermometerSummaryView adjusts its layout based on scalingFactor
            ThermometerSummaryView(
//                status: status,
//                showStatus: showStatus,
                temperature: currentTemperature
            )
        }
        .onAppear {
            currentTemperature = 22 // Example initial value
            degrees = currentTemperature / 40 * 360
            print("Degrees: \(degrees)")
        }
        .onChange(of: currentTemperature) { degrees = currentTemperature / 40 * 360
        }
    }

    private func calculateAngle(centerPoint: CGPoint, endPoint: CGPoint) -> CGFloat {
        let radians = atan2(endPoint.x - centerPoint.x, centerPoint.y - endPoint.y)
        let degrees = 180 + (radians * 180 / .pi)
        return degrees
    }
}

struct ThermometerView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            ThermometerView(room: .Chambre, screenSize: geometry.size)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Background"))
        }
    }
}
