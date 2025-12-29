# Xcode Setup Guide for "hellothing"

Since you are new to Xcode, follow these steps exactly to connect my code to your app.

## 1. Preparation
1.  **Sync/Pull**: Make sure you have the latest code from GitHub (`magicfriend-ios/hellothing`).
2.  **Open Xcode**: Launch Xcode on your Mac.

## 2. Setup the Files
In Xcode, you should see your project hierarchy on the left:
```text
hellothing
├── hellothing
│   ├── hellothingApp.swift (or App.swift)
│   ├── ContentView.swift
│   └── Assets.xcassets
└── Products
```

### Step A: Delete Default Files
1.  Select `hellothingApp.swift` (or `App.swift`) inside Xcode. Press **Delete** -> **Move to Trash**.
2.  Select `ContentView.swift`. Press **Delete** -> **Move to Trash**.

### Step B: Import My Code
1.  Open **Finder** and navigate to your downloaded repo: `.../magicfriend-ios/hellothing/Sources`.
2.  You will see folders: `App`, `Views`, `Services`, `Models`.
3.  **Drag and Drop** the `Sources` folder (or just the subfolders) **into Xcode** (under the yellow `hellothing` folder).
4.  **Critical**: A popup will appear.
    *   [x] **Copy items if needed**: UNCHECK THIS (If text is bold, uncheck it. We want to link to the repo files).
    *   [x] **Create groups**: Selected.
    *   **Add to targets**: Check `hellothing`.
5.  Click **Finish**.

## 3. Configure Permissions (Info.plist)
The app uses the Camera, so you must tell Apple why.
1.  Click the blue **hellothing** icon at the very top left.
2.  Click the **Info** tab.
3.  Right-click anywhere in the list -> **Add Row**.
4.  Key: `Privacy - Camera Usage Description`.
5.  Value: `We need camera access to capture objects and bring them to life using AI.`

## 4. Run It!
1.  Connect your iPhone (or select a Simulator).
    *   *Note: Camera does not work on Simulator (black screen).*
2.  Press the **Play Button** (▶️) top left.
3.  The app should launch!

## Troubleshooting
*   **"No such module"**: If you see errors about `RevenueCat`, we haven't added it yet. Comment out `import RevenueCat` if needed (I already did this in the code).
*   **Black Screen**: On Simulator this is normal. On Device, check Settings -> Privacy -> Camera.
