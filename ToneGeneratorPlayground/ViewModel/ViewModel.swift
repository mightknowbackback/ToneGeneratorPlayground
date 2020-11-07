//
//  ViewModel.swift
//  ToneGeneratorPlayground
//
//  Created by mightknow on 11/6/20.
//

import Foundation
import SwiftUI

class ViewModel : ObservableObject {
    var frequencyLabelString : String {
        return String(format: "Frequency:\n%.1f", self.audioModel.synth.frequency)
    }
    @Published var audioModel = AudioModel()
}
