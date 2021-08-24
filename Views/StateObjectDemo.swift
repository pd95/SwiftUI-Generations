//
//  StateObjectDemo.swift
//  StateObjectDemo
//
//  Created by Philipp on 23.08.21.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var selected = false
    @Published var text = ""

    func reset() {
        withAnimation {
            selected = false
            text = ""
        }
    }
}

struct StateObjectDemo: View {

    @StateObject var model = ViewModel()

    init() {
        print("🟢 StateObjectDemo init called")
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Write something", text: $model.text)
                    Toggle("Selected", isOn: $model.selected)
                }

                NavigationLink("Child view", destination: ChildView(model: model))

                Section {
                    NavigationLink("Child with StateObject", destination: StateObjectTestView())
                }

            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ChildView: View {
    @ObservedObject var model: ViewModel

    var body: some View {
        VStack {
            Text("Hello world: \(model.text)")
                .navigationBarTitle("Child")

            Button("Reset") {
                model.reset()
            }
        }
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
//        .onChange(of: stateObject.num) { newStateObject in
//            print("State: \(newStateObject) <> \(stateObject.num)")
//        }
    }
}

struct StateObjectDemo_Previews: PreviewProvider {
    static var previews: some View {
        StateObjectDemo()
    }
}
