//
//  AppLaunchChecker.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation

final class AppLaunchChecker {
    private let launchedKey = "hasLaunchedBefore"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var isFirstLaunch: Bool {
        !userDefaults.bool(forKey: launchedKey)
    }

    func markLaunched() {
        userDefaults.set(true, forKey: launchedKey)
    }

    func resetLaunchFlag() {
        userDefaults.set(false, forKey: launchedKey)
    }
}

