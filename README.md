<p align="center">
  <a href="https://github.com/BrachettaMatteo/flight_tracker_app">
    <img src=".github/img/logo.svg" alt="Logo Flight Tracker App" height="100"/>
  </a>
</p>
<h1 align="center">
  Flight Tracker App
</h1>
<p align="center">
    <img src="https://img.shields.io/badge/Version-1.1.0_beta-orange?style=flat" alt="orange badge illustrated current version 1.1.0 of project"/> 
    <a href="./LICENSE.md">
    <img src="https://img.shields.io/badge/License-MIT-orange" alt="orange badge illustrated current MIT license"/>
    </a>
    <img src="https://img.shields.io/badge/Flutter-%203.22.1%20stable%20-blue?style=flat" alt="blue badge illustrated current Flutter version 3.22.1 stable for this project"/> 
    <img src="https://img.shields.io/badge/Dart-%203.4.1%20-blue?style=flat" alt="blue badge illustrated current Dart version 3.4.1  for this project"/>
</p>

<p align="center">
  An app to check the status of flights.
</p>

## Description

The Flight Tracker application is an application to help track flights and follow its updates. The interface is simple and essential. It implements the following features

- _Onboarding_: to help the user understand the application and its functionality;
- _Homepage_: to track flights, they will be divided into three lists: future flights, flights departing today, and past flights;
- _Add flight_: through the IATA code, it will be possible to easily add the flight;
- _Multilingual_: it is available in English and Italian;

## Run project

> The default implementation use the json data in local(`asset/data.json`), if you get data for api implement `FightTrackerApiRepository`. If run project in Windows or web change the local storage because this implementation use `sqflite`.

clone and move in directory

```bash
git clone https://github.com/BrachettaMatteo/flight_tracker_app.git
cd flight_tracker
```

```bash
#generate automatic file
dart run build_runner build --delete-conflicting-outputs
#generate translation
flutter gen-l10n
#run project choice ios or android
flutter run ios
```

### Aspect

![](.github/img/slide1-WelcomeScreens.png "Illustration of onboarding in app. There are three screens, the first contains a central illustration of an airplane and below a description: track your flight and follow updates. The second screen contains an illustration of the world and below a description explaining the use of the iata code for flight tracking. The last screen contains an illustration of the airport and a button to go to the homepage. A light and a dark theme are available.")
![](.github/img/slide2-Pages.png "Illustration of the homepage and adding a flight. The homepage is a list divided into three subList: Today, which contains today's flights; Pass, which contains flights that have arrived; and Future, which contains flights that will depart in the future. The add flight page is a easy page contains field to add iata and data of flight. A light and a dark theme are available.")
![](.github/img/slide3-Details-flight.png "Illustration of the flight detail page. At the top is a ticket-shaped infographic with the names of the departure and arrival airports, which will be colored green if the flight is on time otherwise red if delayed. This is followed by boarding information such as the gate and finally a notes section where you can jot down any notes for the trip. A light and a dark theme are available.")

## Credits

- **Argument projects**: [Fudeo](https://www.fudeo.it/)
- **API Flight Scanner**: [AviationStack](https://aviationstack.com/)
- **Font**: [Google fonts](https://fonts.google.com)
- **Illustration**: [undraw](https://undraw.co)
