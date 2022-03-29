//
//  StateObjectDemo.swift
//  StateObjectDemo
//
//  Created by Philipp on 23.08.21.
//

import SwiftUIShim

struct StateObjectDemo: View {
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("username") private var username: String = ""
    @SceneStorage("textField") private var text: String = "Hello"
    @SceneStorage("toogleState") private var toggle: Bool = false
    @SceneStorage("lastNumber") private var lastNumber: Int?

    var body: some View {
        NavigationView {
            Form {
                Text("Scene phase: \(String(describing: scenePhase))")
                Section(header: Text("Preserved in app storage"), footer: Text("You have to delete the app to get rid of the values")) {
                    TextField("Your name", text: $username)
                }
                Section(header: Text("Preserved in scene")) {
                    TextField("Some text", text: $text)
                    Toggle("Active", isOn: $toggle)
                    Text("Last written number was: \(lastNumber == nil ? "-" : String(describing: lastNumber!) )")

                    SceneStorageDemoPicker()
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
        // .navigationViewStyle(.stack)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


// This view illustrates the `SceneStorage` property wrapper used with a `RawRepresentable` type.
// On iOS 14 there is no built-in support for optional RawRepresentable SceneStorage types, therefore
// this example builds differently when built for iOS 14 compared to iOS 13 or 15.
struct SceneStorageDemoPicker: View {

    enum MyEnum: String, CaseIterable {
        case a, b, c
    }

    #if TARGET_IOS_MAJOR_14
    // There is now RawRepresentable? available in iOS 14!
    @SceneStorage("selectedEntry") private var selectedEntry: MyEnum = .a
    #else
    @SceneStorage("selectedEntry") private var selectedEntry: MyEnum?
    #endif

    var body: some View {
        Picker("Selected entry", selection: $selectedEntry) {
            #if TARGET_IOS_MAJOR_14
            ForEach(MyEnum.allCases, id: \.rawValue) { entry in
                Text(entry.rawValue)
                    .tag(entry)
            }
            #else
            Text("None")
                .tag(Optional<MyEnum>.none)
            ForEach(MyEnum.allCases, id: \.rawValue) { entry in
                Text(entry.rawValue)
                    .tag(Optional(entry))
            }
            #endif
        }
    }
}

class TestObject: ObservableObject, CustomStringConvertible {
    @Published var num: Int = 0

    init() {
        print("🟢 TestObject init")
    }

    deinit {
        print("🔴 TestObject deinit")
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
