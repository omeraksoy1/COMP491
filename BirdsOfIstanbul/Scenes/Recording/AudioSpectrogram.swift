//
//  AudioSpectrogram.swift
//  BirdsOfIstanbul
//
//  Created by Andrew Bond on 3/27/22.
//

import AVFoundation
import Accelerate

public class AudioSpectrogram: CALayer {
    override init() {
        super.init()
        
        contentsGravity = .resize
        
        configureCaptureSession()
        audioOutput.setSampleBufferDelegate(self, queue: captureQueue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init(layer: Any) {
        super.init(layer: layer)
    }
    
    static let sampleCount = 1024 / 2
    static let bufferCount = 768 / 2
    static let hopCount = 512
    
    let captureSession = AVCaptureSession()
    let audioOutput = AVCaptureAudioDataOutput()
    let captureQueue = DispatchQueue(label: "captureQueue",
                                     qos: .userInitiated,
                                     attributes: [],
                                     autoreleaseFrequency: .workItem)
    let sessionQueue = DispatchQueue(label: "sessionQueue",
                                     attributes: [],
                                     autoreleaseFrequency: .workItem)
    let forwardDCT = vDSP.DCT(count: sampleCount, transformType: .II)!
    
    let hanningWindow = vDSP.window(ofType: Float.self, usingSequence: .hanningDenormalized, count: sampleCount, isHalfWindow: false)
    
    let dispatchSemaphore = DispatchSemaphore(value: 1)
    
    var nyquistFrequency: Float?
    
    var rawAudioData = [Int16]()
    
    var frequencyDomainValues = [Float](repeating: 0, count: bufferCount * sampleCount)
    
    var rgbImageFormat: vImage_CGImageFormat = {
        guard let format = vImage_CGImageFormat(
            bitsPerComponent: 8,
            bitsPerPixel: 8 * 4,
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
            renderingIntent: .defaultIntent) else {
                fatalError("Can't create image format.")
            }
        
        return format
    }()
    
    lazy var rgbImageBuffer: vImage_Buffer = {
        guard let buffer = try? vImage_Buffer(width: AudioSpectrogram.sampleCount,
                                              height: AudioSpectrogram.bufferCount,
                                              bitsPerPixel: rgbImageFormat.bitsPerPixel) else {
            fatalError("Unable to initialize image buffer.")
        }
        return buffer
    }()
    
    lazy var rotatedImageBuffer: vImage_Buffer = {
        guard let buffer = try? vImage_Buffer(width: AudioSpectrogram.bufferCount,
                                              height: AudioSpectrogram.sampleCount,
                                              bitsPerPixel: rgbImageFormat.bitsPerPixel)  else {
            fatalError("Unable to initialize rotated image buffer.")
        }
        return buffer
    }()
    
    
    deinit {
        rgbImageBuffer.free()
        rotatedImageBuffer.free()
    }
    
    static var redTable: [Pixel_8] = (0 ... 255).map {
        return brgValue(from: $0).red
    }
    
    static var greenTable: [Pixel_8] = (0 ... 255).map {
        return brgValue(from: $0).green
    }
    
    static var blueTable: [Pixel_8] = (0 ... 255).map {
        return brgValue(from: $0).blue
    }
    
    var timeDomainBuffer = [Float](repeating: 0, count: sampleCount)
    var frequencyDomainBuffer = [Float](repeating: 0, count: sampleCount)
    
    //var totalAudioBuffer = [Float]()
    
    func processData(values: [Int16]) {
        dispatchSemaphore.wait()
        vDSP.convertElements(of: values, to: &timeDomainBuffer)
        
        vDSP.multiply(timeDomainBuffer, hanningWindow, result: &timeDomainBuffer)
        
        forwardDCT.transform(timeDomainBuffer, result: &frequencyDomainBuffer)
        
        vDSP.absolute(frequencyDomainBuffer, result: &frequencyDomainBuffer)
        
        vDSP.convert(amplitude: frequencyDomainBuffer, toDecibels: &frequencyDomainBuffer, zeroReference: Float(AudioSpectrogram.sampleCount))
        
        if frequencyDomainValues.count > AudioSpectrogram.sampleCount {
            frequencyDomainValues.removeFirst(AudioSpectrogram.sampleCount)
        }
        
        frequencyDomainValues.append(contentsOf: frequencyDomainBuffer)
        
        //totalAudioBuffer.append(contentsOf: frequencyDomainBuffer)
        
        dispatchSemaphore.signal()
        
    }
    
    var maxFloat: Float = {
        var maxValue = [Float(Int16.max)]
        vDSP.convert(amplitude: maxValue, toDecibels: &maxValue, zeroReference: Float(AudioSpectrogram.sampleCount))
        return maxValue[0] * 2
    }()
    
    func createAudioSpectrogram() {
        let maxFloats: [Float] = [255, maxFloat, maxFloat, maxFloat]
        let minFloats: [Float] = [255, 0, 0, 0]
        
        frequencyDomainValues.withUnsafeMutableBufferPointer {
            var planarImageBuffer = vImage_Buffer(data: $0.baseAddress!, height: vImagePixelCount(AudioSpectrogram.bufferCount), width: vImagePixelCount(AudioSpectrogram.sampleCount), rowBytes: AudioSpectrogram.sampleCount * MemoryLayout<Float>.stride)
            
            vImageConvert_PlanarFToARGB8888(&planarImageBuffer, &planarImageBuffer, &planarImageBuffer, &planarImageBuffer, &rgbImageBuffer, maxFloats, minFloats, vImage_Flags(kvImageNoFlags))
            
        }
        
        vImageTableLookUp_ARGB8888(&rgbImageBuffer, &rgbImageBuffer, nil, &AudioSpectrogram.redTable, &AudioSpectrogram.greenTable, &AudioSpectrogram.blueTable, vImage_Flags(kvImageNoFlags))
        
        vImageRotate90_ARGB8888(&rgbImageBuffer, &rotatedImageBuffer, UInt8(kRotate90DegreesCounterClockwise), [UInt8()], vImage_Flags(kvImageNoFlags))
        
        if let image = try? rotatedImageBuffer.createCGImage(format: rgbImageFormat) {
            DispatchQueue.main.async {
                self.contents = image
            }
        }
    }
    
}

#if os(iOS)
import UIKit
#else
import Cocoa
#endif

extension AudioSpectrogram {
#if os(iOS)
    typealias Color = UIColor
#else
    typealias Color = NSColor
#endif
    
    static func brgValue(from value: Pixel_8) -> (red: Pixel_8,
                                                  green: Pixel_8,
                                                  blue: Pixel_8) {
        let normalizedValue = CGFloat(value) / 255
        
        // Define `hue` that's blue at `0.0` to red at `1.0`.
        let hue = 0.6666 - (0.6666 * normalizedValue)
        let brightness = sqrt(normalizedValue)
        
        let color = Color(hue: hue,
                          saturation: 1,
                          brightness: brightness,
                          alpha: 1)
        
        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()
        
        color.getRed(&red,
                     green: &green,
                     blue: &blue,
                     alpha: nil)
        
        return (Pixel_8(green * 255),
                Pixel_8(red * 255),
                Pixel_8(blue * 255))
    }
}

extension AudioSpectrogram: AVCaptureAudioDataOutputSampleBufferDelegate {
 
    public func captureOutput(_ output: AVCaptureOutput,
                              didOutput sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {

        var audioBufferList = AudioBufferList()
        var blockBuffer: CMBlockBuffer?
  
        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
            sampleBuffer,
            bufferListSizeNeededOut: nil,
            bufferListOut: &audioBufferList,
            bufferListSize: MemoryLayout.stride(ofValue: audioBufferList),
            blockBufferAllocator: nil,
            blockBufferMemoryAllocator: nil,
            flags: kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment,
            blockBufferOut: &blockBuffer)
        
        guard let data = audioBufferList.mBuffers.mData else {
            return
        }

        /// The _Nyquist frequency_ is the highest frequency that a sampled system can properly
        /// reproduce and is half the sampling rate of such a system. Although  this app doesn't use
        /// `nyquistFrequency` you may find this code useful to add an overlay to the user interface.
        if nyquistFrequency == nil {
            let duration = Float(CMSampleBufferGetDuration(sampleBuffer).value)
            let timescale = Float(CMSampleBufferGetDuration(sampleBuffer).timescale)
            let numsamples = Float(CMSampleBufferGetNumSamples(sampleBuffer))
            nyquistFrequency = 0.5 / (duration / timescale / numsamples)
        }

        if self.rawAudioData.count < AudioSpectrogram.sampleCount * 2 {
            let actualSampleCount = CMSampleBufferGetNumSamples(sampleBuffer)
            
            let ptr = data.bindMemory(to: Int16.self, capacity: actualSampleCount)
            let buf = UnsafeBufferPointer(start: ptr, count: actualSampleCount)
            
            rawAudioData.append(contentsOf: Array(buf))
        }

        while self.rawAudioData.count >= AudioSpectrogram.sampleCount {
            let dataToProcess = Array(self.rawAudioData[0 ..< AudioSpectrogram.sampleCount])
            self.rawAudioData.removeFirst(AudioSpectrogram.hopCount)
            self.processData(values: dataToProcess)
        }
     
        createAudioSpectrogram()
    }
    
    func configureCaptureSession() {
        // Also note that:
        //
        // When running in iOS, you must add a "Privacy - Microphone Usage
        // Description" entry.
        //
        // When running in macOS, you must add a "Privacy - Microphone Usage
        // Description" entry to `Info.plist`, and check "audio input" and
        // "camera access" under the "Resource Access" category of "Hardened
        // Runtime".
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized:
                    break
            case .notDetermined:
                sessionQueue.suspend()
                AVCaptureDevice.requestAccess(for: .audio,
                                              completionHandler: { granted in
                    if !granted {
                        fatalError("App requires microphone access.")
                    } else {
                        self.configureCaptureSession()
                        self.sessionQueue.resume()
                    }
                })
                return
            default:
                // Users can add authorization in "Settings > Privacy > Microphone"
                // on an iOS device, or "System Preferences > Security & Privacy >
                // Microphone" on a macOS device.
                fatalError("App requires microphone access.")
        }
        
        captureSession.beginConfiguration()
        
        #if os(macOS)
        // Note than in macOS, you can change the sample rate, for example to
        // `AVSampleRateKey: 22050`. This reduces the Nyquist frequency and
        // increases the resolution at lower frequencies.
        audioOutput.audioSettings = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMBitDepthKey: 16,
            AVNumberOfChannelsKey: 1]
        #endif
        
        if captureSession.canAddOutput(audioOutput) {
            captureSession.addOutput(audioOutput)
        } else {
            fatalError("Can't add `audioOutput`.")
        }
        
        guard
            let microphone = AVCaptureDevice.default(.builtInMicrophone,
                                                     for: .audio,
                                                     position: .unspecified),
            let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
                  fatalError("Can't create microphone.")
        }
        
        if captureSession.canAddInput(microphoneInput) {
            captureSession.addInput(microphoneInput)
        }
        
        captureSession.commitConfiguration()
    }
    
    /// Starts the audio spectrogram.
    func startRunning() {
        sessionQueue.async {
            if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopRunning() {
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
}
