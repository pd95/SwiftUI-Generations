# SwiftUI Generations

Apple brought many improvements to SwiftUI since the introduction in 2019 (in iOS 13) year over year.
But simetimes it is frustrating that you cannot use a certain functionality because it is meant to be used on the newer
OS version. For example: `AsyncImage`: this is not a View which does some magic. Everything it does can be done already
on iOS 13. It simply brings the "Apple approved" API.

So in this project I am trying to bring some of the new SwiftUI features of iOS 15 back to iOS 14 and even iOS 13 if
possible.

So far I have the following working (and compatible with iOS 15 SwiftUI API):

- `AsyncImage`
- `Label`
- iOS 15 `Color`s like `mint`, `teal`, `cyan`, `brown`
- initial parts of `ProgressView`

The sources can be found in the [Backports](Backports) directory. All `struct`s and `protocol`s have been amended with
with `@available` to make clear, as of which iOS target the source should be removed because SwiftUI contains the
native functionality.

The project consists of 3 targets which I use to test the implementations:

- iOS15-App: iOS 15.0 deployment target (and includes none of the backports)
- iOS14-App: iOS 14.5 deployment target (adding `AsyncImage` and new colors)
- iOS13-App: iOS 13.6 deployment target (adding all backports available)

Use Xcode 13 (currently in beta) to build and test the various apps.
