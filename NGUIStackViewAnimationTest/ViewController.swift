//
//  ViewController.swift
//  NGUIStackViewAnimationTest
//
//  Created by Noah Gilmore on 1/9/19.
//  Copyright © 2019 Noah Gilmore. All rights reserved.
//

import UIKit

final class ColorView: UIView {

    init(color: UIColor, height: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = color
        self.heightAnchor <=> height
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import UIKit

final class ExampleView: UIView {
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()

    private let button: UIButton = {
        let view = UIButton()
        view.setTitle("+ Add Front", for: [.normal])
        view.setTitleColor(UIColor.brown, for: [.normal])
        view.heightAnchor <=> 100
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()

    private let addEndButton: UIButton = {
        let view = UIButton()
        view.setTitle("+ Add End", for: [.normal])
        view.setTitleColor(UIColor.brown, for: [.normal])
        view.heightAnchor <=> 100
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()

    private let removeButton: UIButton = {
        let view = UIButton()
        view.setTitle("+ Remove Front", for: [.normal])
        view.setTitleColor(UIColor.brown, for: [.normal])
        view.heightAnchor <=> 100
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()

    private let removeEndButton: UIButton = {
        let view = UIButton()
        view.setTitle("+ Remove End", for: [.normal])
        view.setTitleColor(UIColor.brown, for: [.normal])
        view.heightAnchor <=> 100
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        addSubview(stackView)
        stackView.disableTranslatesAutoresizingMaskIntoConstraints()
        stackView.topAnchor <=> self.topAnchor
        stackView.leadingAnchor <=> self.leadingAnchor
        stackView.trailingAnchor <=> self.trailingAnchor

        addSubview(button)
        button.disableTranslatesAutoresizingMaskIntoConstraints()
        button.topAnchor <=> self.topAnchor
        button.leadingAnchor <=> self.leadingAnchor
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        addSubview(addEndButton)
        addEndButton.disableTranslatesAutoresizingMaskIntoConstraints()
        addEndButton.topAnchor <=> button.bottomAnchor ++ 40
        addEndButton.leadingAnchor <=> self.leadingAnchor
        addEndButton.addTarget(self, action: #selector(addEndButtonTapped), for: .touchUpInside)

        addSubview(removeButton)
        removeButton.disableTranslatesAutoresizingMaskIntoConstraints()
        removeButton.topAnchor <=> self.topAnchor
        removeButton.trailingAnchor <=> self.trailingAnchor
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)

        addSubview(removeEndButton)
        removeEndButton.disableTranslatesAutoresizingMaskIntoConstraints()
        removeEndButton.topAnchor <=> removeButton.bottomAnchor ++ 40
        removeEndButton.trailingAnchor <=> self.trailingAnchor
        removeEndButton.addTarget(self, action: #selector(removeEndButtonTapped), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        self.insertColorView(at: .beginning)
    }

    @objc private func addEndButtonTapped() {
        self.insertColorView(at: .end)
    }

    @objc private func removeButtonTapped() {
        self.removeView(at: .beginning)
    }

    @objc private func removeEndButtonTapped() {
        self.removeView(at: .end)
    }

    enum Area {
        case beginning
        case end
    }

    private func removeView(at area: Area) {
        switch area {
        case .beginning:
            guard let first = stackView.arrangedSubviews.first else { return }
            UIView.animate(withDuration: 0.3, animations: {
                first.alpha = 0
                self.stackView.transform = CGAffineTransform(translationX: 0, y: -first.frame.height)
            }, completion: { _ in
                self.stackView.removeArrangedSubview(first)
                first.removeFromSuperview()
                self.stackView.transform = .identity
            })
        case .end:
            guard let last = stackView.arrangedSubviews.last else { return }
            UIView.animate(withDuration: 0.3, animations: {
                last.transform = CGAffineTransform(translationX: 0, y: last.frame.height)
                last.alpha = 0
            }, completion: { _ in
                self.stackView.removeArrangedSubview(last)
                last.removeFromSuperview()
            })
        }
    }

    private func insertColorView(at area: Area) {
        let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.purple, UIColor.yellow, UIColor.orange]
        let heights: [CGFloat] = [10, 30, 50, 70, 90]
        let height = heights[stackView.arrangedSubviews.count % heights.count]
        print(height)
        let view = ColorView(
            color: colors[stackView.arrangedSubviews.count % colors.count],
            height: height
        )
        let setupBlock: () -> Void
        let animationsBlock: () -> Void

        if self.stackView.arrangedSubviews.count == 0 {
            setupBlock = {
                view.transform = CGAffineTransform(translationX: 0, y: -50)
                self.stackView.insertArrangedSubview(view, at: 0)
                view.alpha = 0
            }
            animationsBlock = {
                view.transform = .identity
                view.alpha = 1
            }
        } else {
            switch area {
            case .beginning:
                setupBlock = {
                    view.isHidden = true
                    self.stackView.insertArrangedSubview(view, at: 0)
                    view.alpha = 0
                }
                animationsBlock = {
                    view.isHidden = false
                    view.alpha = 1
                }
            case .end:
                setupBlock = {
                    view.transform = CGAffineTransform(translationX: 0, y: 50 + 10)
                    self.stackView.addArrangedSubview(view)
                    view.alpha = 0
                }
                animationsBlock = {
                    view.transform = .identity
                    view.alpha = 1
                }
            }
        }

        setupBlock()
        UIView.animate(withDuration: 0.3, animations: animationsBlock)
    }
}

class ViewController: UIViewController {

    override func loadView() {
        view = ExampleView()
    }

}

