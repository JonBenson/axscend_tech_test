# axscend_tech_test

## Getting Started

### Requirements

- Flutter version: 3.44.1
- Dart version: 3.12.11
- Tested on: iOS Simulator (iPhone 18), Android Emulator (Pixel 9 Pro XL)

### Run the app

```bash
flutter pub get
flutter run
```

No individual flavours have been set up for this example, but in a real-world project you may want to set up dev, UAT and prod.

### Run the tests

```bash
flutter test
```

## Features

- Users list with pagination (basic user info; address and company details omitted).
- User page has a basic sort that can sort the name by alpabetic order.
- User albums list and a photos screen for each album, all with pagination.
- Posts and comments for a user.
- Todos for a user, with the option to show complete tasks or incomplete tasks.
- Localisation for a few of the strings used on the user page.
- Error and loading states (all errors are caught under a single catch-all).
- Tests.

## Architecture

MVVM was used to provide separation of concerns and improve the testability of the code.

```
lib/
├── config/               Contains const strings and the app theme.
├── features/             Each feature is in a separate feature folder.
│     ├── models/         All the data models for the feature.
│     ├── providers/      Providers to manage the incoming data and state.
│     ├── repositories/   Repositories to fetch the data using the API client.
│     ├── widgets/        Not currently added, but would be if there were a lot of shared widgets within the feature.
│     └── screens/        Full screens for the feature.
├── networking/           The API client for sending requests over the network.
├── routing/              The router file detailing all the routes in the app.
├── utils/                Any helper functions or bits which are used throughout the app.
└── widgets/              Widgets that are shared across the whole app.
```

### Layers

The UI gets its data from a provider, which is responsible for holding the state. The provider in turn makes calls to the repository to get and parse the data into the correct models. The repository uses the API client to make the network requests.

### State management

Provider was chosen because it separates state management from the UI (rather than using setState); the UI can use a ChangeNotifier to listen for changes. Provider is fine for small to mid-size projects, so I didn't look at using something like bloc. There is an abstract class that the providers can extend, which provides pagination to each provider that needs it.

### Navigation

go_router has been used to handle navigation. It's simple to use and you can nest routes so that related routes sit under each other. Data is passed via the route URI, e.g. `/users/1/posts` gets the posts for the user with the id `1`.

### Data relations

Each user, album, photo, post, comment and todo has a unique id. This id is then used to link the data together, e.g. the post data has a userId that links the post back to the user.

## Design Decisions

Provider was used for state management because I'm familiar with it, it's not overcomplicated, and it's good for small to mid-size projects.

go_router was new to me but seemed simple to use. I normally use AutoRoute, but this seemed like a simpler choice.

http provides basic network communication, which is all the app needed. For something more complex I might use dio.

EasyLocalization is a really simple and clean localisation package. It allows us to define the strings in a JSON file and then reference them using keys with `.tr()`.

While I didn't implement caching of requests, to keep things simple, I did include the cached_network_image package as it's easy to use and provides image caching, as well as loading states and placeholders if needed.

I started to set up filtering and sorting in the repositories but decided not to complete it due to time restrictions. Sorting and filtering must be done server-side if pagination is being used.

Pagination is used to keep the app fast and to avoid loading all the data up front. While the API specifies the number of records each endpoint has, and some had very few records, I decided to implement pagination on all of them. This was easier than mixing approaches, keeps things uniform, and in a real-world situation you would probably need pagination on them all.

## Localisation

Only English is set up as a language and, due to time constraints, only the users page is localised. To add another language, add a new JSON file in `assets/translations`. In the app's main, add the extra supported locales. You will also need to add the language to the iOS Info.plist under `CFBundleLocalizations`.

## Use of AI

Claude was used as a tool to speed up development. I used it for things like checking my implementation and spotting potential errors I may have missed; basically, as a separate pair of eyes to review code.

It was used to parse the API JSON and create the data models to fit it.

I used it to probe the API to discover its capabilities, as the API doesn't document features such as sorting and pagination very well. To verify the results were correct, I manually tested the API.

During development I identified that there was a lot of duplication in the provider classes around pagination. I asked AI to create an abstract class based on the pagination code I had written. I then had to refine this manually, adding error support and the ability to refresh the whole data set. I also added code to prevent `notifyListeners` being called if the provider had been disposed.

I used it to create the basic skeleton of the README, which I then filled out manually.

I asked AI to give me a couple of areas I could write tests for myself. I also asked it to write the mock API and helpers to support the tests I would write.

The repositories, individual provider code, UI code, theme code, main code, routing and translations were written by me.

Any code written by AI was checked to make sure it made sense and was error-free.

## Known Limitations

The models assume that all keys returned by the API will exist and not be null. In a production app I would change this and protect more robustly against null values and missing keys.

Pulling down to refresh too frequently could cause multiple requests to fire at once and cause the data to become inconsistent.

The error handling is fairly blunt and just throws the user to an error page upon any failed request. A manual retry can be made by triggering the pulldown to refresh action.

## What I'd Do With More Time

- Prettier, less basic UI
- Implement better filtering and sorting.
- A lot of the list widgets for pagination share a lot of the same code, I would refactor this into a shared widget.
- I think more refactory could be done to make more generic shared widgets, I would review in detail if I had more time.
- Proper caching and maybe offline support
- Stronger error handling and maybe retries on server error codes and time outs (currently any error just takes the user to an error page)
- Handling a refresh during an in-flight request
- Custom support for tablet and phone layouts. At the moment sizes are hard coded, I would update these to be dynamic to the device screen size using MediaQuery.
- More testing

## Author

John Benson
