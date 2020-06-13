//
//  BlockMenuView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/06/13.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class BlockMenuView: UIStackView {

    init() {
        super.init(frame: .zero)

        let duplicate = BlockMenuButtonView(image: UIImage(systemName: "plus.square.on.square")) {
            print("duplicate")
        }

        let delete = BlockMenuButtonView(image: UIImage(systemName: "trash")) {
            print("delete")
        }

        axis = .horizontal
        spacing = 10

        addArrangedSubview(duplicate)
        addArrangedSubview(delete)

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
