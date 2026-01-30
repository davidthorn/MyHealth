# Architecture Rules

## Scope
This document captures the current architecture rules for the HealthKit app UI layer.

## Layers and Ownership
- The app is UI-only for now; HealthKit business logic will be implemented later in a Swift package.
- Each `View` has a corresponding `ViewModel`.
- Each `ViewModel` has a `Service`.
- The `View` owns the `ViewModel` (the `View` initializes it in its constructor).
- The `View` receives the `Service` as a protocol.
- Concrete `Service` implementations live at the app level and are passed via constructor injection.
- The `View` only talks to the `ViewModel`.
- The `ViewModel` talks to the `Service` protocol.

## Data Flow
- Data from `Service` should be sent via `AsyncStream` to ensure thread safety and avoid isolation issues.

## Models
- All models live in a `Models` folder.
- All models are `public`.
- Every class, struct, and actor is `public` and has a `public` initializer.
- One data structure per file.

## Navigation
- Navigation is driven by `Hashable` types.
- Top-level views used as `TabView` tab items must be suffixed with `Scene`.
- `Scene` views are the place where all destination declarations live for `NavigationStack`.
