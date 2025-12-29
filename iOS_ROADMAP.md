# Magic Friend iOS - Implementation Roadmap

## 1. Goal
Convert the "Imagine Friend 2" web experience into a **Native iOS Application (SwiftUI)** suitable for the App Store.

## 2. Architecture Shift
*   **Frontend**: React (Browser) -> **SwiftUI (Native)**.
*   **Backend**: Remains **Node.js (Express)**.
*   **AI Service**: Remains **Python (MuseTalk)**.
*   **Communication**: API (REST) + Streaming (proxy).

## 3. Confirmed Strategy

### A. Hosting & Connectivity
*   **Status**: Pending. User will provision scaling GPUs.
*   **Dev Plan**: Start with `localhost` tunnel (ngrok) or local IP until Production GPUs are ready.

### B. Payments: Apple In-App Purchases
*   **Decision**: Strictly **Apple IAP**.
*   **Tool**: **RevenueCat** (to manage receipt validation and entitlement logic easily).
*   **Constraint**: Use StoreKit 2.

### C. Authentication
*   **Requirement**: "Sign in with Apple" is **mandatory** (Apple Guideline 4.8).
*   **Plan**: Implement Native "Sign in with Apple" + Token verification on Node backend.

## 4. Implementation Phases

### Phase 1: Foundation (Hello World)
*   Setup Xcode Project (SwiftUI).
*   **Dependencies**: RevenueCat, Alamofire (Networking), Kingfisher (Image Caching).
*   Configure Info.plist (Camera Permissions, Microphone Usage).
*   Build basic Navigation Stack.

### Phase 2: Magic Object Creation (Vision)
*   **Feature**: Camera View (AVFoundation).
*   **Action**: Capture Photo -> Resize -> Upload to Node API (`/api/generate-cute-face`).
*   **UI**: Show "Processing" state (DALL-E Generation).
*   **Result**: Display the generated transparent PNG overlay.

### Phase 3: Personality & Chat (Data)
*   **Feature**: Connect to `/api/character-card` (GPT-5.2 Vision).
*   **UI**: Display generated Bio/Name.
*   **Chat Interface**: SwiftUI List for messages (User/Assistant).

### Phase 4: The "Magical" Interface (Streaming Video)
*   **Microphone**: Record Audio (AVAudioRecorder) -> Upload to `/api/conversation/message`.
*   **Playback**: `AVPlayer` streaming from Python Service (`/api/proxy/stream/...`).
*   **Optimization**: Ensure Low Latency playback (Configure AVPlayerItem buffering).

### Phase 5: App Store Polish
*   **Payments**: Integrate RevenueCat (StoreKit).
*   **Icons/Splashes**: Generate App Icon assets.
*   **Submission**: Archive & Upload to TestFlight.

## 5. Developer Prerequisites (Checklist)
- [ ] **Mac with Xcode 15+** installed.
- [ ] **Apple Developer Account** ($99/yr) - Required for TestFlight/App Store.
- [ ] **Public Server Endpoint** (e.g., `https://api.magicfriend.app` or ngrok/tunnel).
