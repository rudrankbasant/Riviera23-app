<p align="center">
<a href="https://dscvit.com">
	<img width="400" src="https://user-images.githubusercontent.com/56252312/159312411-58410727-3933-4224-b43e-4e9b627838a3.png#gh-light-mode-only" alt="GDSC VIT"/>	
</p>

<h2 align="center"> Official Riviera App </h2>
	<h4 align="center"> Riviera 23 is a mobile app designed for the vibrant cultural event called Riviera. With a user base of over 8000+ users, Riviera 23  quickly became the go-to platform for event information, announcements, merchandise, and real-time notifications. The app provides information about over 130+ cultural and sports event spanning over three days. <h4>

</a> 

<div align="center">
    <img src="https://github.com/rudrankbasant/riviera2023-app/assets/85751479/4c413c21-5c74-4bff-aa8d-88c29f260822" alt="Download Our App (640 × 320px)" />
</div>


---
## Screens

### 1. Initial and Authentication:
![Group 132](https://github.com/rudrankbasant/riviera2023-app/assets/85751479/4153dd4b-05fd-4c2b-bbcb-8357591c4589)

### 2. Five Main Screens: 

- [x] **Home Screen**: contains Main events, featured events and ongoing events with navigation to merch and announcement section.
- [x] **Event Screen** - contains all events and favourite events, with search and filter options.
- [x] **Riviera Screen** - contains all the Instagram Posts related to the event.
- [x] **Info Screen** - contains FAQs, Sponsors, Organizers, and Contact Info.
- [x] **Profile Screen** - Profile Info about the user.

![Group 128 (1)](https://github.com/rudrankbasant/riviera2023-app/assets/85751479/6d0cc024-5c4d-497e-a993-dbb07a6629b6)
![Group 133](https://github.com/rudrankbasant/riviera2023-app/assets/85751479/cd5cce99-06a1-45b3-b978-1ff85d6bc613)

### 3. Sub Screens:
- [x] **Merch Screen** - all merchandise listed, with the option to view more.
- [x] **Announcement Screen** - all important announcements sorted and nested by date.

![Group 130](https://github.com/rudrankbasant/riviera2023-app/assets/85751479/2f8900c9-de91-4ed8-8ee9-651c1a1c9b0d)


## Implementation / App Design

### 1. Caching: 
The app utilizes the Hive library to cache all data, resulting in improved app performance. This caching mechanism allows for faster data access and enables the app to function offline seamlessly.

### 2. Reducing Firebase Reads: 
One major feature of this app is that the app is designed to utilize fewer Firebase reads. Instead of fetching all data every time, or fetching after a particular period of time, the app makes calls only when data is updated at the Firebase. For this, a collection of remote data versions is stored on the Firestore. Only this collection is fetched every time the app is opened, instead of all data. If the local and remote data version for any data model is different, only that data model is fetched. Hence only a few data are fetched (and cached), and the local data version is updated to prevent unnecessary future API calls.

### 3.Notification in all three states: 
The app sends notifications in all three states the smartphone is in - Foreground, Background and Terminated. 

### 4. Topic Subscription: 
Whenever a user favourites an event, a new topic is created using the event id (if it didn't already exist) and the user is subscribed to the topic (and unsubscribed when unfavourited). Hence apart from the general notifications, users can receive event-specific notifications as well. This feature was added later on as an update, hence there's a one-time function that syncs the already favourited events with topic subscriptions.

### 5. Authentication:
 The authentication functionality supports three types of Firebase authentication methods, ensuring flexibility for users to choose their preferred login options:
  - [X] **Email and password authentication**:
	  - Users can create an account by providing their email address and setting up a secure password.
	  - Email Verification: Users receive an email verification link upon registration to confirm their email addresses.
	  - Password Reset: If users forget their passwords, they can initiate a password reset process, which involves receiving a password reset link via email.
  - [X] **Google authentication**: Users can sign in using their Google accounts.
  - [X] **Apple authentication**: For users with Apple devices, the application supports authentication through their Apple accounts.
        

### 6. App Showcase / Guide:
The showcase functionality provides three essential guides that users should be made aware of immediately.
  - [X] **Merch Section**: This guide provides users with the merch button location, for the boost of merch sales.
  - [X] **Ongoing Events**: This guide offers insights into the ongoing events featured in the application, as this section is at the bottom of the home screen.
  - [X] **Favorite Event Button**: This guide focuses on the functionality of the "Favorite Event" button, that users come across when they click on an event. This guide is essential  as it notifies users that they will receive event-specific notifications once they favourite an event.

![Group 131](https://github.com/rudrankbasant/riviera2023-app/assets/85751479/8494ea9b-1872-41a0-aad4-8cde40e8083e)

### 7. Bloc/Cubit: The state management in the app is handled by the bloc/cubit architecture and has separate components for the following business logics:
- Authentication
- Announcements
- Events
- Favourites
- Hashtags/Instagram Posts (related to the event)
- Contacts
- Team
- FAQ
- Sponsors
- Merch
- Venues
  
### 8. Repository Pattern: 
The app utilizes a combination of Firebase and backend API calls to fetch data, allowing for seamless integration of real-time updates from Firebase as well as accessing additional data and functionality from the backend server. The app follows the Repository Pattern for the business logic coming from the backend API - namely Events and Hashtags/Instagram Posts.

### 9. Tests: 
The app has implemented a series of basic unit tests specifically designed to ensure the accuracy and reliability of event duration, date, and time information. These aspects hold paramount importance to users, as they heavily rely on accurate scheduling and timing to plan their attendance since there are over 130+ events happening overall.

<br>

## Running

### 1. Clone the project

```bash
git clone https://github.com/rudrankbasant/Riviera23-app.git
```

### 2. Install Flutter Packages
```bash
flutter pub get
```

### 3. Create a `.env` file and set the following variables
`BASE_URL`

### 4. Connect your device or emulator and run the app
```bash
flutter run
```
## Download
Here are the [Google Play](https://play.google.com/store/apps/details?id=in.ac.vit.riviera23&hl=en&gl=US) and [App Store](https://play.google.com/store/apps/details?id=in.ac.vit.riviera23&hl=en&gl=US) links. 
> **NOTE:**  The app has been removed from the App Store by the client few weeks after the event concluded.

## Contributors

<table>
	<tr align="center">
		<td>
		Rudrank Basant
		<p align="center">
			<img src = "https://avatars.githubusercontent.com/u/85751479?v=4" width="150" height="150" alt="Rudrank Basant">
		</p>
			<p align="center">
				<a href = "https://github.com/rudrankbasant">
					<img src = "http://www.iconninja.com/files/241/825/211/round-collaboration-social-github-code-circle-network-icon.svg" width="36" height = "36" alt="GitHub"/>
				</a>
				<a href = "https://www.linkedin.com/in/rudrankbasant/">
					<img src = "http://www.iconninja.com/files/863/607/751/network-linkedin-social-connection-circular-circle-media-icon.svg" width="36" height="36" alt="LinkedIn"/>
				</a>
			</p>
		</td>
	</tr>
</table>

<p align="center">
	Made with ❤ by <a href="https://dscvit.com">DSC VIT</a>
</p>
