## VoltHub (SwiftUI)

VoltHub is an iOS SwiftUI prototype that maps the main user journeys for a utility management platform (Super Admin, District/City Heads, Support, Consumer, Worker, etc.). The app is currently a fully static UI showcase with no backend integration—every view uses mocked data and navigation only.

### Status
- UI flows for the major roles are present (Super Admin, District Head, City Head, Support, Consumer, Worker, Create Employee, Meters, Operations, etc.).
- **No backend integration yet:** all views are static; API calls are stubbed/not invoked.
- The root view boots into `SuperAdminHomeView` for quick previewing.

### Tech Stack
- SwiftUI
- Lightweight DI via `AppContainer`
- Theming via `ThemeManager`

### Project Structure
- `VoltHub/App`: App entry (`VoltHubApp`, `RootView`), dependency container, theming helpers.
- `VoltHub/Features`: Role-specific modules with `Models`, `ViewModels` (where present), and `Views` for each feature area.
- `VoltHub/Core/Networking`: Early scaffolding for API layer (endpoints, interceptors, service protocol/implementation).
- `VoltHub/Core/Security`: Token storage abstraction and Keychain-backed implementation.
- `VoltHub/Assets.xcassets`: App icon and colors.

### Running the App
1) Open `VoltHub.xcodeproj` in Xcode (iOS 17+ recommended).  
2) Select the `VoltHub` scheme.  
3) Run on a simulator or device.

### Working Notes
- Because the UI is static today, networking and authentication code are not wired to live services. When adding backend integration, start by connecting the `APIService` implementation and updating the role flows to consume real data.
- If you want to preview other roles quickly, switch the view presented in `RootView` (e.g., `CityHeadHomeView()`, `ConsumerHomeView()`, `WorkersHomeView()`).

### Future Enhancements (suggested)
- Hook up real authentication and session handling.
- Replace mocked/static data with API-driven content per role.
- Add navigation/routing that mirrors backend permissions.
- Expand unit/UI coverage once data is dynamic.
