//
//  TestView.swift
//  ToneGeneratorPlayground
//
//  Created by mightknow on 11/6/20.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var viewModel : ViewModel
    @State private var frequency : Double = 440
    var body: some View {
        VStack {
            Text(String(format: "Frequency:\n%.1f", self.frequency))
                .multilineTextAlignment(.center)
                .padding()
            Slider(value: self.$frequency, in: 40.0...10000.0).padding()
            HStack {
                Button(action: {
                    self.viewModel.audioModel.generator.start()
                }) {
                    Text("Start")
                }
                Button(action: {
                    self.viewModel.audioModel.generator.stop()
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
