
# SwiftUI Generations

Apple brought many improvements to SwiftUI year over year since iOS 13 was introduced in 2019.
But sometimes it is frustrating that we cannot use certain functionality because it is meant to be
used with a more recent iOS version. `AsyncImage`, for example, is not a view doing magic tricks.
Everything it does can already be done on iOS 13. It simply is packaged in an "Apple approved" API
and therefore will be available for the next few years.

So if you are limited to use a non-current SwiftUI version (e.g. iOS 13 and iOS 14 as of September
2021), you can build workarounds for the missing features or use third party libraries which
implement the feature with their custom API.

With this project I'm proposing an alternate solution: we backport the new Apple APIs to iOS 13 in
the best/most compatible way. I'm trying to bring the most important SwiftUI features of iOS 14 and 15
back to iOS 13.

So far I have the following implemented:

- `AsyncImage`
- `Label` (including `LabelStyle` protocol and `LabelStyleConfiguration`)
- `ProgressView` (including `ProgressViewStyle` protocol and `ProgressViewStyleConfiguration`), but
  without tint color initializer.
- iOS 15 `Color`s like `mint`, `teal`, `cyan`, `indigo` and `brown`
- iOS 14 `Font`s like `title2`, `title3` and `caption2`
- `onChange(of: V, perform: @escaping (V) -> Void)` value tracker for iOS 13.
- `navigationTitle(...)` for iOS 13
- renamed `accessibilityXYZ(...)` modifiers for iOS 13
- `StateObject` object wrapper for iOS 13.
- `AppStorage` object wrapper for iOS 13 (including `defaultAppStorage()` View modifier).
- `SceneStorage` object wrapper for iOS 13. (Needs integration into `SceneDelegate` to manage the
  persistence of the values.)
- `ScenePhase` for iOS 13 (requires the custom `SceneManager` to hook into the `UIScene`)

The sources can be found in the [SwiftUIShim](SwiftUIShim) directory. All `struct`s and `protocol`s have
been amended with `@available` to make clear, as of which iOS target the shim would not be necessary as
SwiftUI contains native functionality.

The project consists of 2 main targets:

- `SwiftUIShim`: library implementing all necessary shims/polyfills to make a feature available on iOS 13/14
- `DemoApp`: implementing the basic demo screens using various SwiftUI features

The `SwiftUIShim` library and the `DemoApp` target are respecting the iOS deployment target set on the
Xcode project level in the build settings. You can set it to any value between 13.0 and 15.x, clean the
build folder and rebuild the `DemoApp`. A specific version of the library and demo app is created, which
can be tested on a respective simulator instance or iOS device.  
You can build different `DemoApp` instances for each major iOS release and compare them side by side, as
they all have different product names and bundle identifiers.

Use Xcode 13.2 to build and test.
