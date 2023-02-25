import Foundation
import Capacitor
import ZIPFoundation

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapCoreMLPlugin)
public class CapCoreMLPlugin: CAPPlugin {
    private let implementation = CapCoreML()
    var downloader: FileDownloader?

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        if let dl = downloader {
            print(dl.cancelDownloading())
        }
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
            
            let downloader = FileDownloader(from: url, to: savePath)
            downloader.startDownloading()
        }
        call.resolve([
            "value": "download"
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
