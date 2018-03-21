# SwiftNetworkLayer

**SwiftNetworkLayer** is an example of writing a minimal networking layer using only native Cocoa Touch APIs in Swift 4.

**Features:**

1. Make network requests using a shared `API` instance  
2. Load images from the network  
3. Present / dismiss `LoadingView`s while data is loading

I made this example because it seems like most Swift networking layers on GitHub are built atop either [Alamofire](https://github.com/Alamofire/Alamofire) or [Moya](https://github.com/Moya/Moya). If you're looking to dive deeper into how networking works under the hood, I suggest you try writing your own! Also, if you have ways to make mine better, feel free to submit a pull request :) 

## About
### API

The `API` class has two main functions:

1. `request(...)`, which responds with a single object
2. `requestCollection(...)`, which responds with an array of objects

Both methods take an `APIEndpoint` as an argument and return a generic `Result<T>` type, which is declared at the callsite.

### APIEndpoint
An `APIEndpoint` contains contains the required `URL` and `URLRequest` information to make the network call.

### APIModel
An `APIModel` simply conforms to the [Decodable](https://developer.apple.com/documentation/swift/decodable) protocol. It also contains static helper methods to decode the fetched `JSON` to its respective `APIModel`.

### Loadable
`Loadable` is a protocol which provide methods for presenting and dismissing a `LoadingView`.  

A `LoadingView` simply contains a loading spinner and a dimmed background. 

## Example

In the project, there is an `Example` folder with how **SwiftNetworkLayer** could be implemented in a project. This example uses the [BandsInTown API](https://app.swaggerhub.com/apis/Bandsintown/PublicAPI/3.0.0). 

To run the example: 

1. Open `SwiftNetworkLayer.xcodeproj`
2. Press **Run** (`CMD+R`)