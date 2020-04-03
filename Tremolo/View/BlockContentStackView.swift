//
//  BlockContentStackView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/01.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class BlockContentStackView: UIStackView {

    init() {
        super.init(frame: .zero)

        axis = .vertical
        distribution = .fill
        alignment = .leading
        spacing = 5
    }

    required init(coder: NSCoder) {
        fatalError()
    }

    func addContent(_ view: UIView, at idx: Int) {
        getStackView(at: idx).addArrangedSubview(view)
    }

    func setContent(_ view: UIView, at path: (Int, Int)) {
        let stackView = getStackView(at: path.0)

        if path.1 == stackView.arrangedSubviews.count {
            stackView.addArrangedSubview(view)
            return
        }

        while path.1 >= stackView.arrangedSubviews.count {
            stackView.addArrangedSubview(UIView())
        }

        stackView.arrangedSubviews[path.1].removeFromSuperview()
        stackView.insertArrangedSubview(view, at: path.1)
    }

    func content(at path: (Int, Int)) -> UIView {
        let stackView = getStackView(at: path.0)
        return stackView.arrangedSubviews[path.1]
    }

    private func getStackView(at idx: Int) -> UIStackView {
        while idx >= arrangedSubviews.count {
            let sv = defaultHStackView
            addArrangedSubview(sv)
            return sv
        }

        if let sv = arrangedSubviews[idx] as? UIStackView {
            return sv
        } else {
            let sv = defaultHStackView
            arrangedSubviews[idx].removeFromSuperview()
            insertArrangedSubview(sv, at: idx)
            return sv
        }
    }

    private var defaultHStackView: UIStackView {
        UIStackView()
            .axis(.horizontal)
            .distribution(.fill)
            .alignment(.center)
            .spacing(5)
    }

}