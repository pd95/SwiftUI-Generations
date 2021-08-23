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

struct StateObjectDemo_Previews: PreviewProvider {
    static var previews: some View {
        StateObjectDemo()
    }
}
