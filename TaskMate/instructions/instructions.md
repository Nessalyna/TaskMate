iOS Project Tracker App Implementation Guide
App Purpose
The Project Tracker App enables users to manage projects and collaborate in real-time by creating, assigning, and tracking tasks within a centralized platform. It addresses disorganized workflows and lack of transparency by offering task management, progress tracking, and team communication, optimized for iOS with a native, intuitive interface.
Feature List
The app includes the following core features, each numbered for reference:

User Authentication - Secure login/signup with email and SSO (e.g., Apple, Google).
Dashboard - Displays an overview of projects and tasks with quick actions.
Project Management - Create, edit, and view projects with task organization.
Task Management (Core Feature) - Create, assign, track, and collaborate on tasks in real-time.
Real-Time Collaboration - Enable team communication via task comments and notifications.
Notifications - Real-time alerts for task updates, assignments, and mentions.
Settings - Manage user profile and notification preferences.

Navigation
A TabView provides tab bar navigation with three tabs: Dashboard, Notifications, and Settings, ensuring users can quickly access primary functionalities.

Each tab uses a NavigationStack for hierarchical navigation, allowing users to drill down into project or task details without losing context.

Modal presentations (via .sheet) are used for creation and feedback screens to focus user input and maintain a clean workflow.

Behavior:
The tab bar remains accessible except during authentication or modals to prioritize user control.
Navigation stack preserves state (e.g., returning to the same project) for continuity.
Notifications link directly to relevant screens to maintain context and reduce friction.
Accessibility labels ensure inclusivity for VoiceOver users.

SwiftData Setup
Why: SwiftData provides a robust, type-safe local storage solution for iOS, enabling offline functionality and seamless integration with SwiftUI. Syncing with Firebase ensures real-time collaboration across devices, balancing local performance with cloud-based team features.

Implementation:
Define models (User, Project, Task, Comment, Notification) to store app data locally, ensuring offline access to critical information.
Configure SwiftData in the app’s entry point to manage the data context, enabling automatic persistence and querying.
Sync local SwiftData changes with Firebase Firestore for real-time updates, ensuring team members see the latest project and task states.
Behavior: Offline changes are saved locally and synced when connectivity is restored, providing uninterrupted access. Real-time listeners ensure immediate updates across devices.

Implementation Instructions
1. User Authentication

Purpose: Authenticate users and onboard new users.
Implementation:
Use Firebase Authentication for email/password and SSO (Sign in with Apple, Google OAuth).
Create a LoginViewController (SwiftUI: LoginView) with:
Text fields for email/password.
Buttons for Sign in, Sign up, and SSO options.
"Forgot Password" link to trigger Firebase password reset email.

User Interaction:
Users enter email/password or select SSO on a login screen.
New users provide email/name during signup; a "Forgot Password" option sends a reset email.
SSO buttons initiate provider-specific flows for quick access.

Implement
Use Firebase Authentication for email/password and SSO to leverage a secure, scalable backend.
SignInWithApple using ASAuthorizationController for Apple SSO.
For Google SSO, integrate GoogleSignIn SDK, handling OAuth flow.
On successful authentication, Store user data (ID, name, email) in SwiftData for offline access and sync with Firestore for consistency. fetch user profile from Firebase Firestore (users collection)/ SwiftData.
Onboarding for new users: Collect name and optional workspace name, store in Firestore.


Correct Behavior:
Validate email/password format before submission.
Display error messages for failed logins (e.g., "Invalid credentials").
Redirect to Dashboard on successful login/signup.
Ensure Sign in with Apple complies with Apple’s Human Interface Guidelines (e.g., button styling).



2. Dashboard

Purpose: Provide a project and task overview with quick navigation.

User Interaction:
Users view tasks assigned to them and all projects in a list format.
Tapping a task or project navigates to its details.
A "New" button opens a modal to choose between creating a project or task.

Implementation:
Use SwiftUI’s List and @Query to display tasks and projects from SwiftData, ensuring fast local access.
Sync data with Firestore for real-time updates, keeping the Dashboard current.
Implement modal presentation for creation options to maintain focus during input


Correct Behavior:
Display tasks sorted by due date (ascending)to prioritize urgent items..
Show project name, progress (e.g., percentage of completed tasks), and deadline.
Tapping a project navigates to Project Details; tapping a task navigates to Task Details.
Handle empty states with a message (e.g., "No tasks assigned").



3. Project Management

