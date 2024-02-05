//
//  ThermometerDialView.swift
//  SmartHomeThermostat
//
//  Created by Ali Mert Özhayta on 1.05.2022.
//

import SwiftUI

struct ThermometerDialView: View {
    private let outerDialSize: CGFloat = 200
    private let innerDialSize: CGFloat = 172
    private let setpointSize: CGFloat = 15
    var degrees: CGFloat = 0

    var body: some View {
        ZStack {
            // MARK: Outer Dial
            Circle()
                .fill(
                    LinearGradient(colors: [Color("Outer Dial 1"), Color("Outer Dial 2")],
                                   startPoint: .leading, // or any other starting point you prefer
                                   endPoint: .trailing ))
                .frame(width: outerDialSize, height: outerDialSize)
                .shadow(color: .black.opacity(0.2), radius: 60, x: 0, y: 30) // drop shadow 1
                .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8) // drop shadow 2
                .overlay {
                    // MARK: Outer Dial Border
                    Circle()
                        .stroke(LinearGradient(colors: [.white.opacity(0.2), .black.opacity(0.19)],
                                startPoint: .leading,
                                endPoint: .trailing ), lineWidth: 1)
                }
                .overlay {
                    // MARK: Outer Dial Inner Shadow
                    Circle()
                        .stroke(.white.opacity(0.1), lineWidth: 4)
                        .blur(radius: 8)
                        .offset(x: 3, y: 3)
                        .mask {
                            Circle()
                                .fill(LinearGradient(colors: [.black, .clear],
                                        startPoint: .leading,
                                        endPoint: .trailing ))
                        }
                }
            
            // MARK: Inner Dial
            Circle()
                .fill(LinearGradient(colors: [Color("Inner Dial 1"), Color("Inner Dial 2")],
                            startPoint: .leading, 
                            endPoint: .trailing ))
                .frame(width: innerDialSize, height: innerDialSize)
            
            // MARK: Temperature Setpoint
            Circle()
                .fill(LinearGradient(colors: [Color("Temperature Setpoint 1"), Color("Temperature Setpoint 2")],
                        startPoint: .leading,
                        endPoint: .trailing ))
                .frame(width: setpointSize, height: setpointSize)
                .frame(width: innerDialSize, height: innerDialSize, alignment: .top)
                .offset(x: 0, y: 7.5)
                .rotationEffect(.degrees(degrees + 180))
                .animation(.easeInOut(duration: 1), value: degrees)

        }
    }
}

struct ThermometerDialView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerDialView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}
