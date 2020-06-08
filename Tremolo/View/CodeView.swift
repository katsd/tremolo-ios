//
//  CodeView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/29.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class CodeView: UIView {

    static var __codeView: CodeView? = nil

    private let tremolo: Tremolo

    private var selectedBlockPos: BlockPos? = nil

    private var blockStackView = UIStackView()

    private let topView: UIView

    init(tremolo: Tremolo, topView: UIView) {
        self.tremolo = tremolo

        self.topView = topView

        super.init(frame: .zero)

        let scrollView = UIScrollView()
        scrollView
            .alwaysBounceVertical(true)
            .clipsToBounds(false)
        self.addSubview(scrollView)
        scrollView.equalToEach(self, top: 0, left: 20, bottom: 0, right: 0, priority: 900)
        scrollView.lessThanOrEqualToEach(self, left: 20, priority: 1000)
        scrollView.delegate = self

        blockStackView =
            BlockStackView(blocks:
                           tremolo.blocks.map {
                               BlockView(tremolo: tremolo, block: $0.parent(self), blockController: self)
                           },
                           blockController: self)

        scrollView.addSubview(blockStackView)
        blockStackView.equalTo(scrollView, inset: .init(top: 10, left: 0, bottom: 0, right: 0))

        setGesture()

        CodeView.__codeView = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func updateLayout() {
        self.layoutIfNeeded()
    }

    static private func blockAnimation(animation: @escaping () -> Void, completion: @escaping () -> Void = {}) {
        UIView.animate(withDuration: 0.2, animations: animation, completion: { _ in completion() })
    }

    private func setGesture() {
        tap { _ in
            Keyboard.closeKeyboard()
        }
    }

}

extension CodeView: BlockController {

    func floatBlock(blockView: BlockView, gesture: UIPanGestureRecognizer) {
        if let blockStackViewController = blockView.block.parent {
            selectedBlockPos = blockStackViewController.findBlockPos(blockView: blockView, velocity: .zero, selectedBlockPos: selectedBlockPos)
        } else {
            selectedBlockPos = findBlockPos(blockView: blockView, velocity: .zero, selectedBlockPos: selectedBlockPos)
        }

        blockView.translatesAutoresizingMaskIntoConstraints = true

        self.topView.addSubViewKeepingGlobalFrame(blockView)

        if let pos = selectedBlockPos {
            pos.blockStackViewController.addBlankView(blockView: blockView, path: pos.path, at: pos.idx) {
                self.updateLayout()
            }

            pos.blockStackViewController.floatBlockView(blockView, path: pos.path, at: pos.idx)
        }
    }

    func dragBlock(blockView: BlockView, gesture: UIPanGestureRecognizer, drop: Bool = false) {
        blockView.frame.origin.x += gesture.translation(in: nil).x
        blockView.frame.origin.y += gesture.translation(in: nil).y
        gesture.setTranslation(.zero, in: nil)

        if !drop && abs(gesture.velocity(in: nil).y) > 800 {
            return;
        }

        let newSelectedBlockPos = findBlockPos(blockView: blockView, velocity: gesture.velocity(in: nil), selectedBlockPos: selectedBlockPos)

        if selectedBlockPos != newSelectedBlockPos {
            if let pos = selectedBlockPos {
                pos.blockStackViewController.removeBlankView(path: pos.path, at: pos.idx) {
                    // if newSelectedBlockPos isn't nil, self.blockAnimation()(= self.layoutIfNeeded()) will be called below.
                    if newSelectedBlockPos == nil {
                        self.updateLayout()
                    }
                }
            }

            if let pos = newSelectedBlockPos {
                pos.blockStackViewController.addBlankView(blockView: blockView, path: pos.path, at: pos.idx) {
                    self.updateLayout()
                }
            }
        }

        selectedBlockPos = newSelectedBlockPos

        if drop {
            dropBlock(blockView: blockView, gesture: gesture)
        }
    }

    func dropBlock(blockView: BlockView, gesture: UIPanGestureRecognizer) {

        selectedBlockPos = findBlockPos(blockView: blockView, velocity: gesture.velocity(in: nil), selectedBlockPos: selectedBlockPos)

        if let pos = selectedBlockPos {
            pos.blockStackViewController.addBlockView(blockView, path: pos.path, at: pos.idx) {
                self.updateLayout()
            }
        } else {
            blockView.removeFromSuperview()
        }

        blockView.block.parent = selectedBlockPos?.blockStackViewController

        selectedBlockPos = nil
    }

}

extension CodeView: BlockStackViewController {

