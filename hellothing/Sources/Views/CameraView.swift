import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var camera = CameraModel()
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            
            // Overlay Controls
            VStack {
                Spacer()
                
                Button(action: {
                    camera.takePhoto()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 80, height: 80)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            camera.checkPermissions()
        }
        .alert(isPresented: $camera.showPermissionAlert) {
            Alert(title: Text("Camera Access"), message: Text("Please enable camera access in Settings to use Magic Friend."), dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - Camera Model
class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var showPermissionAlert = false
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    private let output = AVCapturePhotoOutput()
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async { self.setupCamera() }
                }
            }
        case .denied, .restricted:
            DispatchQueue.main.async { self.showPermissionAlert = true }
        @unknown default:
            break
        }
    }
    
    func setupCamera() {
        do {
            session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            let input = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePhoto() {
        // Simple capture
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    // Delegate method for photo capture
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        print("Photo captured! Size: \(imageData.count)")
        // TODO: Send to API
    }
}

// MARK: - Preview View (UIKit Wrapper)
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.previewLayer = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.previewLayer?.frame = view.frame
        camera.previewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.previewLayer!)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update frame if needed
    }
}
