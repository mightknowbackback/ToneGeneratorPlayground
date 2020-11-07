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
            Text(self.viewModel.frequencyLabelString)
                .multilineTextAlignment(.center)
                .padding()
            Slider(value: self.$viewModel.audioModel.synth.frequency, in: 220.0...880.0).padding()
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
        TestView()
    }
}
