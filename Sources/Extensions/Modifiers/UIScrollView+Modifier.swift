//
//  UIScrollView+Modifier.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/30.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

extension UIScrollView {

    func isScrollEnabled(_ flag: Bool) -> UIScrollView {
        self.isScrollEnabled = flag
        return self
    }

    func isDirectionalLockEnabled(_ flag: Bool) -> UIScrollView {
        self.isDirectionalLockEnabled = flag
        return self
    }

    func isPagingEnabled(_ flag: Bool) -> UIScrollView {
        self.isPagingEnabled = flag
        return self
    }

    func scrollsToTop(_ flag: Bool) -> UIScrollView {
        self.scrollsToTop = flag
        return self
    }

    func bounces(_ flag: Bool) -> UIScrollView {
        self.bounces = flag
        return self
    }

    func alwaysBounceVertical(_ flag: Bool) -> UIScrollView {
        self.alwaysBounceVertical = flag
        return self
    }

    func alwaysBounceHorizontal(_ flag: Bool) -> UIScrollView {
        self.alwaysBounceHorizontal = flag
        return self
    }

}
