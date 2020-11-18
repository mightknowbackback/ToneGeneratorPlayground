//
//  Waveform.swift
//  EarQuiz
//
//  Created by mightknow on 11/17/20.
//

import Foundation

enum Waveform : String, CaseIterable {
    
    typealias Signal = (Double) -> Float
    
    case sine = "Sine"
    case triangle = "Triangle"
    case organ1 = "Organ 1"
    case organ2 = "Organ 2"
    case sawUp = "Saw Up"
    case sawDown = "Saw Down"
    case square = "Square"
    
    var signal : Signal {
        // Takes percentage parameter as indication of waveform cycle completion. Value from 0 to 1.
        let twoPi = Float.pi * 2
        switch self {
        case .sine:
            return { (percentage: Double) -> Float in
                let val = twoPi * Float(percentage)
                return sin(val)
            }
        case .triangle:
            return { (percentage: Double) -> Float in
                var positiveWave : Float {
                    if percentage <= 0.5 {
                        return Float(percentage*4)
                    } else {
                        let modifier = percentage - 0.5
                        return Float(2 - modifier*4)
                    }
                }
                
            // Get time value to compensate for start offset
            let timeOffset = 0.25
            var timePercentageValue = percentage + timeOffset
            if timePercentageValue >= 1 {
                timePercentageValue -= 1
            }
            // Get positive wave value and convert to -1 to 1 value range
            return positiveWave - 1
            }
        case .organ1:
            return { (percentage: Double) -> Float in
                var val : Float = 0
                var i = 1
                while i < 5 {
                    let d = Double(i)
                    let position = percentage * d
                    val += Waveform.sine.signal(position)/Float(d)
                    i += 1
                }
                return val/1.85
            }
        case .organ2:
            return { (percentage: Double) -> Float in
                var val : Float = 0
                var i = 1
                while i < 12 {
                    let d = Double(i)
                    let position = percentage * d
                    val += Waveform.sine.signal(position)/Float(d)
                    i += 1
                }
                return val/1.85
            }
        case .sawUp:
            return { (percentage: Double) -> Float in
                var val = Float(percentage)
                val += 0.5
                if val > 1 {
                    val -= 1
                }
                let positiveOnly = 2*val
                return positiveOnly - 1
            }
        case .sawDown:
            return { (percentage: Double) -> Float in
                return -(Waveform.sawUp.signal(percentage))
            }
        case .square:
            return { (percentage: Double) -> Float in
                if Float(percentage) <= 0.5 {
                    return 1.0
                } else {
                    return -1.0
                }
            }
        }
    }
}
