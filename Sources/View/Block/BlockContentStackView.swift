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

    func setContent(_ view: UIView, at path: BlockStackPath) {
        let stackView = getStackView(at: path.row)

        if path.col == stackView.arrangedSubviews.count {
            stackView.addArrangedSubview(view)
            return
        }

        while path.col >= stackView.arrangedSubviews.count {
            stackView.addArrangedSubview(UIView())
        }

        stackView.arrangedSubviews[path.col].removeFromSuperview()
        stackView.insertArrangedSubview(view, at: path.col)
    }

    func content(at path: BlockStackPath) -> UIView {
        let stackView = getStackView(at: path.row)
        return stackView.arrangedSubviews[path.col]
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