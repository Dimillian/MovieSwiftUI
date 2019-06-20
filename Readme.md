# MovieSwiftUI

MovieSwiftUI is an application using the MovieDB API built with SwiftUI. 
It demo some SwiftUI (& Combine) concepts and the goal is to make a real world application using SwiftUI only. It'll be updated with future features coming to the SwiftUI framework. 

![App Image](images/MovieSwiftUI.png?)

## Architecture

MovieSwiftUI data flow is a subset and a custom implement of the Flux part from [Redux](https://redux.js.org/). 
It implement the State as a [BindableObject](https://developer.apple.com/documentation/swiftui/bindableobject) and [publish](https://developer.apple.com/documentation/swiftui/binding/3264174-publisher) changes whenever an action dispatched produce a new state after being reduced. 
The state is injected as en environment object in the root view of the application, and easily accessible anywhere in the application. 
SwiftUI does all the job for the diffing on the render pass when your state change. No need to be clever when extracting props from your State, they're simple dynamic var at the view level. No matter your objects graphs size, SwiftUI speed depend of the complexity of your views hierarchy, not the complexity of your object graph.

## SwiftUI

MovieDBSwiftUI is in pure Swift UI, the goal is to see how far SwiftUI can go in its current implementation without using anything form UIKit. (Basically no UIView/UIViewController representable)

It'll evolve with SwiftUI, everty time Apple edit or add new features to the framework.

## Platforms

Currently MovieDBSwiftUI run on iPhone, iPad, and macOS. 