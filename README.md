DogGO

Project Overview
DogGO is an iOS app designed for pet parents to provide important information about their dogs, especially for dog sitters. The app allows users to store and manage details like basic dog information, feeding and walking schedules, vet contacts, and emergency information. The goal is to ensure that all essential details about a dog are easily accessible and well-organized.

Features

1. Pet List and Details
Users can view a list of all their pets.
Each pet’s details include name, breed, date of birth, likes, dislikes, and owner information.
Information can be updated as needed, and multiple dogs can be managed through the app.
2. Scheduling
Set and manage schedules for feeding, walking, medications, and other events.
Assign specific times and categories for each schedule.
3. Owner & Emergency Contact Information
Store multiple owner names and phone numbers for easy access.
Add emergency contact information to ensure dog sitters can reach out when necessary.
4. Vet Information
Users can add and store a vet’s contact details, including the vet’s name, phone number, address, and more.
5. Local Data Storage
The app uses Core Data for saving all pet-related information locally, allowing users to manage data even when offline.
Additionally, UserDefaults is used to store user preferences and other small bits of data.
6. Cloud Synchronization
Data is synchronized across devices using CloudKit, ensuring that all pet information is accessible from any iOS device logged into the same iCloud account.
Capstone Project Requirements

1. Splash Screen
The app includes a custom splash screen featuring the DogGO logo.
2. List View with Detail Pages
The home screen presents a list of all pets with their names and breeds.
Clicking on a pet takes the user to a detailed information page.
3. Network Call
The app uses URLSession to make network calls to fetch additional data. Specifically, it integrates with Dog CEO’s Dog API to fetch a list of dog breeds. This allows users to select from an up-to-date list when adding or editing their dog’s breed.
API Used: Dog CEO's Dog API
Endpoint: /breeds/list/all
Purpose: Fetch a list of dog breeds to be stored locally in the app.
Error Handling: Handles network availability issues and provides feedback to users when errors occur (e.g., no internet connectivity).
4. Local Data Storage
The app stores all user data using Core Data, ensuring that information about the user’s pets is persistent and available offline.
5. Error Handling and Empty States
The app gracefully handles errors, such as missing network connectivity or issues with saving data. It provides appropriate feedback to the user and offers instructions when encountering empty states (e.g., no pets added yet).
6. Orientation and Mode Support
The app supports both portrait and landscape orientations and adjusts seamlessly between light and dark modes.
7. Organized Code and Testing
The project is organized into appropriate folders for Views, Models, and Networking.
SwiftLint is integrated to enforce a consistent code style.
Unit tests cover at least 50% of the codebase to ensure stability, with all tests passing successfully.
Planned Screens and Elements

Splash Screen: Displays the DogGO logo upon launching the app.
Home Screen: A list of all pets with options to add or edit their details.
Detail View: Displays detailed information about a selected dog, including basic information and preferences.
Schedule View: Manage and update feeding, walking, medication schedules, and other events.
Owner & Emergency Contact: View and update emergency contact and vet information.
Additional Features

Custom App Icon: The app has a unique DogGO icon.
Onboarding Screen: Guides users through the initial setup of their first pet.
Custom Animations: SwiftUI animations are used to enhance user interaction.
Styled Text: Fully styled and responsive text properties are used throughout the app to ensure accessibility and a consistent look.
