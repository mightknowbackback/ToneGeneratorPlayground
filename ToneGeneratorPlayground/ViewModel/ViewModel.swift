//
//  ViewModel.swift
//  ToneGeneratorPlayground
//
//  Created by mightknow on 11/6/20.
//

import Foundation
import SwiftUI

class ViewModel : ObservableObject {
    @Published var audioModel = AudioModel()
    
    var frequencyBinding : Binding<Double> {
        Binding(
            get: {Double(self.audioModel.frequency)},
            set: {d in
                self.audioModel.frequency = Float(d)
            }
        )
    }
}