    func addBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        tremolo.blockStack.insertBlock(blockView.block, at: idx)
        CodeView.addBlockView(stackView: blockStackView, blockView: blockView, at: idx, updateLayout: updateLayout)
    }

    func floatBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int) {
        tremolo.blockStack.removeBlock(at: idx)
    }

    func addBlankView(blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        CodeView.addBlankView(stackView: blockStackView, blockView: blockView, at: idx, updateLayout: updateLayout)
    }

    func removeBlankView(path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void) {
        CodeView.removeBlankView(stackView: blockStackView, at: idx, updateLayout: updateLayout)
    }

    func findBlockPos(blockView: BlockView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos? {

        if blockStackView.arrangedSubviews.count < 1 {
            return nil
        }

        let blockFrame = blockView.globalFrame

        let blockY: CGFloat

        if velocity.y > 0 {
            blockY = blockFrame.maxY
        } else if velocity.y < 0 {
            blockY = blockFrame.minY
        } else {
            blockY = blockFrame.midY
        }

        // Search block surrounding blockView
        let searchBlock: () -> (result: Bool, pos: BlockPos?) = {
            var l = -1
            var r = self.blockStackView.arrangedSubviews.count

            while r - l > 1 {
                let mid = (r + l) / 2

                if self.blockStackView.arrangedSubviews[mid].globalFrame.minY <= blockY {
                    l = mid
                } else {
                    r = mid
                }
            }

            if l == -1 {
                return (result: false, pos: nil)
            }

            if l == self.blockStackView.arrangedSubviews.count - 1 {
                if self.blockStackView.globalFrame.maxY <= blockY {
                    return (result: false, pos: nil)
                }
            }

            guard let surroundingBlockView = self.blockStackView.arrangedSubviews[l] as? BlockView else {
                return (result: false, pos: nil)
            }

            if surroundingBlockView == blockView {
                return (result: false, pos: nil)
            }

            return (result: true, pos: surroundingBlockView.findBlockPos(blockView: blockView, velocity: velocity, selectedBlockPos: selectedBlockPos))
        }

        // Search index where blockView should be
        let searchIdx: () -> BlockPos = {
            let hasBlankView = selectedBlockPos?.blockStackViewController === self

            var l = -1
            var r = self.blockStackView.arrangedSubviews.count

            while r - l > 1 {
                let mid = (r + l) / 2

                if self.blockStackView.arrangedSubviews[mid].globalFrame.midY < blockY {
                    l = mid
                } else {
                    r = mid
                }
            }

            if hasBlankView {
                if let pos = selectedBlockPos?.idx {
                    if pos < r {
                        r -= 1
                    }
                }
            }

            return BlockPos(blockStackViewController: self, path: .zero, idx: r)
        }

        let res = searchBlock()
        if res.pos != nil {
            return res.pos
        }

        return searchIdx()
    }

}

extension CodeView {

    static func addBlockView(stackView: UIStackView, blockView: UIView, at idx: Int, updateLayout: @escaping () -> Void) {
        if idx < stackView.arrangedSubviews.count &&
               !(stackView.arrangedSubviews[idx] is BlockView) {
            stackView.arrangedSubviews[idx].removeFromSuperview()
        }

        let blankView = UIView()
        stackView.insertArrangedSubview(blankView, at: idx)
        blankView.equalToSizeOf(blockView)

        stackView.layoutIfNeeded()

        blockAnimation(animation: {
            blockView.center = blockView.convertFrame(parent: blockView.superview).center
        }, completion: {
            stackView.arrangedSubviews[idx].removeFromSuperview()
            stackView.insertArrangedSubview(blockView, at: idx)
        })

        UIView.animate(withDuration: 0.2, animations: {
            blockView.center = blankView.convertFrame(parent: blockView.superview).center
        }, completion: { _ in
            stackView.arrangedSubviews[idx].removeFromSuperview()
            stackView.insertArrangedSubview(blockView, at: idx)
        })
    }

    // add blockView without removing blank view
    static func insertBlockView(stackView: UIStackView, blockView: UIView, at idx: Int, updateLayout: @escaping () -> Void) {
        let measureView = UIView()
        stackView.insertArrangedSubview(measureView, at: idx)
        measureView.equalToSizeOf(blockView)
        updateLayout()

        let center = measureView.convertFrame(parent: blockView.superview).center
        measureView.removeFromSuperview()
        updateLayout()

        let blankView = UIView()
        stackView.insertArrangedSubview(blankView, at: idx)
        blankView.equalToSizeOf(blockView)

        blockAnimation(animation: {
            blockView.center = center
            updateLayout()
        }, completion: {
            blankView.removeFromSuperview()
            stackView.insertArrangedSubview(blockView, at: idx)
        })
    }

    static func addBlankView(stackView: UIStackView, blockView: UIView, at idx: Int, updateLayout: @escaping () -> Void) {
        let blankView = UIView()
        stackView.insertArrangedSubview(blankView, at: idx)
        blankView.equalToSizeOf(blockView)

        blockAnimation(animation: {
            updateLayout()
        })
    }

    static func removeBlankView(stackView: UIStackView, at idx: Int, updateLayout: @escaping () -> Void) {
        stackView.arrangedSubviews[idx].removeFromSuperview()

        blockAnimation(animation: {
            updateLayout()
        })
    }

}


struct CodeViewRepresentable: UIViewRepresentable {

    private let codeView: CodeView

    init(_ codeView: CodeView) {
        self.codeView = codeView
    }

    func makeUIView(context: Context) -> CodeView {
        codeView
    }

    func updateUIView(_ uiView: CodeView, context: Context) {

    }

}
