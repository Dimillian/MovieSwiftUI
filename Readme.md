# MovieSwiftUI

MovieSwiftUI is an application that uses the MovieDB API and is built with SwiftUI. 
It demos some SwiftUI (& Combine) concepts. The goal is to make a real world application using SwiftUI only. It'll be updated with new features as they come to the SwiftUI framework. 

![App Image](images/MovieSwiftUI_promo.png?)

## Architecture

MovieSwiftUI data flow is a subset and a custom implementation of the Flux part of [Redux](https://redux.js.org/). 
It implement the State as a [BindableObject](https://developer.apple.com/documentation/swiftui/bindableobject) and [publish](https://developer.apple.com/documentation/swiftui/binding/3264174-publisher) changes whenever a dispatched action produces a new state after being reduced. 
The state is injected as an environment object in the root view of the application, and is easily accessible anywhere in the application. 
SwiftUI does all aspects of diffing on the render pass when your state changes. No need to be clever when extracting props from your State, they're simple dynamic vars at the view level. No matter your objects' graph size, SwiftUI speed depends on the complexity of your views hierarchy, not the complexity of your object graph.

## SwiftUI

MovieSwiftUI is in pure Swift UI, the goal is to see how far SwiftUI can go in its current implementation without using anything from UIKit (basically no UIView/UIViewController representable).

It'll evolve with SwiftUI, every time Apple edits existing or adds new features to the framework.

## Platforms

Currently MovieSwiftUI runs on iPhone, iPad, and macOS. 

Follow me on [Twitter](https://twitter.com/dimillian) to get the latest update about features, code and SwiftUI tips and tricks! 

## Known issues

As for Xcode 11 beta 4, the application have quite a lot of issues, that are mainly due to SwiftUI bugs (unless I'm proven wrong :p)

* On the movie detail page, it's impossible to navigate to individual people and movie, as it's NavigationLink nested in a ScrollView nested in a List. (Known issue by Apple, as noted in release note). 
* Search on the main list is can be very slow, as List is very slow to update since beta 4
* Crash in custom list movies search since beta 4. Unknown reason, I can't track it down. I guess it's due to List changes.
* The app will slow down as you navigate into it, for some reason, SwiftUI never release its subscribers from views, so state update will take more and more times as more and more (dead) views will listen and update from it. Present since beta 1 and reported to Apple.
* The TextField for searching covers in the custom list form is moving the caret on its own, preventing correct typing. New since beta 4. 
* The animations on the DiscoverView are slow, new since beta 4
