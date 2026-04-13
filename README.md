# ChessPractice

A SwiftUI iOS app built to deepen hands-on experience with **Combine**, **URLSessionWebSocketTask**, and **Swift Actors** — using a simulated WebSocket service that streams real chess moves from the Kasparov vs. Topalov 1999 game.

Built as a portfolio project while preparing to contribute to a chess platform at scale.

---

## Tech Stack

- **Swift / SwiftUI** — UI built entirely in SwiftUI
- **Combine** — reactive pipelines for processing incoming move events
- **URLSessionWebSocketTask** — WebSocket communication layer
- **Swift Actors** — thread-safe board state management
- **Clean Architecture + MVVM** — clear separation between Networking, Domain, ViewModel, and Views layers
- **Swift Package (ChessNetworking)** — networking layer modularized as a local Swift package
- **Unit Testing (XCTest)** — core logic and ViewModel covered with unit tests
- **CI/CD** — automated with Fastlane + GitHub Actions
- **i18n** — localized in English and Spanish
- **a11y** — VoiceOver labels and Dynamic Type support

---

## Architecture

The project follows Clean Architecture principles with strict layer separation:

- `ChessNetworking` — local Swift package containing the WebSocket service protocol, its live implementation using `URLSessionWebSocketTask`, and a mock service that simulates move events using a `Timer`
- `Domain` — model definitions (`ChessMove`) and the `ChessBoardActor`, a Swift Actor that ensures thread-safe board state updates
- `ViewModel` — `@MainActor` ObservableObject that subscribes to the Combine pipeline and drives the UI
- `Views` — SwiftUI views consuming the ViewModel with no direct dependency on networking or domain logic

---

## Features

- Connects to a WebSocket (or mock service) and receives chess moves in real time
- Filters and validates incoming moves using Combine operators (`map`, `compactMap`, `combineLatest`, `sink`)
- Displays move history in a clean SwiftUI list
- Shows live connection status
- Localized in English and Spanish
- Accessible via VoiceOver with descriptive labels and Dynamic Type support

---

## CI/CD

Automated pipeline using **Fastlane** and **GitHub Actions**:

- Runs unit tests on every push to `main`
- Validates build integrity before merge

---

## Why this project

I built ChessPractice to bridge specific gaps in my iOS experience — particularly around reactive programming with Combine, real-time communication with WebSockets, and concurrency with Swift Actors. Chess felt like the natural domain to practice in.
