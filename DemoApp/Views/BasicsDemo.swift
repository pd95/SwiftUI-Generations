//
//  BasicsDemo.swift
//  BasicsDemo
//
//  Created by Philipp on 02.09.21.
//

import SwiftUIShim

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
