//
//  AppDelegate.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 14.11.2023.
//

import UIKit

@main
final class AppDelegate: UIResponder {
    // MARK: Properties
    var window: UIWindow?
}

// MARK: UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = GameViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
