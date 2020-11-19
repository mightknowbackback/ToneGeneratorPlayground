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
        if !self.audioEngine.isRunning {// Do nothing if already running.
            do {
                try self.audioEngine.start()
                self.attack()
            } catch {
                print("Could not start engine: \(error.localizedDescription)")
            }
        }
    }
    public func stop() {
        if self.audioEngine.isRunning {// Do nothing if already stopped
            self.release()
        }
    }
    
    // FOR ATTACK AND RELEASE (Eliminate pops & clicks)
    enum EnvelopeStage : CaseIterable {
        case attack, release
    }
    var envelopeTimer : Timer = Timer()
    let attackTime : Double = 0.02
    let releaseTime : Double = 0.05
    let timerIncrement : Double = 0.002
    var stopDelayCount : Double = 0
    var stopDelayTime : Double = 0.05
    private func startTimer(forEnvelopeStage stage: EnvelopeStage) {
        let index = EnvelopeStage.allCases.firstIndex(of: stage)!
        self.envelopeTimer = Timer.scheduledTimer(timeInterval: self.timerIncrement, target: self, selector: #selector(self.processEnvelopeTimer), userInfo: index, repeats: true)
        
    }
    private func resetEnvelope() {
        self.stopDelayCount = 0
    }
    private func release() {
        self.resetEnvelope()
        self.startTimer(forEnvelopeStage: .release)
    }
    private func attack() {
        self.resetEnvelope()
        self.startTimer(forEnvelopeStage: .attack)
    }
    @objc private func processEnvelopeTimer(_ timer: Timer) {
        let stage = EnvelopeStage.allCases[timer.userInfo as! Int]
        let length : Double = {
            switch stage {
            case .attack:
                return self.attackTime
            case .release:
                return self.releaseTime
            }
        }()
        let volumeIncrement = Float(1*self.timerIncrement/length)
        switch stage {
        case .attack:
            if self.volume > 0.095 {
                if self.volume != 1 {
                    self.volume = 1
                    self.envelopeTimer.invalidate()
                }
            } else {
                self.volume += volumeIncrement
            }
        case .release:
            if self.volume < 0.01 {
                if self.volume != 0 {
                    self.volume = 0
                }
                self.stopDelayCount += timerIncrement
            } else {
                self.volume -= volumeIncrement
            }
            if stopDelayCount >= self.stopDelayTime {
                self.audioEngine.stop()
                self.envelopeTimer.invalidate()
                self.waveformLocation = 0
            }
        }
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
        self.audioEngine.connect(self.sourceNode, to: mainMixer, format: inputFormat)
        self.audioEngine.connect(mainMixer, to: outputNode, format: nil)
        self.volume = 0
    }
    
}


