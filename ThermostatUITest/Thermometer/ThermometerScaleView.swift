import SwiftUI

struct ThermometerScaleView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<24) { index in
                    if index == 6 {
                        temperatureMarking(text: "20", at: 270, geometry: geometry)
                    } else if index == 12 {
                        temperatureMarking(text: "10", at: 180, geometry: geometry)
                    } else if index == 18 {
                        temperatureMarking(text: "30", at: 360, geometry: geometry)
                    } else {
                        tickMark(forIndex: index, totalTicks: 24, geometry: geometry)
                    }
                }
            }
        }
    }

    private func tickMark(forIndex index: Int, totalTicks: Int, geometry: GeometryProxy) -> some View {
        let scaleDiameter = min(geometry.size.width, geometry.size.height)
        let radius = scaleDiameter / 2
        let angle = (Double(index) / Double(totalTicks)) * 360.0 + 180
        let tickRotation = Angle(degrees: angle)

        return Rectangle()
            .fill(Color.white)
            .frame(width: scaleDiameter * 0.008, height: scaleDiameter * 0.04)
            .offset(x: 0, y: -radius)
            .rotationEffect(tickRotation)
    }

    private func temperatureMarking(text: String, at angle: Double, geometry: GeometryProxy) -> some View {
        let scaleDiameter = min(geometry.size.width, geometry.size.height)
        let radius = scaleDiameter / 2
        let adjustedAngle = angle.truncatingRemainder(dividingBy: 360)
        let angleRadians = adjustedAngle * Double.pi / 180
        let xPosition = radius + cos(angleRadians) * radius * 1.0
        let yPosition = radius + sin(angleRadians) * radius * 1.0

        return Text(text)
            .font(.system(size: scaleDiameter * 0.05))
            .foregroundColor(.white)
            .position(x: xPosition, y: yPosition)

    }
}

struct ThermometerScaleView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerScaleView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
