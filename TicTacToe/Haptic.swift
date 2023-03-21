//
//  Haptic.swift
//  TicTacToe
//
//  Created by Evgeny Koshkin on 21.03.2023.
//

import Foundation
import UIKit

func lightHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}

func mediumHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}

func heavyHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
}
