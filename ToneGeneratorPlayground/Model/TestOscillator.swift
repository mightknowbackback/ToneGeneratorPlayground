//
//  TestOscillator.swift
//  TunEar
//
//  Created by mightknow on 2/21/20.
//  Copyright © 2020 Euphorophonics. All rights reserved.
//

import Foundation



struct TestOscillator {
    typealias Signal = (Float) -> (Float)
	static var amplitude : Float = 1
	static var fixedFrequency : Float = 440
	static var variableFrequency : Float = 880 {
		didSet {
			TestOscillator.frequencyDidChange = true
			TestOscillator.previousFrequency = oldValue
		}
	}
	static var frequencyDidChange : Bool = false
	static var previousFrequency : Float = 440
	static let fixedSine : Signal = { (time: Float) -> Float in
		return TestOscillator.amplitude * sin(2.0 * Float.pi * TestOscillator.fixedFrequency * time)
		
	}
	static let variableSine : Signal = { (time: Float) -> Float in
		return TestOscillator.amplitude * sin(2.0 * Float.pi * TestOscillator.variableFrequency * time)
		
	}
	static let triangle : Signal = { (time: Float) -> Float in
		let periodLocation = TestOscillator.getPeriodCompletionValue(time)
		var result : Float = 0.0
		switch true {
		case periodLocation < 0.25:
			result = periodLocation * 4
		case periodLocation < 0.75:
			result = 2.0 - (periodLocation * 4)
		default:
			result = periodLocation * 4 - 4
		}
		return TestOscillator.amplitude * result
	}
	static let sawTooth : Signal = { (time: Float) -> Float in
		let periodLocation = TestOscillator.getPeriodCompletionValue(time)
		return TestOscillator.amplitude * (periodLocation * 2 - 1)
	}
	static let square : Signal = { (time: Float) -> Float in
		let periodLocation = TestOscillator.getPeriodCompletionValue(time)
		return periodLocation < 0.5 ? TestOscillator.amplitude : -TestOscillator.amplitude
	}
	static func getPeriodCompletionValue(_ time: Float) -> Float {
		
		let period = 1.0 / TestOscillator.fixedFrequency
		let currentTime = Float(fmod(Double(time), Double(period)))
		return currentTime/period
	}
}
