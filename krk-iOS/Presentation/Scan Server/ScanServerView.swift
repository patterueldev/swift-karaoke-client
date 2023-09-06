//
//  ScanServerView.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import SwiftUI
import AVFoundation

protocol ScanServerDelegate {
    func didFinishedSettingUp()
}

struct ScanServerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ScanServerViewModel
    
    let delegate: ScanServerDelegate?
    
    init(delegate: ScanServerDelegate?) {
        self.viewModel = ScanServerViewModel()
        self.delegate = delegate
    }
    
    var body: some View {
        VStack {
            QRScanner(action: { result in
                print("Result: \(result)")
                viewModel.scanServer(qrResult: result) {
                    delegate?.didFinishedSettingUp()
                    presentationMode.wrappedValue.dismiss()
                }
            })
            VStack {
                Text("Scan the QR code to connect to the server")
                    .font(.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("You can find the QR code on the server's screen")
                    .font(.title3)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .background(Color.black)
    }
}

#Preview {
    ScanServerView(delegate: nil)
}

struct QRScanner: UIViewControllerRepresentable, QRScannerDelegate {
    let scanAction: (Result<String, Error>) -> Void
    
    init(action: @escaping (Result<String, Error>) -> Void) {
        self.scanAction = action
    }
    
    func makeUIViewController(context: Context) -> QRScannerController {
        let controller = QRScannerController()
        controller.qrScannerDelegate = self
        return controller
    }
 
    func updateUIViewController(_ uiViewController: QRScannerController, context: Context) {
    }
    
    func qrScannerDidScanSuccess(_ qrCode: String) {
        scanAction(.success(qrCode))
    }
    
    func qrScannerDidScanFailure(_ error: Error) {
        scanAction(.failure(error))
    }
    
}
