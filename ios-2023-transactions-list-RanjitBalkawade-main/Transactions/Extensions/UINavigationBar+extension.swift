//
//  UINavigationBar+extension.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import UIKit
import BackbaseMDS

extension UINavigationBar {
    
    /// Updates the appearance of the navigation bar based on the app's theme.
    static func updateApparanceWithTheme() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: BackbaseUI.shared.colors.onPrimary]
        navigationBarAppearance.backgroundColor = BackbaseUI.shared.colors.primary
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
