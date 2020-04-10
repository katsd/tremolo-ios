//
//  UIView+GestureClosure.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/30.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class TapGestureRecognizer: UITapGestureRecognizer {

    private let action: (_ gesture: UITapGestureRecognizer) -> ()

    init(action: @escaping (_ gesture: UITapGestureRecognizer) -> ()) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(invoke(_:)))
    }

    @objc private func invoke(_ gesture: Any) {
        guard let gesture = gesture as? UITapGestureRecognizer else {
            return
        }
        action(gesture)
    }

}

class DragGestureRecognizer: UIPanGestureRecognizer {

    private let action: (_ gesture: UIPanGestureRecognizer) -> ()

    init(action: @escaping (_ gesture: UIPanGestureRecognizer) -> ()) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(invoke(_:)))
    }

    @objc private func invoke(_ gesture: Any) {
        guard let gesture = gesture as? UIPanGestureRecognizer else {
            return
        }
        action(gesture)
    }

}


extension UIView {

    func tap(_ action: @escaping (_ gesture: UITapGestureRecognizer) -> ()) {
        let recognizer = TapGestureRecognizer(action: action)
        self.addGestureRecognizer(recognizer)

        checkIsUserInteractionEnabled()
    }

    func drag(_ action: @escaping (_ gesture: UIPanGestureRecognizer) -> ()) {
        let recognizer = DragGestureRecognizer(action: action)
        self.addGestureRecognizer(recognizer)

        checkIsUserInteractionEnabled()
    }

    private func checkIsUserInteractionEnabled() {
        if !isUserInteractionEnabled {
            print("\u{001B}[0;33mWarning: isUserInteractionEnabled is false (\(type(of: self)))")
        }
    }

}
