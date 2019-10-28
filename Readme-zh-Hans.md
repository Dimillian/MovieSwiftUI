# MovieSwiftUI
MovieSwiftUI 是一个用MovieDB的API以及SwiftUI构建的App。它展示了SwiftUI（&Combine)的概念。目标是只使用SwiftUI制作一个真实的app。它会随着SwiftUI框架的新功能而更新。
![App Image](images/MovieSwiftUI_promo_new.png?)

## 架构
MovieSwiftUI数据流是[Redux](https://redux.js.org/)的Flux部分的子集和自定义实现.它在[ObservableObject](https://developer.apple.com/documentation/combine/observableobject)中将State实现为@Published包装的属性，因此，只要分派的动作在减少之后产生新状态，就发布更改。这种状态作为环境对象被注入到根视图中，并且在程序中的任何地方都可以轻松访问。状态改变时，SwiftUI会在渲染过程中进行差异化的所有方面。从你的状态提取道具时，无需太聪明，它们在视图级别是简单的动态变量。无论对象的图形大小如何，SwiftUI的速度仅取决于视图层次结构的复杂性，而不是对象图的复杂性。

## SwiftUI
MovieSwiftUI是在纯粹的SwiftUI中，目标是看在不使用任何来自UIKit的东西(UIView/UIViewController）的情况下，SwiftUI在当前的实现中可以走多远。

## 平台
目前 MovieSwiftUI 运行在 iPhone, iPad, and macOS.
在[Twitter](https://twitter.com/dimillian) 上关注我，获得关于功能、代码和SwiftUI技巧的最新更新!