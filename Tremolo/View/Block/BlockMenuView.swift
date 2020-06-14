//
//  BlockMenuView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/06/13.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

struct BlockMenuAction {

    let image: UIImage?

    let action: () -> ()

    init(image: UIImage?, action: @escaping () -> ()) {
        self.image = image
        self.action = action
    }

}

class BlockMenuView: UIStackView {

    init(actions: [BlockMenuAction]) {
        super.init(frame: .zero)

        axis = .horizontal
        spacing = 10

        for action in actions {
            addArrangedSubview(BlockMenuButtonView(image: action.image, action.action))
        }

        translatesAutoresizingMaskIntoConstraints = false
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

private class BlockMenuButtonView: UIButton {

    private let action: () -> ()

    private let size = CGSize(width: 50, height: 50)

    init(image: UIImage?, _ action: @escaping () -> ()) {
        self.action = action

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        equalToSize(width: size.width, height: size.height)

        setImage(image, for: .normal)
        backgroundColor = .white
        layer.cornerRadius = min(size.width, size.height) / 2

        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        action()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        action()
    }

}
