# AImage
#### Video Demo:  <https://youtu.be/oG8xH6tW9-A>
#### Description: An iOS App, which uses the Replicate AI backend via an API call to generate an image based on a Users text input.

### Table of Contents
1. [Summary](#summary)
2. [Why AImage as final CS50 project - Decision Path](#decision)
3. [Approach to the Functionality and Design of the App](#approach)
4. [Keychain](#keychain)
5. [Navigation in the iOS App](#navigation)
6. [SwiftUI](#swiftui)
7. [AImage Search API](#api)
8. [App Design](#design)
9. [ChatGPT](#chatgpt)
9. [Outlook](#outlook)

X.  [References](#references)



### Summary <a name="summary"></a>
#### An iOS App built with Xcode and SwiftUI, which is based on the [Replicate Swift Package](https://github.com/replicate/replicate-swift) to make AI predictions, in this case a text-based Image Search. The App is using the Replicate backend by making API calls. The API Stucture and the Model is defined in the Replicate Package. 



### Why AImage as final CS50 project - Decision Path <a name="decision"></a>
My background is not Software development, but Infrastructure and Databases. I am pretty good with linux, Databases, Server, OS, Virtualisation, Cloud  and the typical Corporate Company approaches to run Infrastructure (1000s of servers). 3 years ago, I was exposed to a Quantum Computing Project, where I had first contact with Machine Learning. I definitely wanted to challenge myself and since I never developed Apps and especially not for iOS, I went for the painful path of learning the Apple way of doing things... I did not want to spend months for this project, and when doing research on AI and Machine Learning, doing some own tries on how to build a model, train it and make use of it, I realised, that it would take weeks for me to build this from scratch. Then I luckily discovered replicate and decided to go with that. They provide a good ["get started"](github.com/replicate/getting-started-swiftui) guide.


### Approach to the Functionality and Design of the App <a name="approach"></a>
Initially I had many exorbitant ideas about the functionality of "my first new App", but I soon realised, that I will not be able to implement them within the given scope of aprx 2-3 weeks, this is why I ended up with just using the provided replicate package and focus on the implementation of Keychain in order to properly store the API Token as well as building proper login and password management and of course understanding the API interactions. I decided to first test the replicate package with the provided instructions. Ok, this was working fine. Not the greatest App functionality, Google can do that, too (since decades). But the goal for me was to explore how to build an iOS App with this as basis. 

I needed to put a lot of effort into a proper User flow - to handle the stages for login/logout, Entryview, what should the user see first, when launching the app, then automatically switching views, when a certain variable changes, e.g. isLoggedIn, isRegistered etc... there is a View hierarchy, managed with NavigationStack and a seperate UserManager, which contains the interaction with the keychain and maintaining the states of the User. see [Navigation](#navigation)

I deliberately decided for a simple graphical design, which was difficult enough, as the Stacks overlay, so just to have a consistent background on each View requires to have a proper hierarchy.



### Keychain  <a name="keychain"></a>
Implementation seemed to be straight forward, I was reading the [Apple Documentation](https://developer.apple.com/documentation/security/keychain_services). The first tests were promising. I quickly had my first Keychain functions in place, on how to store and retrieve credentials, but then when continuing with integrating the API Key and User Sessions, as you require them to track the login status, because navigation is based on the status, it quickly became veeery daunting. I spent several days by figuring out how to make use of the UserSession,and how navigation can be based on it. In the end, it was about managing the states at one place (the UserManager) and exposing them, making them available to every View.



### Getting Started with Xcode and SwiftUI <a name="start"></a>
I started by reading the Apple Documentation on SwiftUI and did some of the [landmark](https://developer.apple.com/tutorials/swiftui/) sample tutorials. Regarding Xcode, i just started using it and learned over time. I figured out, how to use the Canvas/Preview as well as different Simulators. I learned how to use the console, and how to integrate Print Statements in the code for debugging. I spent an entire day by designing Alerts for user feedback, if an action was successful or not and in the end i completely disgarded them, because the functions itself provide checks on successful/erroneous completion of an action. Now, I just have Alerts within the ProfileView, when a User wants to update the API token, Password, delete the entire Keychain or wants to logout.



### Navigation in the iOS App <a name="navigation"></a>
A long learning exercise. I started with a Navigation menu and a Navigation list. This is how it was done in the past, for example in a Webpage.  User has to click the buttons to go somewhere or to go back. Until I learned, that in iOS you can use triggers and Binding Vars to steer navigation. This creates a much better user Experience. So i restarted again (after a week or so). Now the final design is a Navigation Stack on the Root level, which is ContentView. If the user starts the app for the first time, he/she gets navigated to the EntrynView from there to  RegistrationView and finally (if isRegistered = true) to the LoggedInView.
I needed to make this differenciation, because on registration, you have to enter the API token, which needs to be generated at [Replicate](https://replicate.com/docs). Once a User is registered, he/she can still logout, but does not need to register again. I also wanted to provide a ProfileView, where User can update his/her API token, change Password, delete all credentials and can logout. Below is the logic of ContentView to manage the flow:

```
var body: some View {
        NavigationStack {
            if userManager.isLoggedIn {
                LoggedInView()
            } else if !userManager.isLoggedIn && userManager.isRegistered {
                    LoginView()
            } else {
                EntryView()
            }
        }
```
The state is exposed from UserManager:


```
class UserManager: ObservableObject {
    static let shared = UserManager()
    private let keychain = KeychainSwift()
    
    @Published var isLoggedIn: Bool = false
    @Published var hasSeenEntryView: Bool = false
    @Published var isRegistered: Bool = false
```

the UserManager has to be injected in the main App as EnvironmentObject

```
@main
struct AImage2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserManager.shared)
        }
    }
}
```
and in every View like this to always get the status updates:

```
@EnvironmentObject var userManager: UserManager
```

### SwiftUI <a name="swiftui"></a>
 There are very good tutorials from Apple as mentioned above, like [landmark](https://developer.apple.com/tutorials/swiftui/). But as soon as you start with your own code, it can become challenging. You need to be very precise on where to place which type of code. And it is hard to stay within the scope of the different Stacks. You can end up with several curly brackets at the end of the file and you want to change some view and have to figure out, where the scope of a certain Stack ends. It is not as well organised as in Python or C, I find. Then you also have to make a decision whether to place your logic and functions in a seperate Class File or have the code within the View file. During the process of this App development, I did several redesigns. I first had seperate KeychainManagement, SessionManagement and PredictionManagement files, but in the end I decided to have just one UserManagement file for the Keychain and SessionManagement, and I decided to have the Prediction code within the ImageSearchView. I needed to balance simplicity vs clear code structure and I work on a Macbook with a small screen, which makes it hard to work with many open windows at the same time. It is so much better to work with terminal windows ... 


### AImage Search API <a name="api"></a>
This is the core functionality of the App. The basic code is actually provided by replicate, but I wanted to customize it. I removed the hardcoded API token and replaced it with the API stored in the App's Keychain. Important learning for me was, that the client needs to be initialized before the API call. And since this is an async call, i needed to play around with the polling delay. The app is just displaying one URL (the first one), but you can also get more images back. Exploring the functionality was done by reading the files provided in the replicate package and some try and error tests. Which helped a lot, was adding Print statements to the code to understand the API calls and answers.

### App Design <a name="design"></a>
Beautifying the look and feel of the App seems to be a funny exercise, but I got very involved in making the base functionality run, that my batteries were pretty empty, when I got to this stage. I have to admit, that I only did the minimum effort regarding design, colours etc. It was challenging enough to keep the logo at the top, having the background in place and having nice buttons, or within the ImageSearchView, how the image is returned and displayed. Next time when creating an iOS App i would definitely start with the UI Design and a clear structure and not doing it "somehow" at the end.


### ChatGPT<a name="chatgpt"></a>
I started using ChatGPT when I got stuck and wanted to get a quick answer. My experience was, that ChatGPT can be quite helpful especially at the beginning with the design and towards the end for cleaning up. And also during coding, when i got messedup with the curly brackets. 

BUT, i would not suggest to completely rely on ChatGPT. You definitely need to know exactly what you are doing and you need to steer the conversation, else you can get very confusing answers. ChatGPT will not replace your brain - and i am curious to see, where this will go in the future.
For me, when learning a new Framework and language it was very helpful.


### Outlook and Fazit <a name="outlook"></a>
It is hard to know, when to stop. There could be more nice features built in the App, e.g. the API gives back a list of URL's, so i could have made a field, where the user could choose, how many images you want. but then you also have to design, how this images gets displayed, e.g. in a carousel, inline etc.... 

I had phases where I was completely discouraged and angry about myself, why I chose to make an iOS App.... especially, when Xcode stopped deploying to my iphone, until i realised, that there was a new iOS release. Thank you, Apple.  

Also my MacBookPro got to its limits, it is one from 2019 with an IntelChip. When doing builds, deploying and running them on different simulator or devices times, it overheated. Once I "produced" a memory issue (in the code), which crashed the app and took me 2 days to recover and fix it. But I guess, that's the life of a developer.

I am very satisfied and proud to be able to present my first iOS App. I won't win a prize with its functionality, but as a learning exercise, it was great.


### References <a name="references"></a>

#### [Apple Developer Documentation](https://developer.apple.com/documentation/)
#### [Replicate Documentation](https://replicate.com/docs)
#### [Apache Replicate-Swift License](https://github.com/replicate/replicate-swift/blob/main/LICENSE.md)

