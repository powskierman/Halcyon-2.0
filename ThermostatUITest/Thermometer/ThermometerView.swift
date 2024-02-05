import SwiftUI

enum Status: String {
    case heating = "HEATING"
    case cooling = "COOLING"
    case reaching = "REACHING"
}

struct ThermometerView: View {
    var screenSize: CGSize
    
    // Base dimensions for scaling calculations
    private let baseWidth41mm: CGFloat = 162 // Base width for scaling calculation
    private let baseRingSize: CGFloat = 200
    private let baseOuterDialSize: CGFloat = 180
    private let minTemperature: CGFloat = 4
    private let maxTemperature: CGFloat = 30

    @State private var currentTemperature: CGFloat = 0
    @State private var degrees: CGFloat = 36
    @State private var showStatus = false

    // Dynamic scaling factors
    private var scalingFactor: CGFloat {
        (screenSize.width / baseWidth41mm) * 0.75
    }
    // Adjusted scaling factor for ThermometerScaleView to scale it down
     private var adjustedScaleFactorForScaleView: CGFloat {
         scalingFactor * 0.95 // Example: scale down by 10%
     }
    private var ringSize: CGFloat {
        baseRingSize * scalingFactor
    }
    private var outerDialSize: CGFloat {
        baseOuterDialSize * scalingFactor
    }

    var targetTemperature: CGFloat {
        return min(max(degrees / 360 * 40, minTemperature), maxTemperature)
    }

    var ringValue: CGFloat {
        currentTemperature / 40
    }
    
    var status: Status {
        if currentTemperature < targetTemperature {
            return .heating
        } else if currentTemperature > targetTemperature {
            return .cooling
        } else {
            return .reaching
        }
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Integrate ThermometerScaleView with the appropriate scaling factor
            ThermometerScaleView(scaleFactor: adjustedScaleFactorForScaleView)

            
            // Temperature Ring
            Circle()
                .inset(by: 5 * scalingFactor)
                .trim(from: 0.1, to: min(ringValue, 0.75))
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("Temperature Ring 1"), Color("Temperature Ring 2")]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: 10 * scalingFactor, lineCap: .round, lineJoin: .round)
                )
                .frame(width: ringSize, height: ringSize)
                .rotationEffect(.degrees(90))
                .animation(.linear(duration: 1), value: ringValue)
            
            // Thermometer Dial
            // Assuming ThermometerDialView is adjusted for scaling
            ThermometerDialView(outerDialSize: outerDialSize, degrees: degrees)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let x = min(max(value.location.x, 0), outerDialSize)
                            let y = min(max(value.location.y, 0), outerDialSize)
                            
                            let endPoint = CGPoint(x: x, y: y)
                            let centerPoint = CGPoint(x: outerDialSize / 2, y: outerDialSize / 2)
                            
                            let angle = calculateAngle(centerPoint: centerPoint, endPoint: endPoint)
                            
                            if angle < 36 || angle > 270 { return }
                         
                            degrees = angle - angle.remainder(dividingBy: 9)
                        }
                )
            
            // Thermometer Summary
            // Assuming ThermometerSummaryView adjusts its layout based on scalingFactor
            ThermometerSummaryView(
                status: status,
                showStatus: showStatus,
                temperature: currentTemperature
            )
        }
        .onAppear {
            currentTemperature = 22 // Example initial value
            degrees = currentTemperature / 40 * 360
        }
        .onReceive(timer) { _ in
            switch status {
            case .heating:
                showStatus = true
                currentTemperature += 1
            case .cooling:
                showStatus = true
                currentTemperature -= 1
            case .reaching:
                showStatus = false
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
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
        ThermometerView(screenSize: CGSize(width: 184, height: 224)) // Simulate 45mm watch size
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}
