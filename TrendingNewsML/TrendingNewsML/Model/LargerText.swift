//
//  LargerTextObserver.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 08/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI
import Combine

class LargerText: ObservableObject {
    let didChange = PassthroughSubject<LargerText, Never>()
    
    @Published var active = false
    
    init() {
        self.active = isAccessibilityActive(UIApplication.shared.preferredContentSizeCategory)
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any] {
            if let contentSizeCategory = userInfo["UIContentSizeCategoryNewValueKey"] as? UIContentSizeCategory {
                self.active = isAccessibilityActive(contentSizeCategory)
            }
        }
    }
    
    func isAccessibilityActive(_ contentSizeCategory: UIContentSizeCategory) -> Bool {
        return contentSizeCategory == .accessibilityMedium ||
            contentSizeCategory == .accessibilityLarge ||
            contentSizeCategory == .accessibilityExtraLarge ||
            contentSizeCategory == .accessibilityExtraExtraLarge ||
            contentSizeCategory == .accessibilityExtraExtraExtraLarge
    }
}
