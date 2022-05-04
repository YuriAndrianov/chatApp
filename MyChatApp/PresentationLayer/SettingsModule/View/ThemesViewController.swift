//
//  ThemesViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 11.03.2022.
//

import UIKit

final class ThemesViewController: UIViewController {
    
    private let themePicker: IThemeService
    private let classicThemeView = CustomThemeView()
    private let dayThemeView = CustomThemeView()
    private let nightThemeView = CustomThemeView()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(with themePicker: IThemeService) {
        self.themePicker = themePicker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.themePicker = ThemePicker.shared
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        highlightButton()
        setupStackView()
    }
    
    private func setupUI() {
        view.backgroundColor = themePicker.currentTheme?.backgroundColor
        title = "Settings"
    }
    
    private func highlightButton() {
        // highlight button depending on current theme
        switch themePicker.currentTheme {
        case is ClassicTheme: classicThemeView.isButtonHighlited = true
        case is DayTheme: dayThemeView.isButtonHighlited = true
        case is NightTheme: nightThemeView.isButtonHighlited = true
        default: classicThemeView.isButtonHighlited = true
        }
    }
    
    private func setupStackView() {
        [classicThemeView, dayThemeView, nightThemeView].forEach { stackView.addArrangedSubview($0) }
        
        classicThemeView.configurate(with: .classic)
        dayThemeView.configurate(with: .day)
        nightThemeView.configurate(with: .night)
        
        [classicThemeView.button, dayThemeView.button, nightThemeView.button].forEach {
            $0?.addTarget(self, action: #selector(themeChosen(_:)), for: .touchUpInside)
        }
        
        [classicThemeView.tapGesture, dayThemeView.tapGesture, nightThemeView.tapGesture].forEach {
            $0?.addTarget(self, action: #selector(themeChosen(_:)))
        }
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }
    
    @objc private func themeChosen(_ sender: Any) {
        var chosenTheme: ThemeType
        
        if sender is UIButton {
            switch sender {
            case classicThemeView.button as UIButton: chosenTheme = .classic
            case dayThemeView.button as UIButton: chosenTheme = .day
            case nightThemeView.button as UIButton: chosenTheme = .night
            default: return
            }
        } else {
            switch sender {
            case classicThemeView.tapGesture as UITapGestureRecognizer: chosenTheme = .classic
            case dayThemeView.tapGesture as UITapGestureRecognizer: chosenTheme = .day
            case nightThemeView.tapGesture as UITapGestureRecognizer: chosenTheme = .night
            default: return
            }
        }
        
        // highlight button according to the chosen theme
        [classicThemeView, dayThemeView, nightThemeView].forEach {
            $0.isButtonHighlited = ($0.theme == chosenTheme) ? true : false
        }
        
        // applying the chosen theme
        themePicker.apply(chosenTheme) { [weak self] theme in
            self?.updateUI(with: theme)
        }
        
    }
    
    func updateUI(with theme: ITheme?) {
        guard let theme = theme else { return }
        
        UIView.animate(withDuration: 0.05) {
            self.view.backgroundColor = theme.backgroundColor
            self.classicThemeView.label?.textColor = theme.fontColor
            self.dayThemeView.label?.textColor = theme.fontColor
            self.nightThemeView.label?.textColor = theme.fontColor
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
}
