//
//  UINavigationBar+extension.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import UIKit
import BackbaseMDS

extension UINavigationBar {
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
