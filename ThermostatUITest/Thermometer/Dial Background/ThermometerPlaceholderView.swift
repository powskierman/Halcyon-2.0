//
//  ThermometerPlaceholderView.swift
//  SmartHomeThermostat
//

import SwiftUI

struct ThermometerPlaceholderView: View {
    private let placeholderSize: CGFloat = 244
    
    var body: some View {
        Circle()
            .fill(LinearGradient(
                colors: [
                    Color("Placeholder 1"),
                    Color("Placeholder 2")
                ],
                startPoint: .leading, // or any other starting point you prefer
                endPoint: .trailing
            ))
            .frame(width: placeholderSize, height: placeholderSize)
            .shadow(
                color: Color("Placeholder Drop Shadow"),
                radius: 40, x: 0, y: 15
            )
            .overlay {
                // MARK: Placeholder Border
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                .black.opacity(0.36),
                                .white.opacity(0.11)
                            ],
                            startPoint: .leading, // or any other starting point you prefer
                            endPoint: .trailing
                        ),
                        lineWidth: 0.8
                    )
            }
            .overlay {
                // MARK: Placeholder Inner Shadow
                Circle()
                    .stroke(Color("Placeholder Inner Shadow"), lineWidth: 2)
                    .blur(radius: 7)
                    .offset(x:0, y: 3)
                    .mask {
                        Circle()
                            .fill(LinearGradient(colors: [.black, .clear], 
                                startPoint: .top,
                                endPoint: .bottom))
                    }
            }
    }
}

struct ThermometerPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerPlaceholderView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}
