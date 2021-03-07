//
//  ViewModel.swift
//  ToneGeneratorPlayground
//
//  Created by mightknow on 11/6/20.
//

import Foundation
import SwiftUI

class ViewModel : ObservableObject {
    // Strings for Waveform Picker
    var waveformStrings : [String] {
        var result : [String] = []
        for w in Waveform.allCases {
            result.append(w.rawValue)
        }
        return result
    }
    // Binding for setting waveform from picker
    var waveformBinding : Binding<Int> {
        Binding<Int>(
            get: {
                return Waveform.allCases.firstIndex(of: self.audioModel.synth.waveform)!
            },
            set: {i in
                self.audioModel.synth.waveform = Waveform.allCases[i]
            }
        )
    }
    // Readable string for waveform frequency, rounded to one decimal.
    var frequencyLabelString : String {
        return String(format: "Frequency:\n%.1f", self.audioModel.synth.frequency)
    }
    // Model
    @Published var audioModel = AudioModel()
}
