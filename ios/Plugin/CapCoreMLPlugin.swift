import Foundation
import Capacitor
import ZIPFoundation
import Path

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapCoreMLPlugin)
public class CapCoreMLPlugin: CAPPlugin, FileDownloaderDelegate {
    func downloadDidStart() {
        
    }
    
    func downloadDidComplete(withURL url: URL) {
        
    }
    
    func downloadDidFail(withError error: Error) {
        
    }
    
    func downloadDidUpdateProgress(progress: Double) {
        
    }
    
    private let implementation = CapCoreML()
    var downloader: FileDownloader?

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
//        unzip()
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

    @objc func download(_ call: CAPPluginCall) {
        if let url = URL(string: "https://huggingface.co/coreml/coreml-stable-diffusion-2-1-base/resolve/main/split_einsum/stable-diffusion-v2.1-base_no-i2i_split-einsum.zip"),
           let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let savePath = documentsDirectoryURL.appendingPathComponent("stable-diffusion-v2.1-base_no-i2i_split-einsum.zip")
            
            // 保存先のファイルがすでに存在している場合、削除する
            if FileManager.default.fileExists(atPath: savePath.path) {
                try? FileManager.default.removeItem(at: savePath)
            }
            downloader = FileDownloader(from: url, to: savePath)
            downloader!.delegate = self
            downloader!.startDownloading()
        }
        call.resolve([
            "value": "download"
        ])
    }
    
//    func unzip() async throws {
//        if let downloadedURL = downloader?.downloadPath {
//            let uncompressPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("stable-diffusion-v2.1-base_no-i2i_split-einsum.zip")
//            do {
//                try FileManager().unzipItem(at: downloadedURL, to: uncompressPath)
//            } catch {
//                try uncompressPath.delete()
//                throw error
//            }
//            try downloadedPath.delete()
//        }
//    }
    
    @objc func load(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        if let dl = downloader {
            print(dl.isDownloading)
            print(dl.progress)
        }
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
}
