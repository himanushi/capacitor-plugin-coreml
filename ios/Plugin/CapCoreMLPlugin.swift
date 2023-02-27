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
    var modelDir = "models"
    
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
        let value = call.getString("value") ?? ""
        if let dl = downloader {
            dl.cancelDownloading()
        }
        Task {
            call.resolve([
                "value": implementation.echo(value)
            ])
        }
    }

    @objc func download(_ call: CAPPluginCall) {
        let force = true;
        modelDir = "models";
//        let urlString = "https://video.kurashiru.com/production/articles/fda43e08-0b80-491b-9424-ad137ecc6067/wide_thumbnail_large.jpg"
        let urlString = "https://huggingface.co/coreml/coreml-stable-diffusion-2-1-base/resolve/main/split_einsum/stable-diffusion-v2.1-base_no-i2i_split-einsum.zip"

        if let url = URL(string: urlString) {
            let saveDirPath = Path.documents / modelDir
            let savePath = saveDirPath / url.lastPathComponent

            if FileManager.default.fileExists(atPath: savePath.string) {
                if (force) {
                    try? FileManager.default.removeItem(at: savePath.url)
                } else {
                    call.resolve([
                        "value": "done"
                    ])
                    return
                }
            }

            downloader = FileDownloader(from: url, to: saveDirPath.url)
            downloader!.delegate = self
            downloader!.startDownloading()
        }
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
