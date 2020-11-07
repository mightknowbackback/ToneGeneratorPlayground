//
//  AudioModel.swift
//  ToneGeneratorPlayground
//
//  Created by mightknow on 11/6/20.
//

import Foundation

struct AudioModel {
    typealias Signal = (Float) -> (Float)
    var generator : TestSynth2
    

    var frequency : Float = 880
    init() {
        self.generator = TestSynth2(signal: TestOscillator.variableSine)
    }
}
