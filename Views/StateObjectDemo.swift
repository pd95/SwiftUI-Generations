//
//  StateObjectDemo.swift
//  StateObjectDemo
//
//  Created by Philipp on 23.08.21.
//

import SwiftUI

struct StateObjectDemo: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink("Child using onChange", destination: ViewOnChangeDemo())

                Section {
                    NavigationLink("Child with StateObject", destination: StateObjectTestView())
                }

            }
        }
        //.navigationViewStyle(.stack)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

class TestObject: ObservableObject, CustomStringConvertible {
    @Published var num: Int = 0

    init() {
        print("🟢 TestObject init")
    }

    var description: String {
        "TestObject(num: \(num))"
    }
}

struct StateObjectTestView: View {
    @StateObject var stateObject = TestObject()

    var body: some View {
        VStack {
            Text("A StateObject is reinitialized whenever the view hierarchy is recreated.")
                .minimumScaleFactor(0.99)

            Divider()

            Text("Number: \(stateObject.num)")
                .padding()
            Button("Increase", action: {
                stateObject.num += 1
                print("State object: \(stateObject.num)")
            })
        }
        .padding()
        .onChange(of: stateObject.num) { newStateObject in
            print("State: \(newStateObject) <> \(stateObject.num)")
        }
    }
}

struct StateObjectDemo_Previews: PreviewProvider {
    static var previews: some View {
        StateObjectDemo()
    }
}
