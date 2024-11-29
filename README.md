<img width="150" alt="image" src="https://github.com/shadiAl-Jaradat/MelodyMingle-App/assets/94618324/6df6c25a-3b4b-46e1-b44a-93199ae706fe">

**"Where Melodies Meet and Scales Mingle"**

A beautifully designed music player app that lets you enjoy your favorite tunes and discover new music. Integrated with the [**Spotify API**](https://developer.spotify.com/documentation/web-api/), Melody Mingle offers seamless playback and personalized recommendations.
---

## Table of Contents

1. [Packages Used](#packages-used)
2. [Screenshots](#screenshots)
3. [Animations](#animations)
4. [Core Features](#core-features)
5. [Coming Soon Screens](#coming-soon-screens)
6. [State Management](#state-management)
 
---

## Packages Used
| Package Name             | Description                                                             |
|--------------------------|-------------------------------------------------------------------------|
| [**Dio**](https://pub.dev/packages/dio)               | For making HTTP requests to the Spotify API.                          |
| [**GetX**](https://pub.dev/packages/get)              | For state management and routing.                                     |
| [**audioplayers**](https://pub.dev/packages/audioplayers)| For playing music.                                                    |
| [**flutter_svg**](https://pub.dev/packages/flutter_svg)| For rendering SVG images.                                             |
| [**google_fonts**](https://pub.dev/packages/google_fonts)| For using custom fonts in the app.                                    |

---

## Screenshots
1. All Songs & Artists 

![homeAndArtistSc](https://github.com/shadiAl-Jaradat/MelodyMingle-App/assets/94618324/fa0481ab-16e5-4e3f-81a1-0842908b6ffe)

2. Artist Info Screen  

![infoArtFull](https://github.com/shadiAl-Jaradat/MelodyMingle-App/assets/94618324/d8b62b9a-9c54-43de-bb85-a88d7090e41a)


3. Now Playing Song Screen

![nowPlayingScreen](https://github.com/shadiAl-Jaradat/MelodyMingle-App/assets/94618324/74d200aa-0d83-4d53-afa2-3a9a433432bb)

4. Search Screen 

![searchScreen](https://github.com/shadiAl-Jaradat/MelodyMingle-App/assets/94618324/1f0a9be8-8d40-4aa2-90b8-c0c18f6be85e)

---

## Animations

1. **Animated Bottom Navigation Bar**  
   Smooth and visually appealing transitions between tabs.

![bNavBar](https://github.com/shadiAl-Jaradat/MelodyMingle-App/assets/94618324/39e12a2e-68c8-4cb5-b7b5-8ef6d0d213b8)

2. **Animated Cards**  
   Dynamic card animations for an enhanced user experience.

![acc](https://github.com/shadiAl-Jaradat/MelodyMingle-App/assets/94618324/8425adc9-baa3-4320-bac1-a774cb0d03fc)

3. **Lottie Animation for Search Not Found**  
   Delightful animations to improve user feedback when no search results are found.
 
![searchNotFound](https://github.com/shadiAl-Jaradat/MelodyMingle-App/assets/94618324/41c8b060-1c10-4b13-bbca-199f0daa1c1e)

---

## Core Features
1. **All Songs & Artists**  
   Browse a list of songs and artists available on your device.

2. **Artist Info Screen**  
   Get detailed information about artists, including their top songs and albums.

3. **Now Playing Song Screen**  
   Experience a beautifully designed now-playing screen with music controls.

4. **Search Screen**  
   Quickly search for songs or artists, complete with search suggestions and error handling for "not found" cases.


---

## State Management

Melody Mingle uses the `GetX` package for state management:
- **GetxController**: Handles application logic and state updates.
- **GetxState**: Manages the reactive state of the app.
- **GetMaterialApp**: Provides `getPages` for seamless navigation between screens.

---

## Coming Soon Screens
* My Favourite
