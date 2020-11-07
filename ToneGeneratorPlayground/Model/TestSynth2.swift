//
//  TestSynth2.swift
//  ToneGeneratorPlayground
//
//  Created by mightknow on 11/6/20.
//

import Foundation
import AVFoundation


class TestSynth2 {
    
    typealias Signal = (Float) -> (Float)
    
    public var volume : Float {
        set {
            self.audioEngine.mainMixerNode.outputVolume = newValue
        }
        get {
            return audioEngine.mainMixerNode.outputVolume
        }
    }
    func start() {
        do {
            try self.audioEngine.start()
        } catch {
            print("Could not start engine: \(error.localizedDescription)")
        }
    }
    func stop() {
        self.audioEngine.stop()
        self.time = 0
        
    }
    private var audioEngine : AVAudioEngine
    private var time : Float = 0
    private let sampleRate : Double
    private let deltaTime : Float
    private var signal : Signal
    private lazy var sourceNode = AVAudioSourceNode {(_,_, frameCount, audioBufferList) -> OSStatus in
        var ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        for frame in 0..<Int(frameCount) {
            var sampleVal = self.signal(self.time)
//            if self === TestSynthesizer.movableTone {
//                let wavelengthTime = Float(1/TestOscillator.variableFrequency)
//
//
//                // GETS RID OF POPS AND CLICKS:
//                if TestOscillator.frequencyDidChange {
////                    if PrintList.frequencyOfTestSynthesizerChanged {
////                        print("Frequency changed.")
////                    }
//                    let previousWavelengthTime = Float(1/TestOscillator.previousFrequency)
//                    let adjustment = wavelengthTime/previousWavelengthTime
//                    self.time = self.time*adjustment
//                    sampleVal = self.signal(self.time)
//                    TestOscillator.frequencyDidChange = false
//                }
//                if self.time >= wavelengthTime {
//                    let offset = self.time - wavelengthTime
//                    self.time = 0 + offset
//                }
//            }
            
            
            // MARK : function to test reset. hard code after testing
            func resetAt(numberOfSeconds: Int, samplesToRampDown: Int) {
                
                let time = Float(Double(numberOfSeconds)*self.sampleRate)
                let barrier = time - (Float(samplesToRampDown)*self.deltaTime)
                // RAMP DOWN SO NO POPS/CLICKS
                if self.time > barrier {
                    let range = time - barrier
                    let point = time - self.time
                    let percentage = point/range
                    if point < 0 {
                        sampleVal = 0
                    } else {
                        sampleVal *= percentage*percentage
                    }
                    
                }
                let lowerMargin : Float = Float(numberOfSeconds) - self.deltaTime
                let upperMargin : Float = Float(numberOfSeconds) + self.deltaTime
                if self.time > lowerMargin && self.time < upperMargin {
                    self.time = 0
                    print("self.time was reset!")
                }
                
            }
            //resetAt(numberOfSeconds: 2, samplesToRampDown: 1000)
            for buffer in ablPointer {
                let buf : UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = sampleVal
//                if frame > 0 {
//                    let previous = buf[frame - 1]
//                    let current = buf[frame]
//                    let diff = previous - current
//                    if abs(diff) > 0.05 {
//                        print("There was a big jump in the waveform...")
//                    }
//                }
            }
            if sampleVal < 0.0001 && sampleVal > -0.0001 && self.time > self.deltaTime*100 {
                            print("Sample is close to zero!")
                            self.time = 0
                            for buffer in ablPointer {
                                let buf : UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
            //                    buf[frame] = sampleVal
                                if frame > 3 {
                                    let previous3 = buf[frame - 3]
                                    let previous2 = buf[frame - 2]
                                    let previous1 = buf[frame - 1]
                                    let current = buf[frame]
                                    print("")
                                    print(previous3)
                                    print(previous2)
                                    print(previous1)
                                    print(current)
                                }
                            }
                        } else {
                            self.time += self.deltaTime
                        }
            
//            for buffer in ablPointer {
//                print(buffer.)
//            }
            
        }
        return noErr
    }
    
    
    // MARK: Public Functions
    public func setWaveformTo(_ signal: @escaping Signal) {
        self.signal = signal
    }
    
    // MARK: Init
    init(signal: @escaping Signal) {
        
        self.audioEngine = AVAudioEngine()
        let mainMixer = self.audioEngine.mainMixerNode
        let outputNode = self.audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)
        self.sampleRate = format.sampleRate
        self.deltaTime = 1/Float(sampleRate)
        self.signal = signal
        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: self.sampleRate, channels: 1, interleaved: format.isInterleaved)
        self.audioEngine.attach(self.sourceNode)
        audioEngine.connect(self.sourceNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: outputNode, format: nil)
        mainMixer.outputVolume = 1
//        do {
//            try self.audioEngine.start()
//        } catch {
//            print("Could not start engine: \(error.localizedDescription)")
//        }
    }
    
}


