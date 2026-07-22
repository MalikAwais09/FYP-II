from fpdf import FPDF
import os

pdf = FPDF()
pdf.set_auto_page_break(auto=True, margin=15)
pdf.add_page()
pdf.set_font("Arial", size=12)

def add_title(title):
    pdf.set_font("Arial", 'B', 16)
    pdf.cell(200, 10, txt=title, ln=True, align='C')
    pdf.ln(10)

def add_heading(heading):
    pdf.set_font("Arial", 'B', 14)
    pdf.cell(200, 10, txt=heading, ln=True, align='L')
    pdf.ln(5)

def add_text(text):
    pdf.set_font("Arial", size=12)
    pdf.multi_cell(0, 7, txt=text)
    pdf.ln(5)

def add_code(code_text):
    pdf.set_font("Courier", size=9)
    # Split text into lines to avoid missing newlines
    for line in code_text.split("\n"):
        pdf.multi_cell(0, 5, txt=line)
    pdf.ln(5)

add_title("Camera Manager & Audio Recorder - Cheatsheet")

# Camera Service Section
add_heading("1. CameraService (Camera Manager)")
add_text("Yeh class app mein device ka camera handle karti hai, frames capture karti hai aur singleton pattern par bani hai. Niche iska clean code aur comments mojud hain:")

camera_code = """import AVFoundation  // Camera/video operations ke liye
import UIKit                   // UI components ke liye

// Singleton class: Poori app mein sirf ek camera instance chalega
class CameraService: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    static let shared = CameraService() // Globally access karne ke liye instance
    
    let session = AVCaptureSession() // Real-time capture manage karta hai
    let previewLayer = AVCaptureVideoPreviewLayer() // UI layer jahan live feed aati hai
    private let output = AVCaptureVideoDataOutput() // Raw frames output karta hai
    private var captureHandler: ((UIImage) -> Void)? // Jab frame capture ho, yeh callback chalega
    private var lastCaptureTime = Date() // 1-frame/sec ko track karne ke liye
    var cameraPosition: AVCaptureDevice.Position = .front // By default front camera
    
    private override init() {
        super.init()
        session.beginConfiguration() // Configuration start karo
        
        // Input device (camera) setup karo
        if let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition),
           let input = try? AVCaptureDeviceInput(device: camera),
           session.canAddInput(input) {
            session.addInput(input) // Camera input session mein add karo
        }
        
        // Output frames setup karo
        if session.canAddOutput(output) { session.addOutput(output) }
        
        // Delegate for receiving frames (alag queue par)
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        session.commitConfiguration() // Configuration apply karo
        previewLayer.session = session // Preview layer ko connect karo
    }
    
    func startSession() { if !session.isRunning { session.startRunning() } } // Session start
    func stopSession() { if session.isRunning { session.stopRunning() } } // Session band
    
    func startCapturing(_ handler: @escaping (UIImage) -> Void) {
        captureHandler = handler // Handler set karo jo images aage API ko bhejega
    }
    
    // Delegate method: Jab naya frame aata hai, yeh function call hota hai
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let now = Date()
        // 1 second ka interval check (1 frame/sec)
        guard now.timeIntervalSince(lastCaptureTime) >= 1.0 else { return }
        lastCaptureTime = now
        connection.videoOrientation = .portrait // Orientation portrait rakho
        
        // CMSampleBuffer ko UIImage mein convert karna
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let image = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
            captureHandler?(image) // Image wapas bhejo
        }
    }
    
    // Front aur Back camera switch karne ke liye
    func switchCamera(position: AVCaptureDevice.Position) {
        session.beginConfiguration()
        session.inputs.forEach { session.removeInput($0) } // Purana input hataya
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input) else {
            session.commitConfiguration(); return
        }
        session.addInput(input) // Naya input lagaya
        session.commitConfiguration()
    }
}"""
add_code(camera_code)

add_heading("Changes in CameraService:")
add_text("- Agar Frame Rate badhana ho: 'lastCaptureTime >= 1.0' ko 0.5 ya remove kar dein.\n- Agar Default Back Camera karna ho: 'var cameraPosition = .back' set karein.\n- Image Size choti karni ho: captureOutput mein UIImage ko resize karke captureHandler ko bhejein.")
pdf.add_page()

# Audio Service Section
add_heading("2. AudioRecorderService (Audio Recorder)")
add_text("Yeh class microphone se audio capture karti hai, Live Speech-to-Text chalati hai, aur chunk wise audio API ko bhejti hai:")

