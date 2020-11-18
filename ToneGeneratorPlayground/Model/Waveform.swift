//
//  Waveform.swift
//  EarQuiz
//
//  Created by mightknow on 11/17/20.
//

import Foundation

enum Waveform : String {
    
    typealias Signal = (Double) -> Float
    
    case sine = "Sine"
    case triangle = "Triangle"
    case organ1 = "Organ 1"
    case organ2 = "Organ 2"
    case sawtooth = "Saw"
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
                    let f = Float(i)
                    val += (sin(f*Float(percentage)))/f
                    i += 1
                }
                return val/1.85
            }
        case .organ2:
            return { (phase: Double) -> Float in
                var val : Float = 0
                var i = 1
                while i < 12 {
                    let f = Float(i)
                    val += (sin(f*Float(phase)))/f
                    i += 1
                }
                return val/1.85
            }
        case .sawtooth:
            return { (percentage: Double) -> Float in
                return 1.0 - 2.0 * (Float(percentage) * (1.0 / twoPi))
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
