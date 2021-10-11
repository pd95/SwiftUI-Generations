//
//  NewColorsDemo.swift
//  NewColorsDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUIShim

struct NewColorsDemo: View {
    var body: some View {
        VStack {
            Text("New SwiftUI colors:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Showing new Colors in light mode
            HStack(spacing: 2) {
                Text("Light: ")
                Group {
                    Color.mint
                    Color.teal
                    Color.cyan
                    Color.indigo
                    Color.brown
                }
                .frame(width: 50, height: 50)
                .environment(\.colorScheme, .light)
            }

            // New Colors in dark mode
            HStack(spacing: 2) {
                Text("Dark: ")
                Group {
                    Color.mint
                    Color.teal
                    Color.cyan
                    Color.indigo
                    Color.brown
                }
                .frame(width: 50, height: 50)
                .environment(\.colorScheme, .dark)
            }
        }
        .padding()
    }
}

struct NewColorsDemo_Previews: PreviewProvider {
    static var previews: some View {
        NewColorsDemo()
    }
}
