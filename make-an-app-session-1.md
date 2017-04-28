
# Session 1

Swift crash course (group session)

API Uses:
- `DateFormatter`
- `Timer`
- `UIKit`
- `IB`
- `Closures` (Extra info section for leaks)

# 1.1 Hello world (Getting started)

Let's get started.

Click "Create a new Xcode Project". We'll make a "Single View Application". (We'll add more views later)

Use the following for the project details and uncheck "Use Core Data", "Include Unit Tests", and "Include UI Tests".
```
Product Name: FancyClock
Team: <Your Name> (Personal Team)
Organisation Name: iOS Bootcamp
Organisation Identifier: co.redeye.bootcamp
Language: Swift
Devices: Universal
[x] Use Core Data
[x] Include Unit Tests
[x] Include UI Tests
```

Hit next, select a location to save it and specify if you want to (or don't want to use git). We've got 'checkpoints' on git so you'll use it in one way or another today :)

Hit cmd-r or click the 'Run' button (Play button in the top left corner)

The simulator should launch and you'll see a white screen (an empty app).

Xcode overview: 4 areas. 3 editor modes.
Areas:
1. Editor
2. Navigator (left)
3. Debug area (bottom)
4. Utilities (right)

Toggle these in the top right corner.

Since it's now running, debugger is in the bottom. Debug controls are in there.

If you have any errors, they are in the error tab in the navigator cmd 4.

Hit cmd-1 to go to the project navigator.

Click on ViewController.swift

This is an empty UIViewController subclass, and your first look at swift code!

<details>
<summary>THE SWIFT PROJECT</summary>
Swift is a language designed to be "...a general-purpose programming language built using a modern approach to safety, performance, and software design patterns." Swift is a compiled language, and the project uses the LLVM compiler to produce machine-code so theoretically, binaries written in Swift can be run on embedded systems all the way up to server-side infrastructure.

The project also includes development on the LLVM compiler, package manager, and the creation of core libraries to support swift on platforms not managed by Apple, including server-focussed capabilities.

Later further reading on the philosophy of the language: https://swift.org/about/, https://swift.org/community
</details>

What we're seeing here is a class, one of swift's fundamental types, that inherits from UIViewController. (Swift also has Structs, Enums, and Closures. We'll see these guys layer.) The ViewController has two method stubs.

Hold down cmd and click on `UIViewController` in the source code.

You're now in the UIViewController header file! As you can see, there's a lot going on here. `UIViewController` handles _view lifecycle_ callbacks -- when a view controller's view will or did load / appear / disappear (`viewDidLoad()`), handles memory warnings (`didReceiveMemoryWarning()`), and coordinates navigation. Notice the `view` property. We'll come back that later.

Weirdly there's no swift function bodies in here. That's because all apple's frameworks are still written in Objective-C and swift plays nicely with them.

<details>
<summary>HISTORY LESSON</summary>
Objective-C was initially developed at NeXT for their NeXTSTEP operating system. NeXT was acquired by apple and NeXTSTEP became OSX, which has morphed into macOS, iOS, tvOS and watchOS. Objective-C is quite a dated language, and the Swift project is an attempt to bring updated practise into the language. To support swift's development, __swift has the capabilities to interact with every part of the objective-c runtime__. Swift indeed developed very quickly and three years later, swift is approaching Application Binary Interface (ABI) stability, which means that large frameworks can be developed without having to be maintained during every swift update (🎉), and UIKit can finally benefit from Swift's shiny new language features.

Later recommended reading: https://swift.org/contributing/, https://apple.github.io/swift-evolution/
</details>


Hit `cmd-shift-o` and type 'AD.s'. This should bring up AppDelegate.swift using the 'Open Quickly' menu.

This is the entry point to the app. `application(\_:didFinishLaunchingWithOptions:)` is where app-wide setup is started. In previous version of iOS this function created the root view controller, but now with storyboards (which are being used in this project), if setup of a view controller is not complete in this method, a view will be created automatically.

Let's chuck a `print("Hello")` in the body of `application(\_:didFinishLaunchingWithOptions:)`, then head back to `ViewController.swift` and add `print("World")` into the body of `viewDidLoad()`.

Click in the ribbon (the light grey area immediately to the left of the source code) to the left of `print("World")` to add a breakpoint.

Hit Cmd-R again. In the right pane of the debug area (in the middle, at the bottom) you should see
```
Hello
```

Hit the 'Continue program execution' button (third from the left) in the debugger controls above where 'Hello' appeared.

Now the console should read
```
Hello
World
```

Woo! Well, not really. We're not learning apps to print to the console.

## Summary
In this section, we learned how projects and apps are initiliased, saw some swift code, and learned a bit about how swift came about. We've also had a quick tour of Xcode and looked at the debugger.

# 1.2 Hello world, take 2 (Views)

It's view time!

On iOS, we put things onto the screen using views. Rendering happens in other ways, but none of that happens without using a view.

Views are all subclasses of UIView. UIKit provides lots of system provided views (see https://developer.apple.com/library/content//documentation/UserExperience/Conceptual/UIKitUICatalog/index.html).

The simplest for our purposes is a UILabel. Let's add one. Type `let label = UILabel(`. You should have a list of autocomplete suggestions. Swift allows initialiser overloading based off the parameter names. We'll use the `UILabel(frame:)` initialiser, but first, a little about coordinates.

## Coordinates
The coordinate system on iOS uses the top-left as the origin (0, 0). The y-coordinate increases from top to bottom.

The primitives that are used to represent locations and sizes are `CGPoint`, `CGSize` and `CGRect` which essentially wraps a point and a size with some syntax sugar.

Views have a frame and bounds. Both of these are CGRects. _Bounds_ are effected by transforms, but the _frame_ isn't. We'll use bounds to reference an existing object's location and size, and frames to create them.

Finish that line by referencing `view` (which we'll explain very soon):
```swift
let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, view.bounds.height))
```

## Windows

A `UIViewController` subclass's main job is to manage it's view. The view is made automatically using the storyboard in this case. (`loadView()` provides an injection point to create that view yourself.)

That view will already have reference to a `UIWindow` which means its contents will be rendered. We can add a view to the hierachy by adding a subview.

Add the following to add our label to the view hierachy:
```swift
view.addSubview(label)
```

## Views and internationalisation

iOS is a platform used by billions, from every country. The platform supports many languages. Thanks to this, and our friends in Japan, let's use emoji.

Type `label.text = "` then control-command-space to bring up the emoji picker. Select the "waving hand" emoji and a "globe" emoji, then close off the string.

Run the project. You should see this:

<img src="https://github.com/redeyeapps/ios-bootcamp/raw/master/images/make-an-app-session-1/hello-world-unformatted.png" width="360">

It doesn't look quite right. Hit the button that looks like a portrait rectangle on top of a landscape rectangle, to the left of the step-out button in the debug control area.

This is the view debugger. Drag down and right from the center of the view. This will reveal the view hierarchy in 3d. The slider on the left controls the depth effect.

We can see the window at the back, then `ViewController.view` in the middle and finally our label at the front. We can see that the bounds of the view are okay –- they match the bounds of the view controller view (fullscreen). Let's move the content into the center of the label using UILabel's `textAlignment` property.

While we're at it, let's alter the font to make it bigger too. Update your view code to match what's below and run the project.

```swift
let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height))
label.text = "👋🌏"
label.font = UIFont.systemFont(ofSize: 100.0)
label.textAlignment = .center
view.addSubview(label)
```

You should see this:

<img src="https://github.com/redeyeapps/ios-bootcamp/raw/master/images/make-an-app-session-1/hello-world-formatted.png" width="360">

Minimalist design and overuse of emoji on a shiny (simulated) device? We're proper iOS developers now.

<details>
<summary>SWIFT IN ACTION</summary>
A few things about swift shown above:
1. `let` declares a constant. It looks like we're altering the constant, but since the label is a _class_ -- a reference type, `let` is actually declaring that the reference is constant. Swift also has value types (struct and enum). When these types are declared as constant, they may not be mutated at all. Basic types like String, Int and Bool are defined as value types (see the definition of String and Bool here: https://github.com/apple/swift/blob/master/stdlib/public/core/String.swift, https://github.com/apple/swift/blob/master/stdlib/public/core/Bool.swift). These files are pretty impenetrable (that's why Int's isn't shown) so everyone uses The Swift Programming Language instead. (See https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language)
2. `UIFont.systemFont...` calls a static method on UIFont (https://developer.apple.com/reference/uikit/uifont)
3. `.center` is using type inference to select a member of an enumeration. The type of the property is NSTextAlignment so it's shorthand for `NSTextAlignment.center`
</details>

## Summary
In this section, we learned about views, coordinates and windows on iOS. We used a label to display emoji directly from the source code, adjusted the font and the alignment. We also used the view debugger.


# 1.3 Tick (Displaying times and dates, using timers)

Now we have a view, but it's not really doing anything. Easy to fix. Let's add a `Timer` and display a date which updates every second instead of some emoji. We're programmers. Emoji is for messaging apps, not building technical wonders.

## Times and dates

On iOS dates are simply represented as a TimeInterval (a typealias for Double), measured in seconds wrapped up in a type called Date.

To get the current date, just call `Date()`. See https://developer.apple.com/reference/foundation/nsdate for more.

To do arithmetic on dates using months or days etc, we have to use a Calendar (https://developer.apple.com/reference/foundation/calendar). Dates are hard.

## Displaying times and dates

As we said before, iOS is used all around the world. That means catering for a ridiculous number of different conventions.

iOS addresses this problem using Formatters which take into consideration the user's curent settings. The NSHipster blog gives a quick tour of this at http://nshipster.com/nsformatter/. NSHipster is a good resource for a lot of other things too.

We'll use a DateFormatter to format out date.

> Dates and DateFormatters are part of Foundation: the library for basic tasks that aren't part of the swift standard library. Foundation helps with working with Data, Calendars, JSON, URLs etc. Foundation along with UIKit, and apple's other libraries are known as 'Cocoa'.

DateFormatters use a `Locale` to represent conventions for displaying times, dates, numbers, etc., a `Timezone` to represent the current timezone, and a Date and Time style to specify how a date or time should be rendered.

DateFormatters are created with the default `Locale` and `Timezone` based on the user.

Let's format a date! See https://developer.apple.com/reference/foundation/dateformatter for usage, and https://developer.apple.com/reference/foundation/dateformatter.style for display types. You'll have to click on one of the cases to see what they actually look like. The online docs are pretty annoying sometimes.

The code below uses the medium style, without setting a date style so the date isn't displayed (it's default is none). The font size adjusted to ~50 so the time won't be truncated.

```swift
let date = Date()
let dateFormatter = DateFormatter()
dateFormatter.timeStyle = .medium
let dateString = dateFormatter.string(from: date)

let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height))
label.text = dateString
label.font = UIFont.systemFont(ofSize: 50.0)
label.textAlignment = .center
view.addSubview(label)
```

Run the project and you'll probably stare at it for a while waiting for it to change. It's very convincing, but not the real McCoy.

To make things dynamic we'll use a timer. Timers are very easy on iOS 10 and later:

```swift
Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
    // Do stuff with the timer
}
```

The timer method uses a closure to pass in an anonymous function which can reference the parent scope when called.

Let's cache the dateFormatter (because it turns out they're expensive to create) and update the text label in the timer:
```swift
class ViewController: UIViewController {

    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("World")

        dateFormatter.timeStyle = .medium

        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height))
        label.text = dateFormatter.string(from: Date())
        label.font = UIFont.systemFont(ofSize: 50.0)
        label.textAlignment = .center
        view.addSubview(label)

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            label.text = self?.dateFormatter.string(from: Date())
        }
    }

...

}
```

Run it, and we're looking good!

<details>
<summary>CLOSURES IN-DEPTH</summary>
The method signature for the timer looks like this:
```swift
open class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) - Swift.Void) - Timer
```
The closure taken buy this function is the final argument. When using the function, the brackets can be put before the second to last parameter and statement can look more native. It's entirely syntactic sugar.

The important bit is the `@escaping`. It means that what is passed into the function will be stored and executed later. This is in contrast to a non-escaping closure (where `@escaping` is omitted), where the content of the closure is executed before the function executes. Using an instance variable in a closure causes a compiler error where self has to be referenced. This is because to access self, self must be captured. When and object references a closure (the child) and the closure references self (the parent) a reference cycle has been declared and the parent object's memory will be leaked. This is all to do with how swift does memory management. It uses Automatic Reference Counting so manual memory management isn't required, but the overhead of a garbage collector isn't required either. The solution the reference cycle is to hint that the compiler should capture self weakly:
```swift
Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
    self?. ...
}
```
For more on automatic reference counting see: https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html

Note: `Swift.Void` is an artefact of the complex relationship between Swift and Objective-C
</details>

## Summary

We just learned a little about Foundation - the framework that helps with dates, times, timers and other simple, but non-essential tasks. There's a lot more to Foundation and we'll see elements of it as we progress through the day.

# 1.4 Auto-tock (Clock with Interface Builder and Autolayout)

In the simulator hit cmd-left_arrow. The position for the time is wrong. Let's hit the view debugger view again.

The window and view controller's view have been updated, but the label's location hasn't been updated. We could hook into view update locations and update the location programmatically, but right now, we'll look into Autolayout, UIKit's layout engine using Storyboards in Interface Builder.

Go to Main.storyboard. The white screen you can see is the ViewController being initialised automatically for us in the AppDelegate, and in the ViewController.

We're going to re-create the clock screen we made programatically, and introduce the date underneath to show where Autolayout really shines: text in more complex view hierarchies.

Add two Label objects (UILabels) by dragging them out of the Object Library and onto the ViewController. The Object Library should be visible in the bottom half of the Utilities pane. If it's not visible, click on the home button icon in the separator between the top and bottom halves of the Utilities pane.

Position the views so that one view is higher than the other. It should look something like this:

<img src="https://github.com/redeyeapps/ios-bootcamp/raw/master/images/make-an-app-session-1/label-placement.png" width="360">

## Autolayout

Autolayout is Apple's system for laying out interface components. It uses a system of constraints to declare how the view should be layed out. Those constraints are then solved within the constraints of the window to provide layout responsive to the size. The responsiveness is limited to the screen size, but that's the theory.

Constraints can be made between edges or centers of views. These include alignment and spacings for example. Also, constraints can be enabled or disabled or set at a priority level to enable degradation.

Additionally, some views have an 'intrinsic content size'. This means that the size of the view _can be_ determined by the contents of the view. Constraints may alter this, but this can also be used to automatically set the size of a view.

Select the two labels and go to Editor > Embed in > View. This will add a view and put the labels as subviews of the view. This is most clear in the document outline on the left of interface builder.

Now to add the constraints. You will notice the constraints are red to begin with. This means that there aren't enough constraints to define the layout. After step 4 below, the constraints will go blue.
1. Select the top label and hit the add new constraints button (a square on a line thing) to the right of the alignment button in the bottom bar of the interface builder area. Add constraints with constants of 16 to the left, top and right. The constraint icons near these constants will go red when the constraints will be selected. Click 'Add 3 constraints' to add the constraints.
2. Do the same with the bottom label with the left, _bottom_ and right.
3. Hold control and drag with the left mouse button between the two labels and release and select 'vertical spacing'. This will add a constraint between the labels with a constant defined by the existing distance between the labels.
4. Select the view wrapping the labels using the outline or by clicking near the labels and click the alignment button. Check 'Horizontally in Container' and 'Vertically in Container' and click 'Add 2 constraints'

The labels should now be aligned with eachother, as their position has been defined by the constraints, and be centered in the enclosing container. Notice that the size of the view enclosing the labels is defined by the size of the labels, but we haven't explicitly defined the size of the labels.

> Autolayout is a very complex, powerful tool, and we've barely scratched the surface. Here's a good starting point to learn more https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/

## Linking interface builder to our code

Right now our views are static. Let's make them dynamic.

iOS uses `@IBOutlet` to declare that a view is related to a view existing in a storyboard. Let's declare properties for our views. Add the following before `dateFormatter` in `ViewController.swift`:

```swift
@IBOutlet weak var timeLabel: UILabel!
@IBOutlet weak var dateLabel: UILabel!
```

### BANG BANG! (A long aside on optionals, tutorial continued afterwards)

Remember how we said before that 'safe' was one of the goals of the Swift language project? A big part of that is if a type can be `nil` it must be declared that way. Swift uses Optionals to represent this. Optionals wrap a type making two cases: the value doesn't exist, or it does exist and has a given value. They can be written as an `enum` like below:
```swift
enum Optional<Type> {
    case none
    case some(let value: Type)
}
```
Usually to use an enum we have to use switch statements (or case statements in other places). The following shows this:

```swift
let optionalTwenty = Optional<Int>.some(value: 20)
let optionalNothing = Optional<Int>.none

func valueExists(forOptional: Optional<Int>) -> String {
    switch optionalValue {
        case none: return "I don't exist"

        // let value binds the associated value to number.
        // "... \()" is how swift does string interpolation.
        case some(let number): return "I do exist and my value is \(number)"
    }
}

print(valueExists(forOptional: optionalTwenty))    // "I do exist and my value is 20"
print(valueExists(forOptional: optionalNone))    // "I don't exist"
```

Since it would be excruciating to have to have switch statements, swift adds some syntactic sugar to optionals. In code, they play out as follows:

```swift
func doSomethingWithNonOptional(_ nonOptional: String) {}
func doSomethingWithOptional(_ optional: String?) {}    // Notice the '?'

// Working with non-optionals
var nonOptional: String
var initialisedNonOptional: String = "I'm a string"

doSomethingWithNonOptional(nonOptional)    // WARNING: Variable 'nonOptional' used before being initialised
doSomethingWithOptional(nonOptional)    // WARNING: Variable 'nonOptional' used before being initialised

doSomethingWithNonOptional(initialisedNonOptional)    // Okay :)
doSomethingWithOptional(initialisedNonOptional)    // Also okay, nonOptional is treated as an existing optional

// Working with optionals safely
var optional: String?
var initialisedOptional: String? = "I'm an optional string"
var initialisedEmptyOptional: String? = nil

doSomethingWithNonOptional(optional)    // COMPILER ERROR: Value of optional type 'String?' not unwrapped; did you mean to use '!' or '?'?
if let newVariable = optional {
    doSomethingWithNonOptional(newVariable)    // Okay :)
}
doSomethingWithNonOptional(initiliasedOptional)    // Okay :)
doSomethingWithNonOptional(initialisedEmptyOptional)    // Okay :)

doSomethingWithOptional(optional)    // Okay :)
doSomethingWithOptional(initiliasedOptional)    // Okay :)
doSomethingWithOptional(initialisedEmptyOptional)    // Okay :)

// Working with optionals DANGEROUSLY - Bangs make things go bang (crash!)
var optional: String?
var implicitlyUnwrappedOptional: String!
var initialisedImplicitlyUnwrappedOptional: String! = "I'm an implicitly unwrapped optional"

doSomethingWithNonOptional(optional!)    // CRASHES at runtime :(
doSomethingWithNonOptional(implicitlyUnwrappedOptional)    // CRASHES at runtime :(
doSomethingWithNonOptional(initialisedImplicitlyUnwrappedOptional)    // Okay :)

doSomethingWithOptional(optional!)    // CRASHES at runtime. Bang not needed.
doSomethingWithNonOptional(implicitlyUnwrappedOptional)    // Okay :)
doSomethingWithNonOptional(initiliasedImplicitlyUnwrappedOptional)    // Okay :)
```

This is probably the most annoying part of learning swift, but previously you've just been ignoring the case where a pointer or value is null (gasp!) Inevitably this leads to a bunch of bugs. Instead of making questionable assumptions, we can use the compiler to do the heavy lifting for us. The engineering team at Uber (100+) engineers banned the use of bangs. Their initial release of a complete re-write of the Rider app, it was remarkably stable. Their crash rate is very close to 1 in 10,000 sessions!

End of important aside.

### Tutorial continues

You should have a dot to the left of those two lines. They indicate that these will be linked to interface builder. At the moment the dots are empty as we still have to link them up.

Head to `Main.storyboard`. Hold control and drag from View Controller (yellow dot) on the working area or the document outline to one of the labels. Release and an outlet menu will appear. Select dateLabel for one label, and timeLabel for the other. Now the `@IBOutlet` references are linked!

These references can sometimes be a source of some gross bugs. They usually look something like `[<FancyClock.ViewController 0x7f8a2dc092e0> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key dateLabel.` This can be fixed by adding that property to the UIViewController subclass, or by removing the reference. Head to the outlets tab in the Utilities section when in Interface Builder (the arrow in a circle), hover over the faulty outlet / action and click the 'x' to remove it.

Change where we update the `label.text` to refer to `timeLabel.text`. Delete the declaration and anything that refers to the original `label`.

cmd-r to run it, and cmd-left to rotate it. It's good!

## Using interface builder to style components

When we were creating our views programmatically, we had to rebuild to see our changes. Interface builder allows us to make these changes and see the effects immediately!

> Whether splitting your view configuration between code and storyboards is a debate for another time. Also, interface builder often uses different names for variables / properties than the names in the documentation. Hooray!

Let's style the labels we had before. Click the slider icon in the top half of the Utilities pane. This is how you can access the attributes for tweaking views. Style it to your hearts content.

> Fun fact, you can write custom views with the ability to render in interface builder! Custom views are a huge rabbit-hole so we won't cover them today. See https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/ to get started. We won't cover custom drawing or `@IBDesignable` items either, but see our friend NSHipster for a good overview: http://nshipster.com/ibinspectable-ibdesignable/.

Now add a dateFormatter with a date style to update the dateLabel. Boom! Time and date in both orientations.

<img src="https://github.com/redeyeapps/ios-bootcamp/raw/master/images/make-an-app-session-1/time-and-date-portrait.png" width="360">

<img src="https://github.com/redeyeapps/ios-bootcamp/raw/master/images/make-an-app-session-1/time-and-date-landscape.png" width="360">

## Summary

We've just learned about Autolayout, InterfaceBuilder and Storyboards and how they work together. We also covered briefly the concept of optionals. That section is included for reference and we'll certainly see more of optionals later in the day.

# Coming up next

Now we've covered the basics, the next session is all about images, networking and dependency management. We'll take our simple app and make it a lot more interesting.
