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
    let modelsDirName = "models"
    
    func downloadDidStart() {
        print("downloadDidStart")
    }
    
    func downloadDidComplete(withURL url: URL) {
        print("downloadDidComplete")
    }
    
    func downloadDidFail(withError error: Error) {
        print("downloadDidFail", error)
    }
    
    func downloadDidUpdateProgress(progress: Double) {
    }
    
    private let implementation = CapCoreML()
    var downloader: FileDownloader?

    @objc func echo(_ call: CAPPluginCall) {
        let url = "https://huggingface.co/coreml/coreml-stable-diffusion-2-1-base/resolve/main/split_einsum/stable-diffusion-v2.1-base_no-i2i_split-einsum.zip"
        downloader = FileDownloader(url: url, modelsDirName: modelsDirName)
        downloader!.delegate = self
        downloader!.unzip()
        call.resolve([
            "value": "unzip"
        ])
    }

    @objc func download(_ call: CAPPluginCall) {
        let force = true;
//        let urlString = "https://video.kurashiru.com/production/articles/fda43e08-0b80-491b-9424-ad137ecc6067/wide_thumbnail_large.jpg"
        let url = "https://huggingface.co/coreml/coreml-stable-diffusion-2-1-base/resolve/main/split_einsum/stable-diffusion-v2.1-base_no-i2i_split-einsum.zip"

        downloader = FileDownloader(url: url, modelsDirName: modelsDirName)
        downloader!.delegate = self
        downloader!.startDownloading()
        call.resolve([
            "value": "queue"
        ])
    }
    
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
