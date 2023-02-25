//
//  FileDownloader.swift
//  Plugin
//
//  Created by himanushi on 2023/02/25.
//  Copyright © 2023 Max Lynch. All rights reserved.
//

import Foundation

protocol FileDownloaderDelegate: AnyObject {
    func downloadDidStart()
    func downloadDidComplete(withURL url: URL)
    func downloadDidFail(withError error: Error)
    func downloadDidUpdateProgress(progress: Double)
}

class FileDownloader: NSObject, ObservableObject {
    
    private var downloadTask: URLSessionDownloadTask?
    private var resumeData: Data?
    private var downloadPath: URL
    private var savePath: URL
    
    weak var delegate: FileDownloaderDelegate?
    
    var isDownloading: Bool {
        return downloadTask != nil
    }
    
    var progress: Double = 0.0 {
        didSet {
            delegate?.downloadDidUpdateProgress(progress: progress)
        }
    }
    
    init(from url: URL, to directory: URL) {
        downloadPath = url
        savePath = directory
    }
    
    func startDownloading() {
        delegate?.downloadDidStart()
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        let downloadRequest = URLRequest(url: downloadPath)
        downloadTask = session.downloadTask(with: downloadRequest)
        downloadTask?.resume()
    }
    
    func pauseDownloading() {
        downloadTask?.cancel(byProducingResumeData: { resumeData in
            self.resumeData = resumeData
        })
        downloadTask = nil
    }
    
    func resumeDownloading() {
        guard let resumeData = resumeData else { return }
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        downloadTask = session.downloadTask(withResumeData: resumeData)
        downloadTask?.resume()
        self.resumeData = nil
    }
    
    func cancelDownloading() {
        downloadTask?.cancel()
        downloadTask = nil
        resumeData = nil
    }
}

extension FileDownloader: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            try FileManager.default.moveItem(at: location, to: savePath)
            delegate?.downloadDidComplete(withURL: savePath)
        } catch {
            delegate?.downloadDidFail(withError: error)
        }
        self.downloadTask = nil
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            delegate?.downloadDidFail(withError: error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
    }
}
