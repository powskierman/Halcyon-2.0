import SwiftUI

struct ThermometerScaleView: View {
    var scaleFactor: CGFloat

    private var scaleDiameter: CGFloat {
        246 * scaleFactor
    }

    private var radius: CGFloat {
        scaleDiameter / 2
    }

    var body: some View {
        ZStack {
            // Adjust ForEach to rotate positions by 180 degrees
            ForEach(0..<24) { index in
                if index == 6 { // Adjust "20" to be at the bottom now
                    temperatureMarking(text: "20", at: 270)
                } else if index == 12 { // Adjust "10" to be on the left now
                    temperatureMarking(text: "10", at: 180)
                } else if index == 18 { // Adjust "30" to be on the left now
                    temperatureMarking(text: "30", at: 360)
                } else {
                    // Draw tick marks for all other indices with rotation adjustment
                    tickMark(forIndex: index, totalTicks: 24)
                }
            }
        }
        .frame(width: scaleDiameter, height: scaleDiameter)
    }

    private func tickMark(forIndex index: Int, totalTicks: Int) -> some View {
        let angle = (Double(index) / Double(totalTicks)) * 360.0 + 180 // Rotate by 180 degrees
        let tickRotation = Angle(degrees: angle)

        return Rectangle()
            .fill(Color.white)
            .frame(width: 2 * scaleFactor, height: 10 * scaleFactor)
            .offset(x: 0, y: -radius * 0.85)
            .rotationEffect(tickRotation)
    }

    private func temperatureMarking(text: String, at angle: Double) -> some View {
        let adjustedAngle = angle.truncatingRemainder(dividingBy: 360) // Ensure angle stays within 0-360
        let angleRadians = adjustedAngle * Double.pi / 180
        let xPosition = radius + cos(angleRadians) * radius * 0.85
        let yPosition = radius + sin(angleRadians) * radius * 0.85

        return Text(text)
            .font(.system(size: 12 * scaleFactor))
            .foregroundColor(.white)
            .position(x: xPosition, y: yPosition)
    }
}

struct ThermometerScaleView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerScaleView(scaleFactor: 1)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