Purpose: Allow users to create, edit, and view projects.

User Interaction:
Users create projects by entering name, description, dates, and members in a modal form.
View project tasks in list or Kanban format; tap to edit or create new tasks.

Implementation:
Present a modal form for project creation, storing data in SwiftData and syncing with Firestore.
Display tasks in a project-specific view with a toggle for list/Kanban modes, using SwiftData queries for performance.
Allow editing via a similar modal interface to maintain consistency.

Correct Behavior:
Require a non-empty project name to ensure clarity.
Calculate progress based on task completion for real-time feedback.
Sync member changes instantly to support collaboration.
Return to the Dashboard or Project Details after save/cancel actions.




4. Task Management (Core Feature)

Purpose: Create, assign, track, and collaborate on tasks in real-time.

User Interaction:
Users create tasks via a modal form, entering title, description, due date, priority, assignee, and attachments.
In the task details view, users edit fields, update status, add comments, or upload attachments.
Due date reminders and assignee notifications keep users informed.

Implementation:
Use a modal form for task creation, storing data in SwiftData for offline access and syncing with Firestore for collaboration.
Display task details in a form-based view, allowing status updates and comment integration for seamless interaction.
Use Firebase Storage for attachments and UNUserNotificationCenter for local due date alerts.
Send push notifications for assignments via Firebase Cloud Messaging.




Correct Behavior:
Require a non-empty title to ensure task clarity.
Update status in SwiftData and Firestore instantly for real-time tracking.
Send notifications to assignees to prompt action.
Store attachment URLs in SwiftData after uploading to Firebase Storage.
Schedule and deliver due date alerts accurately.
Return to Dashboard or Project Details after save/cancel.



5. Real-Time Collaboration

Purpose: Enable team communication via task comments and updates.
Why: Collaboration ensures team members stay aligned, addressing transparency issues by allowing real-time discussions within tasks. Notifications for comments enhance responsiveness.

User Interaction:
Users add comments to tasks, tag team members with @username, and view threaded messages in the task details view.
Receive notifications for new comments or mentions.

Implementation:
Embed a comment section in the task details view, storing comments in SwiftData and syncing with Firestore.
Support tagging by querying Firestore’s user list for valid usernames.
Use Firebase Cloud Messaging for comment-related notifications.

Correct Behavior:
Display comments in chronological order (newest at bottom).
Allow tagging users with @username (search users collection for matches).
Ensure comments sync across devices in real-time.
Notify mentioned users via push notifications.Ensure comments are accessible offline via SwiftData.



6. Notifications

Purpose: Alert users to task updates, assignments, and comments.

Why: Notifications keep users informed of critical updates, ensuring timely responses and maintaining project momentum, especially in collaborative settings.

User Interaction:
Users view notifications in a list under the Notifications tab.
Tap a notification to navigate to the relevant task or project.
Swipe to mark notifications as read.

Implementation:
Display notifications from SwiftData, synced with Firestore, in a list format.
Link notifications to task or project details using NavigationStack.
Use Firebase Cloud Messaging for push notifications, even in the background.


Correct Behavior:
Display unread notifications with a badge or highlight.
Tapping a notification navigates to the relevant Task Details or Project Details screen.
Update read status in SwiftData and Firestore on swipe.
Ensure push notifications are delivered even when the app is in the background.



7. Settings

Purpose:  Manage user profile, notification preferences, and submit feedback.

Why: Settings provide user control over their experience, while feedback submission allows developers to improve the app based on user input, enhancing long-term usability.

User Interaction:
Users edit their name, upload a profile picture, toggle notification preferences, or submit feedback via a modal form.
A logout option clears the session.
Feedback is entered in a text field and sent as an email to a predefined developer address

Implementation:
Create a Settings view with form sections for profile, notifications, and feedback.
Allow profile picture uploads using iOS’s photo picker, storing images in Firebase Storage and URLs in SwiftData.
Present a modal feedback form with a text field; use iOS’s email composer to send feedback to a developer email address (e.g., feedback@projecttracker.com).
Save profile and preference changes in SwiftData, syncing with Firestore.
Implement logout by clearing Firebase Authentication and local data

Correct Behavior:
Save profile changes and picture URLs instantly to SwiftData and Firestore.
Require non-empty feedback before enabling email submission.
Launch the email composer with the feedback pre-filled and addressed to the developer.
Reflect profile updates across devices.
Redirect to the login screen on logout..





