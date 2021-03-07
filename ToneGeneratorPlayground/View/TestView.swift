//
//  TestView.swift
//  ToneGeneratorPlayground
//
//  Created by mightknow on 11/6/20.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var viewModel : ViewModel
    var body: some View {
        VStack {
            // Waveform Picker Label
            Text("Waveform:")
                .multilineTextAlignment(.center)
                .padding()
            // Waveform Picker
            Picker("", selection: self.viewModel.waveformBinding) {
                ForEach(0..<self.viewModel.waveformStrings.count) {i in
                    Text(self.viewModel.waveformStrings[i])
                }
            }
            // Frequency Label
            Text(self.viewModel.frequencyLabelString)
                .multilineTextAlignment(.center)
                .padding()
            // Frequency Slider
            Slider(value: self.$viewModel.audioModel.synth.frequency, in: 220.0...880.0).padding()
            // Start/Stop Buttons
            HStack {
                Button(action: {
                    self.viewModel.audioModel.synth.start()
                }) {
                    Text("Start")
                }
                Button(action: {
                    self.viewModel.audioModel.synth.stop()
                }) {
                    Text("Stop")
                }
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView().environmentObject(ViewModel())
    }
}
