MenuMate  

MenuMate is a full-stack mobile application designed to improve the dining experience for Michigan State University students. 
It allows users to browse real-time dining hall menus, save favorite food items, and receive notifications when those items are served again.  

---

Features  
- **User Authentication**: Register with email, verify with OTP codes, and log in securely using JWT authentication.  
- **Real-Time Menus**: Scrapes dining hall menu data directly from the MSU dining website.  
- **Favorites System**: Save favorite foods and get notified when they reappear.  
- **Push Notifications**: Integrated Firebase Cloud Messaging to send alerts on Android devices.  
- **Cross-Platform UI**: Flutter/Dart app with navigation for login, registration, OTP verification, home, and dining pages.  

---

Tech Stack  

### Frontend  
- **Framework**: Flutter  
- **Language**: Dart  
- **Packages**: `shared_preferences`, navigation, Firebase for notifications  

### Backend  
- **Framework**: Django  
- **Language**: Python  
- **APIs**: REST API endpoints for login, registration, OTP, dining, and favorites  
- **Authentication**: JWT tokens for secure sessions  
- **Email**: Custom email service for OTP delivery  
- **Web Scraping**: Automated scripts to fetch dining hall menus  

### Notifications  
- **Service**: Firebase Cloud Messaging (Android push notifications)  
- Planned future support for iOS (requires APNs setup with Apple Developer account)  

### Database  
- **SQL database** managed via **Django ORM**  
- Tables for Users, Favorites, OTPs, and Dining Information  
