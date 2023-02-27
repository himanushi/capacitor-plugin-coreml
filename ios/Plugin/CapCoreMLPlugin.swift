import Foundation
import Capacitor
import ZIPFoundation
import Path
import CoreML

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapCoreMLPlugin)
@available(iOS 16.2, macOS 13.1, *)
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
        let beginDate = Date()
        let configuration = MLModelConfiguration()
        do {
            let beginDate = Date()
            let pipelineConfig = MLModelConfiguration()
            pipelineConfig.allowLowPrecisionAccumulationOnGPU = true
            pipelineConfig.computeUnits = .cpuAndGPU
            pipelineConfig.preferredMetalDevice = .none
            let pipeline = try StableDiffusionPipeline(resourcesAt: (Path.documents / "models/stable-diffusion-v2.1-base_split-einsum_compiled").url,
                                                       configuration: pipelineConfig,
                                                       reduceMemory: true)
            print("Pipeline loaded in \(Date().timeIntervalSince(beginDate))")
            print("Generating...")
            var configuration = StableDiffusionPipeline.Configuration(prompt: "a photo of car")
            configuration.stepCount = 3
            configuration.schedulerType = .pndmScheduler
            configuration.guidanceScale = 3
            print("呼ばれてるよおおおおおおお1")
            let images = try pipeline.generateImages(configuration: configuration)
            print("呼ばれてるよおおおおおおお3")
            let interval = Date().timeIntervalSince(beginDate)
            print("Got images: \(images) in \(interval)")
            let image = images.compactMap({ $0 }).first
            var imageStr = ""
            if let imageData = image {
                let uiImage = UIImage(cgImage: imageData)
                if let uiImageData = uiImage.jpegData(compressionQuality: 1.0) {
                    imageStr = uiImageData.base64EncodedString()
                }
            }
            print("呼ばれてるよおおおおおおお4")
            print(imageStr)
            call.resolve([
                "value": imageStr
            ])
        } catch {
            print(error)
            call.resolve([
                "value": "unloaded"
            ])
        }
    }
}
