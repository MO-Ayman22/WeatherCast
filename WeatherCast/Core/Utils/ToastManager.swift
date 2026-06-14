//
//  ToastManager.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 13/06/2026.
//

import UIKit
import SwiftUI

enum ToastType {
    case favorite
    case info

    var backgroundColor: UIColor {
        switch self {
        case .favorite:
            return UIColor(
                red: 46/255,
                green: 160/255,
                blue: 100/255,
                alpha: 0.95
            )

        case .info:
            return UIColor(
                red: 200/255,
                green: 60/255,
                blue: 60/255,
                alpha: 0.95
            )
        }
    }

    var icon: String {
        switch self {
        case .favorite: return "checkmark.circle.fill"
        case .info:   return "heart.slash.fill"
        }
    }
}

final class ToastManager {

    static let shared = ToastManager()
    private init() {}

    private weak var activeToast: UIView?

    func show(
        message: String,
        type: ToastType = .favorite,
        duration: TimeInterval = 2.0,
        isTabBarHidden: Bool = false
    ) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else { return }

        dismissActive()

        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.backgroundColor = .clear
        wrapper.layer.shadowColor = UIColor.black.cgColor
        wrapper.layer.shadowOpacity = 0.25
        wrapper.layer.shadowOffset = CGSize(width: 0, height: 4)
        wrapper.layer.shadowRadius = 12
        wrapper.alpha = 0

        let container = UIView()
        container.backgroundColor = type.backgroundColor
        container.layer.cornerRadius = 16
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: type.icon)
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        wrapper.addSubview(container)
        container.addSubview(iconView)
        container.addSubview(label)
        window.addSubview(wrapper)

        let bottomOffset: CGFloat = isTabBarHidden ? -24 : -90

        NSLayoutConstraint.activate([
            wrapper.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 24),
            wrapper.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -24),
            wrapper.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: bottomOffset),

            container.topAnchor.constraint(equalTo: wrapper.topAnchor),
            container.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 52),

            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),

            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14)
        ])

        activeToast = wrapper
        wrapper.transform = CGAffineTransform(translationX: 0, y: 60)

        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            wrapper.alpha = 1
            wrapper.transform = .identity
        } completion: { _ in
            UIView.animate(
                withDuration: 0.3,
                delay: duration,
                options: .curveEaseIn
            ) {
                wrapper.alpha = 0
                wrapper.transform = CGAffineTransform(translationX: 0, y: 20)
            } completion: { _ in
                wrapper.removeFromSuperview()
            }
        }
    }

    func showWithUndo(
        message: String,
        duration: TimeInterval = 4.0,
        isTabBarHidden: Bool = true,
        onUndo: @escaping () -> Void
    ) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else { return }

        dismissActive()

        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.backgroundColor = .clear
        wrapper.alpha = 0
        wrapper.isUserInteractionEnabled = true

        wrapper.layer.shadowColor = UIColor.black.cgColor
        wrapper.layer.shadowOpacity = 0.25
        wrapper.layer.shadowOffset = CGSize(width: 0, height: 4)
        wrapper.layer.shadowRadius = 12

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(
            red: 40/255,
            green: 40/255,
            blue: 60/255,
            alpha: 0.95
        )
        container.layer.cornerRadius = 16
        container.clipsToBounds = true

        let iconView = UIImageView(
            image: UIImage(systemName: "heart.slash.fill")
        )
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1

        let undoButton = UIButton(type: .system)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.setTitle("Undo", for: .normal)
        undoButton.setTitleColor(
            UIColor(Color(hex: "#4A90D9")),
            for: .normal
        )
        undoButton.titleLabel?.font = .systemFont(
            ofSize: 14,
            weight: .bold
        )

        undoButton.setContentHuggingPriority(
            .required,
            for: .horizontal
        )

        undoButton.setContentCompressionResistancePriority(
            .required,
            for: .horizontal
        )

        label.setContentCompressionResistancePriority(
            .defaultLow,
            for: .horizontal
        )

        undoButton.addAction(
            UIAction { [weak self] _ in
                onUndo()
                self?.dismissActive()
            },
            for: .touchUpInside
        )

        wrapper.addSubview(container)

        container.addSubview(iconView)
        container.addSubview(label)
        container.addSubview(undoButton)

        window.addSubview(wrapper)

        let bottomOffset: CGFloat = isTabBarHidden ? -24 : -90

        NSLayoutConstraint.activate([

            wrapper.leadingAnchor.constraint(
                equalTo: window.leadingAnchor,
                constant: 24
            ),

            wrapper.trailingAnchor.constraint(
                equalTo: window.trailingAnchor,
                constant: -24
            ),

            wrapper.bottomAnchor.constraint(
                equalTo: window.safeAreaLayoutGuide.bottomAnchor,
                constant: bottomOffset
            ),

            container.topAnchor.constraint(
                equalTo: wrapper.topAnchor
            ),

            container.leadingAnchor.constraint(
                equalTo: wrapper.leadingAnchor
            ),

            container.trailingAnchor.constraint(
                equalTo: wrapper.trailingAnchor
            ),

            container.bottomAnchor.constraint(
                equalTo: wrapper.bottomAnchor
            ),

            container.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 52
            ),

            iconView.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 16
            ),

            iconView.centerYAnchor.constraint(
                equalTo: container.centerYAnchor
            ),

            iconView.widthAnchor.constraint(
                equalToConstant: 22
            ),

            iconView.heightAnchor.constraint(
                equalToConstant: 22
            ),

            label.leadingAnchor.constraint(
                equalTo: iconView.trailingAnchor,
                constant: 10
            ),

            label.centerYAnchor.constraint(
                equalTo: container.centerYAnchor
            ),

            label.trailingAnchor.constraint(
                equalTo: undoButton.leadingAnchor,
                constant: -8
            ),

            undoButton.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -16
            ),

            undoButton.centerYAnchor.constraint(
                equalTo: container.centerYAnchor
            ),

            undoButton.heightAnchor.constraint(
                equalToConstant: 44
            )
        ])

        activeToast = wrapper

        wrapper.transform = CGAffineTransform(
            translationX: 0,
            y: 60
        )

        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            wrapper.alpha = 1
            wrapper.transform = .identity
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + duration
        ) { [weak self, weak wrapper] in

            guard self?.activeToast === wrapper else {
                return
            }

            UIView.animate(
                withDuration: 0.3
            ) {
                wrapper?.alpha = 0
                wrapper?.transform = CGAffineTransform(
                    translationX: 0,
                    y: 20
                )
            } completion: { _ in
                wrapper?.removeFromSuperview()
            }
        }
    }
    
    private func dismissActive() {
        activeToast?.removeFromSuperview()
        activeToast = nil
    }
}
