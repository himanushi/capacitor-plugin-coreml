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

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

    @objc func download(_ call: CAPPluginCall) {
        call.resolve([
            "value": "download"
        ])
    }
}
