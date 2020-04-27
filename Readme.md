![Xcode build](https://github.com/Dimillian/MovieSwiftUI/workflows/Xcode%20build/badge.svg?branch=master)

# MovieSwiftUI

MovieSwiftUI is an application that uses the MovieDB API and is built with SwiftUI. 
It demos some SwiftUI (& Combine) concepts. The goal is to make a real world application using SwiftUI only. It'll be updated with new features as they come to the SwiftUI framework. 

I have written a series of articles that document the design and architecture of the app: [Making a Real World Application With SwiftUI](https://medium.com/better-programming/collection-making-a-real-world-application-with-swiftui-4f9bc8c7fb71).

![App Image](images/MovieSwiftUI_promo_new.png?)

## Architecture

MovieSwiftUI data flow is a subset and a custom implementation of the Flux part of [Redux](https://redux.js.org/). 
It implement the State in an [ObservableObject](https://developer.apple.com/documentation/combine/observableobject) as a @Published wrapped property, so changes are published whenever a dispatched action produces a new state after being reduced. 
The state is injected as an environment object in the root view of the application, and is easily accessible anywhere in the application. 
SwiftUI does all aspects of diffing on the render pass when your state changes. No need to be clever when extracting props from your State, they're simple dynamic vars at the view level. No matter your objects' graph size, SwiftUI speed depends on the complexity of your views hierarchy, not the complexity of your object graph.

## SwiftUI

MovieSwiftUI is in pure Swift UI, the goal is to see how far SwiftUI can go in its current implementation without using anything from UIKit (basically no UIView/UIViewController representable).

It'll evolve with SwiftUI, every time Apple edits existing or adds new features to the framework.

## Platforms

Currently MovieSwiftUI runs on iPhone, iPad, and macOS. 

Follow me on [Twitter](https://twitter.com/dimillian) to get the latest update about features, code and SwiftUI tips and tricks! 
