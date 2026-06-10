//
//  SettingsView.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/6.
//

import SwiftUI
import WidgetKit
import CoreLocation
import UIKit

struct SettingsView: View {

    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: SettingTemplatesView()) {
                        Label("Templates", systemImage: "doc.on.doc")
                    }
                    NavigationLink(destination: DocsHomeView()) {
                        Label("Docs", systemImage: "book")
                    }
                    Button {
                        WidgetCenter.shared.reloadAllTimelines()
                        alertMessage = NSLocalizedString("Widgets are refreshed :)", comment: "")
                        showingAlert = true
                    } label: {
                        Label("Refresh All Widgets", systemImage: "arrow.clockwise")
                    }
                } header: {
                    Text("Widget")
                }

                Section {
                    NavigationLink(destination: ExportView()) {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                    NavigationLink(destination: ImportView()) {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                    NavigationLink {
                        SettingsICloudDetailView()
                    } label: {
                        SettingsICloudRowView()
                    }
                } header: {
                    Text("Data")
                }

                Section {
                    NavigationLink(destination: SettingsLocationDetailView()) {
                        SettingsLocationRowView()
                    }
                } header: {
                    Text("Permissions")
                }

                Section {
                    NavigationLink(destination: AppIconsView()) {
                        Label("App Icons", systemImage: "app.dashed")
                    }
                    NavigationLink(destination: AboutView()) {
                        Label("About", systemImage: "info.circle")
                    }
                } header: {
                    Text("App")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - iCloud Row

private struct SettingsICloudRowView: View {
    var body: some View {
        let isEnabled = sharedScriptManager.isICloudAvaliable()
        HStack {
            Label("iCloud", systemImage: "icloud")
            Spacer()
            Text(isEnabled ? NSLocalizedString("Enabled", comment: "") : NSLocalizedString("Disabled", comment: ""))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - iCloud Detail View

struct SettingsICloudDetailView: View {
    var body: some View {
        List {
            Section {
                SettingsICloudView()
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("iCloud")
    }
}

// MARK: - Location Summary Row

private struct SettingsLocationRowView: View {
    @State private var statusText: String = NSLocalizedString("Checking...", comment: "")

    var body: some View {
        HStack {
            Label("Location", systemImage: "location")
            Spacer()
            Text(statusText)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .onAppear {
            let status = CLLocationManager().authorizationStatus
            switch status {
            case .authorizedWhenInUse:
                statusText = NSLocalizedString("When In Use", comment: "")
            case .authorizedAlways:
                statusText = NSLocalizedString("Always", comment: "")
            case .denied:
                statusText = NSLocalizedString("Denied", comment: "")
            case .restricted:
                statusText = NSLocalizedString("Restricted", comment: "")
            case .notDetermined:
                statusText = NSLocalizedString("Not Authorized", comment: "")
            @unknown default:
                statusText = NSLocalizedString("Not Authorized", comment: "")
            }
        }
    }
}

// MARK: - Location Detail View

struct SettingsLocationDetailView: View {
    @StateObject private var manager = SettingsLocationManager()

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text(LocalizedStringKey(manager.state.title))
                            .font(.headline)
                    }

                    Text(LocalizedStringKey(manager.state.detail))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }

            if manager.state.shouldShowAuthorizeButton || manager.state.shouldShowOpenSettingsButton {
                Section {
                    if manager.state.shouldShowAuthorizeButton {
                        Button {
                            manager.requestAuthorization()
                        } label: {
                            HStack {
                                Spacer()
                                Text(manager.isRequesting ? "Authorizing..." : "Authorize")
                                Spacer()
                            }
                        }
                        .disabled(manager.isRequesting)
                    }

                    if manager.state.shouldShowOpenSettingsButton {
                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("Open Settings")
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Location")
    }
}

private enum LocationAuthorizationState {
    case checking, disabled, notDetermined, restricted, denied, authorizedWhenInUse, authorizedAlways

    var title: String {
        switch self {
        case .checking: return "Checking..."
        case .disabled: return "Location Disabled"
        case .notDetermined: return "Not Authorized"
        case .restricted: return "Restricted"
        case .denied: return "Access Denied"
        case .authorizedWhenInUse: return "Authorized (When In Use)"
        case .authorizedAlways: return "Authorized (Always)"
        }
    }

    var detail: String {
        switch self {
        case .checking: return "Checking Location permissions."
        case .disabled: return "Location services are disabled on this device."
        case .notDetermined: return "Tap Authorize to request access for location."
        case .restricted: return "Location access is restricted by system policy."
        case .denied: return "Access is denied. Enable ScriptWidget in Settings."
        case .authorizedWhenInUse: return "Location access is ready for scripts and widgets."
        case .authorizedAlways: return "Location access is ready for scripts and widgets."
        }
    }

    var shouldShowAuthorizeButton: Bool {
        switch self {
        case .notDetermined: return true
        default: return false
        }
    }

    var shouldShowOpenSettingsButton: Bool {
        switch self {
        case .restricted, .denied: return true
        default: return false
        }
    }
}

private final class SettingsLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var state: LocationAuthorizationState = .checking
    @Published var isRequesting = false

    private let locationManager = CLLocationManager()
    private var hasRequestedLocation = false

    override init() {
        super.init()
        locationManager.delegate = self
        refresh()
    }

    func refresh() {
        applyAuthorizationStatus(locationManager.authorizationStatus)
        checkLocationServicesEnabled()
    }

    func requestAuthorization() {
        isRequesting = true
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorizationChange(status: manager.authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorizationChange(status: status)
    }

    private func handleAuthorizationChange(status: CLAuthorizationStatus) {
        applyAuthorizationStatus(status)
        checkLocationServicesEnabled()
    }

    private func applyAuthorizationStatus(_ status: CLAuthorizationStatus) {
        state = makeState(status: status)
        if status != .notDetermined {
            isRequesting = false
        }
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            requestLocationIfNeeded()
        }
    }

    private func checkLocationServicesEnabled() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let enabled = CLLocationManager.locationServicesEnabled()
            DispatchQueue.main.async {
                guard let self = self else { return }
                if !enabled {
                    self.state = .disabled
                } else if self.state == .disabled {
                    self.applyAuthorizationStatus(self.locationManager.authorizationStatus)
                }
            }
        }
    }

    private func makeState(status: CLAuthorizationStatus) -> LocationAuthorizationState {
        switch status {
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        case .denied: return .denied
        case .authorizedAlways: return .authorizedAlways
        case .authorizedWhenInUse: return .authorizedWhenInUse
        @unknown default: return .notDetermined
        }
    }

    private func requestLocationIfNeeded() {
        guard !hasRequestedLocation else { return }
        hasRequestedLocation = true
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        ScriptWidgetRuntimeLocation.cacheLocation(
            location,
            accuracyAuthorization: ScriptWidgetRuntimeLocation.accuracyAuthorizationString(manager)
        )
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("settings location error: \(error)")
    }
}

// MARK: - Previews

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 12 Pro")
    }
}
