
# SESSION 2

# 2.1 Making things interesting (Networking)

We could teach you view programming, or how to save things locally, but these are really pretty simple.

Instead, let's look at how networking works on iOS.

## 2.1.1 iOS Networking Basics

Networking is a huge topic. There are heaps of failure modes, and complexities - particularly because iOS devices are often using the cellular network.

On iOS, networking is accomplished using tasks attached to a session. `URLSession.shared` accesses the default session and `dataTask(...)` can be used to create a data task.

Tasks take a completion handler closure which is then called with the result of the task, the url response (as a `URLResponse` object) and an error if obtained.

The task is actually run by calling `.resume()`.

Putting all this together, a networking call is relatively simple. A simple get for Google's homepage looks like this:
```swift
guard let url = URL(string: "www.google.com") else { return }
let urlRequest = URLRequest(url: url)
let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
    // Data will be the google homepage html.
})
task.resume()
```

Headers can be added using `.addValue(_:forHTTPHeaderField:)` on a `URLRequest` instance. (See https://developer.apple.com/reference/foundation/nsurlrequest)

> See the URLSession documentation for more https://developer.apple.com/reference/foundation/urlsession, and  https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/Introduction/Introduction.html for an overview of networking.

## 2.1.2 Networking in practice

Usually developers will write a small library to wrap their networking code, since it will mostly be shared for all the requests. Nobody wants to add that auth token every time. Keep it DRY people. (https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)

Today we'll be interacting with unsplash.com -- a site that provides super high quality photos, donated by photographers. It's an excellent project, and it has amazing images.

Unsplash has a 50 calls per hour limit for anonymous developers, so Ethan has written a proxy for us here at the iOS bootcamp. If you're working on this at home, use unsplash's API directly after creating a free developer acount. Get started here: https://unsplash.com/documentation#getting-started.

To get a feel for what we're dealing with, we'll make a request and print out the contents.

Here are the request details:
```
GET /photos/random
Host: available on the day (if you're at home, use api.unsplash.com)
Authorization: Client-ID ANYTHING (if you're at home, use your client id)
Accept-Version: v1
```

Have a crack at this yourself. Just wrap it in a method and call it from `viewDidLoad()` in `ViewController.swift` and go for it.

PRO TIP: You'll get a `Data` object from the request. To convert this to a string, use
```swift
let string = String(data: data, encoding: .utf8)
```

<details>
<summary><em>SOLUTION (SPOILERS)</em></summary><p>

```swift
guard let url = URL(string: "insert-endpoint-here/photos/random") else { return }
var urlRequest = URLRequest(url: url)
urlRequest.addValue("Client-ID ANYTHING", forHTTPHeaderField: "Authorization")
urlRequest.addValue("v1", forHTTPHeaderField: "Accept-Version")

return URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
    print("Data: \(String(describing: String(data: data, encoding: .utf8)))")
    print("URL response: \(String(describing: urlResponse))")
    print("Error: \(String(describing: error))")
})
```
</p></details>
<br>
<details>
<summary><em>GUARD...ELSE</em></summary><p>

>Guard is best explained as the else statement only of an if statement. It came about because of if let ... {} pyramids of doom.
>
>NOTE: `if let constant ... {}` creates a constant only available to the inside of the if block.
>
>They looked like this:
>```swift
>if let a = ... {
>    if let b = a... {
>        if let c = b... {
>            if let d = c... {
>                // Do something with d
>            }
>        }
>    }
>}
>```
>
>The solution was to add an equivalent statement which included the failure case
>```swift
>guard let a = ... else { return }
>guard let b = a... else { return }
>guard let c = b... else { return }
>guard let d = c... else { return }
>
>// Do something with d
>```
</p></details>

## 2.1.3 Parsing the JSON

Here's example JSON from `/photos/random`.

<details>
<summary><em>JSON</em></summary><p>

```json
HTTP/1.1 200 OK
Content-Type: application/json
Date: Fri, 28 Apr 2017 09:05:51 GMT
Transfer-Encoding: chunked

{
    "categories": [],
    "color": "#10130C",
    "created_at": "2016-11-01T21:47:38-04:00",
    "current_user_collections": [],
    "downloads": 2576,
    "exif": {
        "aperture": "5.0",
        "exposure_time": "1/4000",
        "focal_length": "48",
        "iso": 3200,
        "make": "Nikon",
        "model": "NIKON D5200"
    },
    "height": 4000,
    "id": "Md5vvHf55fk",
    "liked_by_user": false,
    "likes": 33,
    "links": {
        "download": "http://unsplash.com/photos/Md5vvHf55fk/download",
        "download_location": "https://api.unsplash.com/photos/Md5vvHf55fk/download",
        "html": "http://unsplash.com/photos/Md5vvHf55fk",
        "self": "https://api.unsplash.com/photos/Md5vvHf55fk"
    },
    "location": {
        "city": null,
        "country": "United States",
        "name": "Crowders Mountain",
        "position": {
            "latitude": 35.2725727,
            "longitude": -81.2739073
        },
        "title": "Crowders Mountain, United States"
    },
    "slug": null,
    "updated_at": "2017-04-19T10:07:06-04:00",
    "urls": {
        "full": "https://images.unsplash.com/photo-1478051173351-52b9492e9d52?ixlib=rb-0.3.5&q=100&fm=jpg&crop=entropy&cs=tinysrgb&s=9a47b97bc45395f45046a03e929dbc31",
        "raw": "https://images.unsplash.com/photo-1478051173351-52b9492e9d52",
        "regular": "https://images.unsplash.com/photo-1478051173351-52b9492e9d52?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=c14e5149dde1d6f8533e97db5e688e7a",
        "small": "https://images.unsplash.com/photo-1478051173351-52b9492e9d52?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&s=65c1abe3339e7bcd6241b8a162383644",
        "thumb": "https://images.unsplash.com/photo-1478051173351-52b9492e9d52?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=c24aa4a2c793b14a2b281bb7c338214a"
    },
    "user": {
        "bio": "",
        "first_name": "Callistus",
        "id": "8pfAUhJHFZQ",
        "last_name": "Ndemo",
        "links": {
            "followers": "https://api.unsplash.com/users/carlis/followers",
            "following": "https://api.unsplash.com/users/carlis/following",
            "html": "http://unsplash.com/@carlis",
            "likes": "https://api.unsplash.com/users/carlis/likes",
            "photos": "https://api.unsplash.com/users/carlis/photos",
            "portfolio": "https://api.unsplash.com/users/carlis/portfolio",
            "self": "https://api.unsplash.com/users/carlis"
        },
        "location": " Asteroid B-612",
        "name": "Callistus Ndemo",
        "portfolio_url": null,
        "profile_image": {
            "large": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=ee8bbf5fb8d6e43aaaa238feae2fe90d",
            "medium": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=356bd4b76a3d4eb97d63f45b818dd358",
            "small": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=0ad68f44c4725d5a3fda019bab9d3edc"
        },
        "total_collections": 5,
        "total_likes": 59,
        "total_photos": 5,
        "updated_at": "2017-04-19T10:07:06-04:00",
        "username": "carlis"
    },
    "views": 202417,
    "width": 6000
}
```
</p></details>
<br>

Foundation includes support for JSON parsing and serialization using `JSONSerialization`. The declaration is shown below:
```
class func jsonObject(with data: Data,
                    options opt: JSONSerialization.ReadingOptions = []) throws -> Any
```

There's a few things to unpack here. This function is a class method on `JSONSerialization`, options includes a default parameter (and is an option set - a concept beyond the scope of today), and the call can throw, meaning it may error and must be 'tried' using the `try` keyword. The function also returns `Any` which may represent any type, meaning it must be first cast to another type to be used.

Putting all these things together:
```swift
var jsonDictionary: [String: AnyObject]? // AnyObject just means AnyObject
do {
    jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject]
} catch {
    print("JSON parsing failed")
}
```

<details>
<summary><em>DICTIONARIES IN SWIFT</em></summary><p>

> `[String: AnyObject]` is a swift dictionary where the key is of type `String` and the value is of type `AnyObject`. A Dictionary is like map in java, or a dict in python. Dictionaries are one of three swift collection types in swift along with `Array` and `Set` (think set theory).
>
> To set an element in a dictionary:
> ```swift
>var dictionary: [String: Int]
>dictionary["key"] = 42
>```
>
> And to access that element:
> ```swift
>let value = dictionary["key"] // value is of type Int?
>```
> Note that the return type of the call is optional. If the value doesn't exist the result of the subscript is `nil`. This is unlike and `Array` where subscripting out of bounds is an error. In array's case, this is a performance consideration. Dictionaries are much less performant than arrays.
>
> The manual for swift's collection types is here: https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html, and the reference page for swift dictionaries is here: https://developer.apple.com/reference/swift/dictionary

</p></details>
<br>

Now we have processed the data out of the dictionary, let's extract the url for the regular image url. In _javascript_ this would be `json.urls.regular`.

The JS in JSON stands for Javascript/JavaScript. The swift version _will_ be gross. You'll probably now wrestle with the compiler for 15 minutes to unpack the JSON.

<details>
<summary><em>SOLUTION (SPOILERS)</em></summary><p>

```swift
guard
    let dictionary = result as? [String: Any],
    let urls = dictionary["urls"] as? [String: String],
    let resourceAddress = urls["regular"]
    else {
        print("Unexpected JSON")
        return
}

print(resourceAddress)
```
</p></details>

## 2.1.4 UIImageView

These are the way we display images on iOS. They're super simple. They have a property `image` which you assign UIKit's version of an image: `UIImage`.

Images themselves pose a bit of a problem on iOS. That because iOS devices are resource constrained so as soon you start dealing with multiple large images (like we are) we have to be smart about our memory usage. This is pretty hard, but the good news is someone else has done it for us!

## 2.1.5 Kingfisher

Kingfisher is a library to help with loading and caching images.

You don't need to know much about Kingfisher, just that it will turn hundreds of lines of code in your app, into just a few:

```swift
let resource = ImageResource(downloadURL: url)
imageView.kf.setImage(resource)
```

These lines fetch the image asynchronously from the specified url and set it as the image of the image view. It also manages caching and animation (the hard bit).

That's a lot of stuff we didn't have write or (theoretically) test!

The easiest way to manage other's people code is to use a dependency / package manager.

>Kingfisher also provides the ability to display placeholder images, perform animations and display progress. To read more about Kingfisher see https://github.com/onevcat/Kingfisher/wiki/Cheat-Sheet

## 2.1.6 Cocoapods

CocoaPods is the defacto package manager on iOS. It's a community maintained Ruby gem with over six million downloads.

We will be using it today to take advantage of an image management framework that will make your life significantly easier.

Cocoapods can be installed `gem` or as a standalone app from https://cocoapods.org/app
```bash
sudo gem install cocoapods
```

Dependancies are managed via a Podfile. These are simple Ruby files that can declare simple or complex dependency graphs.
For your app you will want your `Podfile` to look like this:

```ruby
project 'FancyClock.xcodeproj'

target 'FancyClock' do
  use_frameworks!

  pod 'Kingfisher'
end
```

This file declares a single dependency, Kingfisher. This is the image management framework mentioned earlier.

Cocoapods works by taking control of your project. (Seriously. Linked libraries and dependencies are an afterthought in Xcode.) It'll generate an `.xcworkspace` file which you should use whenever you are developing a project using cocoapods.

Go to the Cocoapods app, enter the above (if you haven't already) then click install. If you're on the command line run `pod install`.

<img src="https://raw.githubusercontent.com/redeyeapps/ios-bootcamp/master/Screenshots/2-1-cocoapods-install.png">

Close the project (**Command(⌘)+q**) and open `FancyClock.xcworkspace`. You'll use this from now on.

<details>
<summary><em>ALL THE COCOAPODS</em></summary><p>

>Most apps on the App Store extensively use CocoaPods. Cocoapods can automatically generate the attribution page. Here's one from VLC.
>
><img src="https://raw.githubusercontent.com/redeyeapps/ios-bootcamp/a37f7fde2efaa30e541476b7cb0c08c9b3c5ebdd/images/session-2/vlc-attribution-page.png" width="360">
>
>For more info about cocoapods see https://cocoapods.org
>
>For more on podfiles see https://guides.cocoapods.org/syntax/podfile.html

</p></details>

## 2.1.7 Putting it all together

To use Kingfisher, you'll have to import it into `ViewController.swift`. This done like so:

```swift
import UIKit
import Kingfisher

class ViewController: UIViewController {
...
```
Then just get the image url and pass it to a UIImageView (add it in Interface Builder like we did with the labels before).

Boom! Enjoy the programmers high as that beautiful high-res image fades in. Ciao bella!

## Summary

In this section we've covered networking code, JSON parsing, done some more advanced optional usage, added a dependency using Cocoapods and put all these together to display a random image from Unsplash.

# 2.2 Keeping it fresh (Downloading images in the background)

The image is nice, but we don't want to have to re-run the app to get a different image.

There's quite a lag time on the initial image load, so let's load the next image while the previous is still displaying.

## 2.1.1 Loading an image in the background

Once again Kingfisher helps with this. We can use the following to download an image while the current image is loading.
```swift
ImageDownloader.default.downloadImage(with: resourceUrl,
                                      options: [],
                                      progressBlock: nil)
{ [weak self] image, _, _, _ in
    // Do stuff with the new image.
}
```

We can just update the image on the `UIImageView` but that wouldn't look great. Let's learn how to animate the change.

## 2.1.2 UIView Animations

UIView comes out of the box with some pretty comprehensive support for animations. Heaps of a UIView's properties can be animated and animations can have different easings, be chained or reversed, right out of the box. A superview and subview can even have different animations running at the same time (eg: while one is spinning, the other is moving or fading with a different easing).

In it's simpler form (missing the options), the animation API looks like this:
```swift
let duration: TimeInterval = 1.0 // TimeInterval is an alias for the Double type.
UIView.animate(withDuration: duration, animations: {
    // Make some changes that should be animated over duration
}, completion: { didFinish in
    // Do stuff when the animation has finished, including start a new animation.
    // Did finish is a flag describing if the animation finished (true) or has for some reason been cut short (false).
})
```

We can very easily animate the alpha from 1.0 (full opacity) to 0.0 (no opacity), or move the image offscreen (by animating the frame or center) so the image view is hidden when we swap the image out.

Try hiding swapping out the image with animations. Use a second `UIView.animate(withDuration:animations:completion)` call in the completion block of a first animation to undo a change.

Put all this in a function called by a timer and see what you get!

This is one of the fun parts of iOS development so play around with some different effects!

<details>
<summary><em>ADVANCED ANIMATIONS</em></summary><p>

> The full variant of `UIView.animate` is
>```swift
>open class func animate(withDuration duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions = [], animations: @escaping () -> Swift.Void, completion: ((Bool) -> Swift.Void)? = nil)
>```
> An alternative is to use a physics based model:
>```swift
>open class func animate(withDuration duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions = [], animations: @escaping () -> Swift.Void, completion: ((Bool) -> Swift.Void)? = nil)
>```
>
> The `frame`, `bounds`, `center`, `transform` (2d only), `alpha`, `backgroundColor` and `contentStretch` of a `UIView` can all be animated. If these aren't enough, the `CALayer` (Core-Animation Layer) that backs a `UIView` can be accessed to open even more opportunities (with a more compex API).
>
> For more on animations see https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/AnimatingViews/AnimatingViews.html

</p></details>
<br>

**Final product gif here.**

## Summary

We used a background task to load an image while another was still displaying, then used `UIView.animate` to create a transition.
