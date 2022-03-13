//
//  SettingsViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 11.03.2022.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    weak var delegate: ThemePickerProtocol?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let classicThemeView: CustomThemeView = {
        let view = CustomThemeView()
        view.button?.setImage(UIImage(named: "classicThemeButtonImage"), for: .normal)
        view.label?.text = "Classic"
        view.button?.addTarget(self, action: #selector(classicTapped), for: .touchUpInside)
        return view
    }()
    
    private let dayThemeView: CustomThemeView = {
        let view = CustomThemeView()
        view.button?.setImage(UIImage(named: "dayThemeButtonImage"), for: .normal)
        view.label?.text = "Day"
        view.button?.addTarget(self, action: #selector(dayTapped), for: .touchUpInside)
        return view
    }()
    
    private let nightThemeView: CustomThemeView = {
        let view = CustomThemeView()
        view.button?.setImage(UIImage(named: "nightThemeButtonImage"), for: .normal)
        view.label?.text = "Night"
        view.button?.addTarget(self, action: #selector(nightTapped), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ThemePicker.currentTheme?.backGroundColor
        title = "Settings"
        
        switch ThemePicker.currentTheme {
        case is ClassicTheme: classicThemeView.isButtonHighlited = true
        case is DayTheme: dayThemeView.isButtonHighlited = true
        case is NightTheme: nightThemeView.isButtonHighlited = true
        default: break
        }
        
        [classicThemeView, dayThemeView, nightThemeView].forEach { stackView.addArrangedSubview($0) }
        
        classicThemeView.tapGesture.addTarget(self, action: #selector(classicTapped))
        dayThemeView.tapGesture.addTarget(self, action: #selector(dayTapped))
        nightThemeView.tapGesture.addTarget(self, action: #selector(nightTapped))
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }
    
    @objc private func classicTapped() {
        classicThemeView.isButtonHighlited = true
        dayThemeView.isButtonHighlited = false
        nightThemeView.isButtonHighlited = false
        
        delegate?.apply(.classic)
        updateUI()
    }
    
    @objc private func dayTapped() {
        classicThemeView.isButtonHighlited = false
        dayThemeView.isButtonHighlited = true
        nightThemeView.isButtonHighlited = false
        
        delegate?.apply(.day)
        updateUI()
    }
    
    @objc private func nightTapped() {
        classicThemeView.isButtonHighlited = false
        dayThemeView.isButtonHighlited = false
        nightThemeView.isButtonHighlited = true
        
        delegate?.apply(.night)
        updateUI()
    }
    
    private func updateUI() {
        UIView.animate(withDuration: 0.05) {
            self.view.backgroundColor = ThemePicker.currentTheme?.backGroundColor
            self.classicThemeView.label?.textColor = ThemePicker.currentTheme?.fontColor
            self.dayThemeView.label?.textColor = ThemePicker.currentTheme?.fontColor
            self.nightThemeView.label?.textColor = ThemePicker.currentTheme?.fontColor
        }
    }

}
