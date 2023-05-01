//
//  AudioRecorder.swift
//  Based
//
//  Created by antuan.khoanh on 01/05/2023.
//

import Foundation
import AVFoundation

class Recorder {
    var audioRecorder: AVAudioRecorder?
    var recordingSession: AVAudioSession?
    
    func startRecording() throws {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
        } catch {
            throw RecordingError.audioSessionSetupError
        }
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
        } catch {
            throw RecordingError.recordingSetupError
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        recordingSession = nil
    }
    
    func getRecordedAudioURL() -> URL? {
        audioRecorder?.url
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func playRecordedAudio(at url: URL) throws {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            throw PlaybackError.audioPlayerSetupError
        }
    }

}

enum PlaybackError: Error {
    case audioPlayerSetupError
}

enum RecordingError: Error {
    case audioSessionSetupError
    case recordingSetupError
}

