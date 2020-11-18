//
//  SimpleSynth.swift
//  ToneGeneratorPlayground
//
//  Created by mightknow on 11/6/20.
//

import Foundation
import AVFoundation
import SwiftUI

class SimpleSynth {
    
    private var audioEngine : AVAudioEngine
    
    // MARK: Interface
    public var volume : Float {
        set {
            self.audioEngine.mainMixerNode.outputVolume = newValue
        }
        get {
            return audioEngine.mainMixerNode.outputVolume
        }
    }
    public func start() {
        do {
            try self.audioEngine.start()
        } catch {
            print("Could not start engine: \(error.localizedDescription)")
        }
    }
    public func stop() {
        self.audioEngine.stop()
        // TODO: Will need to be changed when start/stop pops/clicks fixed.
        self.waveformLocation = 0
    }
    
    // MARK: Signal Generation
    var frequency : Float = 440
    private let sampleRate : Double
    var waveform : Waveform
    private var waveformLocation : Double = 0 { // Current location along waveform
        // Stays between 0 and 1
        didSet {
            if self.waveformLocation >= 1 {
                self.waveformLocation -= 1
            }
        }
    }
    private var waveformTimeDelta : Double { // Value of increment for moving through waveform one sample at a time.
        1/(self.sampleRate/Double(self.frequency)*2)
    }

    private lazy var sourceNode = AVAudioSourceNode {(_,_, frameCount, audioBufferList) -> OSStatus in
        var ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        for frame in 0..<Int(frameCount) {
            for buffer in ablPointer {
                let buf : UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                self.waveformLocation += self.waveformTimeDelta
                var f = self.waveform.signal
                buf[frame] = f(self.waveformLocation)
                //print(buf[frame])
            }
        }
        return noErr
    }
    // MARK: Initialization
    init(waveform: Waveform) {
        
        self.audioEngine = AVAudioEngine()
        self.waveform = waveform
        let mainMixer = self.audioEngine.mainMixerNode
        let outputNode = self.audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)
        self.sampleRate = format.sampleRate
        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: self.sampleRate, channels: 1, interleaved: format.isInterleaved)
        self.audioEngine.attach(self.sourceNode)
        audioEngine.connect(self.sourceNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: outputNode, format: nil)
        mainMixer.outputVolume = 1
    }
    
}


