//
//  ViewOnChangeDemo.swift
//  ViewOnChangeDemo
//
//  Created by Philipp on 25.08.21.
//

#if canImport(SwiftUIShim)
import SwiftUIShim
#else
import SwiftUI
#endif

struct ViewOnChangeDemo: View {
    @State private var count = 0
    @State private var color = Color.teal

    var body: some View {
        VStack {
            Text("Counter: \(count)")
                .padding()
            Button("Increment") {
                count += 1
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(color))
            .foregroundColor(.white)
        }
        .onChange(of: count) { newValue in
            let remainder = newValue % 4
            print("onChange: \(newValue) => \(remainder)")
            switch remainder {
            case 0:
                color = .teal
            case 1:
                color = .red
            case 2:
                color = .blue
            default:
                color = .yellow
            }
        }
    }
}

struct ViewOnChangeDemo_Previews: PreviewProvider {
    static var previews: some View {
        ViewOnChangeDemo()
    }
}
