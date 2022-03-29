//
//  ListDemo.swift
//  DemoApp
//
//  Created by Philipp on 29.03.22.
//

import SwiftUIShim

struct ListDemo: View {
    struct NamedItem: Identifiable {
        let name: String
        let id = UUID()
    }

    private var oceans = [
        NamedItem(name: "Pacific"),
        NamedItem(name: "Atlantic"),
        NamedItem(name: "Indian"),
        NamedItem(name: "Southern"),
        NamedItem(name: "Arctic")
    ]

    private var continents = [
        NamedItem(name: "Asia"),
        NamedItem(name: "Africa"),
        NamedItem(name: "North America"),
        NamedItem(name: "South America"),
        NamedItem(name: "Antarctica"),
        NamedItem(name: "Australia"),
        NamedItem(name: "Europe"),
    ]

    var body: some View {
        NavigationView {
            List {
                Section("Simple Header") {
                    Text("Some item")
                    Text("Something else")
                    Text("One more")
                }

                Section {
                    ForEach(continents) {
                        Text($0.name)
                    }
                } header: {
                    Text("Continents")
                        .font(.headline)
                } footer: {
                    Text("Source: Wikipedia")
                }

                Section {
                    ForEach(oceans) {
                        Text($0.name)
                    }
                } header: {
                    Text("Oceans")
                } footer: {
                    Toggle("Show", isOn: .constant(true))
                }
            }
            .listStyle(.grouped)
            .navigationTitle("List Demo")
        }
        .navigationViewStyle(.stack)
    }
}

struct ListDemo_Previews: PreviewProvider {
    static var previews: some View {
        ListDemo()
    }
}
