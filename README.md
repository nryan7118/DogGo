DogGO

Project Overview

DogGO is an app designed for pet parents to manage and provide all necessary information about their dogs, especially for dog sitters. The app allows users to store details about their dogs, including basic information, schedules for feeding and walking, medical information, and emergency contacts. The goal is to make sure all pertinent information about a dog is easily accessible and well-organized.

Features

Pet List and Details: Users can view a list of all their pets. Selecting a pet will display detailed information including name, breed, date of birth, likes, dislikes, and more.\
Scheduling: Users can set and manage schedules for feeding, walking, and medications.
Emergency and Vet Information: Store emergency contacts, vet information, and special instructions.
Photo Gallery: Users can add and view photos of their pets in a dedicated gallery.
Local Data Storage: The app uses local data storage solutions (SwiftData and UserDefaults) to save user data.
Cloud Synchronization: Data is synchronized across devices using CloudKit, ensuring users have access to their data from any device.
How DogGO Meets Capstone Requirements

Splash Screen
The app includes a custom splash screen featuring the DogGO logo.
List View with Detail Pages
The app has a list view of all pets, each item includes the dog's name, breed, and a photo. Clicking on a pet takes the user to a detail page with more information.
Network Call
The app uses URLSession to make network calls for fetching additional data (such as friend lists or other related information). Error handling is implemented to handle common network issues like no connectivity or server errors.
Local Data Storage
The app utilizes SwiftData for the primary data storage and UserDefaults for certain user preferences.
Error Handling and Empty States
The app handles all errors gracefully, providing users with appropriate messages and steps to resolve issues. Empty states are clearly communicated with instructions on how to proceed.
Orientation and Mode Support
The app supports both portrait and landscape orientations, and works well in both light and dark modes.
Organized Code and Testing
The project is organized into appropriate folders (Views, Models, Networking, etc.). SwiftLint is integrated for code style, and the project includes unit tests with at least 50% code coverage. All tests pass successfully.
Additional Features
The app includes a custom app icon, onboarding screen, custom display name, at least one SwiftUI animation, and fully styled text properties.
Planned Screens and Elements

Splash Screen: The initial screen showing the DogGO logo.
Home Screen: A list of all pets with options to add or edit details.
Detail View: Displays detailed information about a selected dog.
Schedule View: Allows users to add and manage feeding, walking, and medication schedules.
Gallery View: A grid of photos associated with each pet.
Emergency Contacts: Displays emergency contact information and vet details.