audio_code = """import AVFoundation // Audio ke liye
import Combine
import Speech // Live Speech-to-Text ke liye

class AudioRecorderService: NSObject, ObservableObject {

    @Published var isRecording: Bool = false // UI pe recording status dikhane ke liye
    @Published var lastChunkText: String = "" // Speech ka text yahan aata hai
    @Published var moveNext: Bool = false // Voice command pe 'Next' click
    @Published var selectedOption: Int? = nil // Voice command 'Option A,B,C,D'

    private let audioEngine = AVAudioEngine() // Audio processing ka main engine
    private let speechRecognizer = SFSpeechRecognizer() // Speech recognition object
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    private var chunkFile: AVAudioFile? // Temp file jisme audio chunk save hoga
    private var chunkURL: URL? // Us temp file ka rasta (path)
    private var chunkStartTime: Date = Date() // Chunk shuru hone ka time

    private var networkManager: NetworkManager = NetworkManager(port: "8002") // API Calling

    var attempt_id: Int?; var questionId: Int?; var examType: String?; var identityNo: String = ""

    init(aridNo: String) { self.identityNo = aridNo }

    func startStreaming() { requestPermissions() } // Recording start karne ke liye
    
    func stopStreaming() {
        finalizeCurrentChunk() // Aakhri chunk upload karo
        audioEngine.stop(); audioEngine.inputNode.removeTap(onBus: 0) // Engine band karo
        recognitionRequest?.endAudio(); recognitionTask?.cancel() // Speech band karo
        isRecording = false
    }

    private func requestPermissions() {
        // Mic aur Speech permissions mango
        AVAudioApplication.requestRecordPermission { [weak self] granted in
            guard granted else { return }
            SFSpeechRecognizer.requestAuthorization { [weak self] status in
                guard status == .authorized else { return }
                DispatchQueue.main.async {
                    self?.setupAudioSession()
                    self?.startAudioEngine() // Mic on karo
                    self?.startSpeechRecognition() // Live Speech on karo
                    self?.isRecording = true
                }
            }
        }
    }

    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
        try? session.setActive(true)
    }

    private func startAudioEngine() {
        let inputNode = audioEngine.inputNode; inputNode.removeTap(onBus: 0)
        let format = inputNode.outputFormat(forBus: 0)

        openNewChunkFile(format: format) // Pehla naya chunk file open karo

        // Mic se buffers (audio packets) intercept karna
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: format) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer) // Live Speech ko data dena
            if self?.chunkFile != nil { try? self?.chunkFile?.write(from: buffer) } // File me likhna
        }
        audioEngine.prepare(); try? audioEngine.start()
    }

    private func startSpeechRecognition() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else { return }
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true; recognitionRequest = request

        // Text receive hona shuru hoga
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self?.lastChunkText = result.bestTranscription.formattedString
                    self?.handleVoiceCommand(self!.lastChunkText.lowercased()) // Commands check karo
                }
            }
            if error != nil { DispatchQueue.main.async { self?.restartSpeechRecognition() } } // Restart if limit crossed
        }
    }

    private func restartSpeechRecognition() {
        recognitionRequest?.endAudio(); recognitionTask?.cancel(); recognitionRequest = nil
        startSpeechRecognition()
    }

    private func handleVoiceCommand(_ text: String) {
        if text.contains("command next") { moveNext = true }
        else if text.contains("option a") { selectedOption = 0 }
        else if text.contains("option b") { selectedOption = 1 }
        else if text.contains("option c") { selectedOption = 2 }
        else if text.contains("option d") { selectedOption = 3 }
    }

    public func openNewChunkFile(format: AVAudioFormat) {
        chunkStartTime = Date() // Naya waqt record karo
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".wav")
        chunkFile = try? AVAudioFile(forWriting: url, settings: format.settings) // Nayi file banao
        chunkURL = url
    }

    public func finalizeCurrentChunk() {
        guard let url = chunkURL else { return }
        let urlToUpload = url; let startTimeStr = formatDate(chunkStartTime); let endTimeStr = formatDate(Date())
        let qID = questionId ?? 0; let aID = attempt_id; let eType = examType ?? "mcq"; let iNo = identityNo
        
        chunkFile = nil; chunkURL = nil // Purani file memory se nikalo aur band karo

        // Uploading API ko bhejo
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
            self.uploadChunk(at: urlToUpload, attemptId: aID, questionId: qID, examType: eType, identityNo: iNo, startTime: startTimeStr, endTime: endTimeStr)
        }
    }

    public func startNewChunk() {
        finalizeCurrentChunk() // Purana band karo
        let format = audioEngine.inputNode.outputFormat(forBus: 0)
        openNewChunkFile(format: format) // Naya shuru karo
    }

    private func uploadChunk(at url: URL, attemptId: Int?, questionId: Int, examType: String, identityNo: String, startTime: String, endTime: String) {
        guard let audioData = try? Data(contentsOf: url), let attemptId = attemptId else { return }
        
        // API Call
        networkManager.requestMultipart(
            url: "/voiceMonitoringDiarize", parameters: ["attempt_id": attemptId, "identity_no": identityNo, "question_id": questionId, "exam_type": examType, "start_time": startTime, "end_time": endTime],
            fileData: audioData, fileName: "chunk.wav", mimeType: "audio/wav"
        ) { _, _ in } // API Response
        
        try? FileManager.default.removeItem(at: url) // Device se file delete kar do
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter(); formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}"""
add_code(audio_code)

add_heading("Changes in AudioRecorderService:")
add_text("- Agar Voice Command change karni ho: 'handleVoiceCommand' function mein if text.contains('command next') ki jagah naya word daal dein.\n- Agar file format WAV se M4A karna ho: 'openNewChunkFile' me extension .m4a rakhein aur network api type 'audio/m4a' kar dein.\n- Agar Live text nahi chahiye: 'startSpeechRecognition' ko call na karein.\n- Agar API route change karna ho: '/voiceMonitoringDiarize' ko new URL se update kar dein.")

pdf.output("Proctoring_Cheatsheet.pdf")
print("PDF Generated successfully!")
