import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var camera = CameraModel()
    @State private var generationResponse: GenerationResponse?
    @State private var originalImage: UIImage?
    @State private var isUploading = false
    @State private var navigateToResult = false
    @State private var errorMessage: String?
    @State private var showError = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Camera Preview
                CameraPreview(camera: camera)
                    .ignoresSafeArea()
                
                // Overlay Controls
                if isUploading {
                    Color.black.opacity(0.6).ignoresSafeArea()
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                        Text("Making Magic...")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        Button(action: {
                            camera.takePhoto { image in
                                self.originalImage = image
                                uploadPhoto(image)
                            }
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
            }
            .navigationDestination(isPresented: $navigateToResult) {
                if let response = generationResponse, let img = originalImage {
                    CharacterResultView(generationResponse: response, originalImage: img)
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            camera.checkPermissions()
        }
    }
    
    func uploadPhoto(_ image: UIImage) {
        isUploading = true
        Task {
            do {
                let response = try await APIService.shared.uploadImage(image)
                DispatchQueue.main.async {
                    self.generationResponse = response
                    self.isUploading = false
                    self.navigateToResult = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to upload: \(error.localizedDescription)"
                    self.isUploading = false
                    self.showError = true
                }
            }
        }
    }
}

// MARK: - Camera Model
class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var displayPreview = true // Toggle to free resources?
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    // Callback for photo
    var photoCallback: ((UIImage) -> Void)?
    
    private let output = AVCapturePhotoOutput()
    
    func checkPermissions() {
        // ... (Existing Permission Logic) ...
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { DispatchQueue.main.async { self.setupCamera() } }
            }
        default: break
        }
    }
    
    func setupCamera() {
        guard !session.isRunning else { return }
        do {
            session.beginConfiguration()
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(output) { session.addOutput(output) }
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }
        } catch { print(error) }
    }
    
    func takePhoto(completion: @escaping (UIImage) -> Void) {
        self.photoCallback = completion
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            // Fix Orientation potentially needed, but start simple
            photoCallback?(image)
        }
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
