//
//  VideoConverter.swift
//  ImpressionsChallenge
//
//  Created by luis.gustavo.jacinto on 03/04/21.
//

import AVFoundation
import Foundation

protocol VideoConverterDelegate: AnyObject {
    func videoConvertedSuccessfully(_ url: URL);
    func videoConvertedFailure(_ error: VideoConverterError);
    func updateProgress(_ progress: Float)
}

enum VideoConverterError: Error {
    case incompatibleType
    case failedToExport
    case cancelled
    case videoTrackNotAvailable
    case issueInsertingVideo
    case audioTrackNotAvailable
    case issueInsertingAudio
        
    var errorDescription: String {
        switch self {
        case .incompatibleType: return "Incompatible Type"
        case .failedToExport: return "Failed to Export"
        case .cancelled: return "Cancelled"
        case .videoTrackNotAvailable: return "Video Track Not Available"
        case .issueInsertingVideo: return "Issue Inserting Video"
        case .audioTrackNotAvailable: return "Audio Track Not Available"
        case .issueInsertingAudio: return "Issue Inserting Audio"
        }
    }
}

protocol VideoConverterProtocol {
    var delegate: VideoConverterDelegate? { get set }
    func convertVideo(from url: URL)
}

final class VideoConverter: VideoConverterProtocol {
    
    // MARK: - Properties
    weak var delegate: VideoConverterDelegate?
    
    func convertVideo(from url: URL) {
        let asset = AVURLAsset(url: url)
        
        let composition = AVMutableComposition()
        let videoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID:kCMPersistentTrackID_Invalid)
        let audioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        let tracks = asset.tracks(withMediaType: AVMediaType.video)
        
        guard let assetVideoTrack = tracks.first else {
            delegate?.videoConvertedFailure(.videoTrackNotAvailable)
            return
       }
               
       // Insert the tracks in the composition's tracks
        do {
            try videoTrack?.insertTimeRange(assetVideoTrack.timeRange, of: assetVideoTrack, at: CMTimeMake(value: 0, timescale: 1))
        } catch {
            delegate?.videoConvertedFailure(.issueInsertingVideo)
        }
        videoTrack?.preferredTransform = assetVideoTrack.preferredTransform;
               
       // Extracting Audio
        guard let assetAudioTrack : AVAssetTrack = asset.tracks(withMediaType: AVMediaType.audio).first else {
            delegate?.videoConvertedFailure(.audioTrackNotAvailable)
            return
       }
        
        do {
            try audioTrack?.insertTimeRange(assetAudioTrack.timeRange, of: assetAudioTrack, at: CMTimeMake(value: 0, timescale: 1))
        } catch {
            delegate?.videoConvertedFailure(.issueInsertingAudio)
            return
        }
        
        let preset = AVAssetExportPreset960x540
        let outFileType = AVFileType.mov
        let outputURL = createOutputURL()

        AVAssetExportSession.determineCompatibility(ofExportPreset: preset,
                                                    with: composition,
                                                    outputFileType: outFileType) { isCompatible in
            guard isCompatible else {
                self.delegate?.videoConvertedFailure(.incompatibleType)
                return
            }
            
            guard let exportSession = AVAssetExportSession(asset: composition,
                                                           presetName: preset) else { return }
            exportSession.outputFileType = outFileType
            exportSession.outputURL = outputURL
            
            let start = CMTime(value: 0, timescale: 1)
            let duration = CMTime(value: 20, timescale: 1)
            exportSession.timeRange = CMTimeRangeMake(start: start, duration: duration)
            
            exportSession.exportAsynchronously { [weak self] in
                guard let self = self else { return }
                
                switch exportSession.status {
                case .completed:
                    guard let url = exportSession.outputURL else { return }
                    self.delegate?.videoConvertedSuccessfully(url)
                case .failed: self.delegate?.videoConvertedFailure(.failedToExport)
                case .cancelled: self.delegate?.videoConvertedFailure(.failedToExport)
                default: debugPrint("Default")
                }
            }
            
            DispatchQueue.global().async {
                while(exportSession.status == .exporting || exportSession.status == .waiting) {
                    DispatchQueue.main.async {
                        self.delegate?.updateProgress(exportSession.progress)
                    }
                }
            }
        }
    }
}

// MARK: - VideoConverter private methods extension
private extension VideoConverter {
    private func createOutputURL(fileName: String = UUID().uuidString) -> URL {
        return URL(fileURLWithPath: "\(NSHomeDirectory())/Documents/\(fileName).").appendingPathExtension(".mov")
    }
}
