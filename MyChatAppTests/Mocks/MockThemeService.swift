//
//  MockThemeService.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import Foundation
@testable import MyChatApp

final class MockThemeService: IThemeService {

    var invokedCurrentThemeGetter = false
    var invokedCurrentThemeGetterCount = 0
    var stubbedCurrentTheme: ITheme!

    var currentTheme: ITheme? {
        invokedCurrentThemeGetter = true
        invokedCurrentThemeGetterCount += 1
        return stubbedCurrentTheme
    }

    var invokedApplySavedTheme = false
    var invokedApplySavedThemeCount = 0

    func applySavedTheme() {
        invokedApplySavedTheme = true
        invokedApplySavedThemeCount += 1
    }

    var invokedApply = false
    var invokedApplyCount = 0
    var invokedApplyParameters: (theme: ThemeType, Void)?
    var invokedApplyParametersList = [(theme: ThemeType, Void)]()
    var stubbedApplyCompletionResult: (ITheme, Void)?

    func apply(_ theme: ThemeType, completion: ((ITheme) -> Void)?) {
        invokedApply = true
        invokedApplyCount += 1
        invokedApplyParameters = (theme, ())
        invokedApplyParametersList.append((theme, ()))
        if let result = stubbedApplyCompletionResult {
            completion?(result.0)
        }
    }
}
