//
//  StateObjectDemo.swift
//  StateObjectDemo
//
//  Created by Philipp on 23.08.21.
//

import SwiftUI

struct StateObjectDemo: View {
    @Environment(\.scenePhase) private var scenePhase
    @SceneStorage("textField") private var text: String = "Hello"
    @SceneStorage("toogleState") private var toggle: Bool = false
    @SceneStorage("lastNumber") private var lastNumber: Int?

    var body: some View {
        NavigationView {
            Form {
                Text("Scene phase: \(String(describing: scenePhase))")
                Section(header: Text("Preserved in scene")) {
                    TextField("Your name", text: $text)
                    Toggle("Active", isOn: $toggle)
                    Text("Last written number was: \(lastNumber == nil ? "-" : String(describing: lastNumber!) )")
                }
                .onChange(of: scenePhase) { newValue in
                    print("🟡 Scene phase changed to", newValue)
                }
                .onChange(of: text) { newValue in
                    if let newNumber = Int(newValue) {
                        print("newNumber = \(newNumber)")
                        lastNumber = newNumber
                    }
                }

                NavigationLink("Child using onChange", destination: ViewOnChangeDemo())

                Section {
                    NavigationLink("Child with StateObject", destination: StateObjectTestView())
                }

            }
            .navigationTitle("State Management")
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
        .navigationTitle(Text("@StateObject"))
    }
}

struct StateObjectDemo_Previews: PreviewProvider {
    static var previews: some View {
        StateObjectDemo()
    }
}
