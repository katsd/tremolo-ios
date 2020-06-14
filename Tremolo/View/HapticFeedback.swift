//
//  HapticFeedback.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/06/13.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class HapticFeedback {

    private static let impactFeedbackGeneratorLight: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()

    private static let impactFeedbackGeneratorMedium: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        return generator
    }()

    private static let impactFeedbackGeneratorHeavy: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        return generator
    }()

    private static let impactFeedbackGeneratorRigid: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        return generator
    }()

    private static let impactFeedbackGeneratorSoft: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        return generator
    }()

    private static let selectionFeedbackGenerator: UISelectionFeedbackGenerator = {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        return generator
    }()

    private static func selectionFeedback() {
        HapticFeedback.selectionFeedbackGenerator.selectionChanged()
    }

    private static func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        switch style {
        case .light:
            impactFeedbackGeneratorLight.impactOccurred()

        case .medium:
            impactFeedbackGeneratorMedium.impactOccurred()

        case .heavy:
            impactFeedbackGeneratorHeavy.impactOccurred()

        case .rigid:
            impactFeedbackGeneratorRigid.impactOccurred()

        case .soft:
            impactFeedbackGeneratorSoft.impactOccurred()

        default:
            return
        }
    }

    static func blockFloatFeedback() {
        impactFeedback(style: .medium)
    }

    static func blockPosChangedFeedback() {
        selectionFeedback()
    }

    static func blockDropFeedback() {
        impactFeedback(style: .medium)
    }

    static func showMenuFeedback() {
        impactFeedback(style: .rigid)
    }

}
