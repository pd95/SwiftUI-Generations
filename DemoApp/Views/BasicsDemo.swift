//
//  BasicsDemo.swift
//  BasicsDemo
//
//  Created by Philipp on 02.09.21.
//

#if canImport(SwiftUIShim)
import SwiftUIShim
#else
import SwiftUI
#endif

struct BasicsDemo: View {
    var body: some View {
        StackNavigationView {
            ScrollView {
                NewColorsDemo()
                Divider()

                NewFontsDemo()
                Divider()

                LabelDemo()
                Divider()

                ProgressViewDemo()
                Spacer()
            }
            .navigationTitle("Basics Demo")
        }
    }
}

struct BasicsDemo_Previews: PreviewProvider {
    static var previews: some View {
        BasicsDemo()
    }
}
