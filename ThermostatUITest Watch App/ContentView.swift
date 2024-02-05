//
//  ContentView.swift
//  SmartHomeThermostat
//
//  Created by Ali Mert Özhayta on 1.05.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color("Background").ignoresSafeArea()
                    VStack(spacing: 0) {
                        ThermometerView(screenSize: geometry.size)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Chambre")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
