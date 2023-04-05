import UIKit
import AVFoundation
import Vision

class ImageRecognitionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var previewHeight       = Int()
    let preView             = UIView()
    let captureSession      = AVCaptureSession()
    var viewRunning         = false
    var card                = SharedCardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Protocols.imageRecognitionDelegate = self
        setupCaptureSession()
        card.speakerButton.isHidden = true
    }
    @objc func sayPhrase(sender:UITapGestureRecognizer){
        if card.itaLabel.text != ""{
            Helpers.shared.speak(phrase: card.itaLabel.text!)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UserData.imageRecognitionActive = true
        if viewRunning == true{
            captureSession.startRunning()
        }
        navigationController!.tabBarItem.image = UIImage(systemName: "paperplane.fill")
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserData.imageRecognitionActive = false
        captureSession.stopRunning()
        navigationController!.tabBarItem.image = UIImage(systemName: "paperplane")
    }
    func setupCaptureSession() {
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        do {
            if let captureDevice = availableDevices.first {
                let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(captureDeviceInput)
            }
        }catch{
            print(error.localizedDescription)
        }
        let captureOutput = AVCaptureVideoDataOutput()
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(captureOutput)
        preView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(preView)
        preView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        preView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        preView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        preView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        preView.layer.addSublayer(previewLayer)
        DispatchQueue.global(qos: .userInitiated).async {
            self.viewRunning = true
            self.captureSession.startRunning()
        }
        DispatchQueue.main.async { [self] in
            previewLayer.frame = preView.bounds
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            card.translatesAutoresizingMaskIntoConstraints = false
            preView.addSubview(card)
            card.backgroundColor = .clear
            card.mainView.backgroundColor = .clear
            card.expandView.isHidden = true
            card.addButton.isHidden = true
            card.faveButton.isHidden = true
            card.spinner.isHidden = true
            card.leftAnchor.constraint(equalTo: preView.leftAnchor, constant: 16).isActive = true
            card.rightAnchor.constraint(equalTo: preView.rightAnchor, constant: -16).isActive = true
            card.bottomAnchor.constraint(equalTo: preView.bottomAnchor,constant: 19).isActive = true
            card.isHidden = true
            ImagePlaceholderView.shared.frame = self.view.frame
            preView.addSubview(ImagePlaceholderView.shared)
            ImagePlaceholderView.shared.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            ImagePlaceholderView.shared.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            ImagePlaceholderView.shared.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            ImagePlaceholderView.shared.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            ImagePlaceholderView.shared.placeHolderImage.translatesAutoresizingMaskIntoConstraints = false
            ImagePlaceholderView.shared.placeHolderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            ImagePlaceholderView.shared.placeHolderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        
        if UserDefaults.standard.bool(forKey: UserData.lang) != true{
            present(AlertView.shared.modelDownloading(), animated: true, completion: nil)
        }
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model) else {return}
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let Observation = results.first else { return }
            DispatchQueue.main.async(execute: {
                if Observation.confidence >= 0.5{
                    var result = String()
                    if "\(Observation.identifier)".contains(","){
                        if let index = (Observation.identifier.range(of: ",")?.lowerBound)
                        {
                            let beforeEqualsTo = String(Observation.identifier.prefix(upTo: index))
                            result = beforeEqualsTo
                        }
                    }else{
                        result = "\(Observation.identifier)"
                    }
                    self.card.engLabel.text = "\(result)".capitalizingFirstLetter()
                    TranslateModel.shared.translate(eng: "\(result)", learningLang: "")
                }
            })
        }
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
extension ImageRecognitionViewController:ImageRecognitionDelegate{
    func dismiss(){
        navigationController?.popToRootViewController(animated: true)
    }
    func completeTranslate() {
        card.pronounceBottom.constant = 0
        card.pronounceHeight.constant = 0
        card.cardHeight.constant = 79.33
        card.pronounceLabel.text = ""
        card.itaLabel.text = TranslateModel.shared.translation?.capitalizingFirstLetter()
        ImagePlaceholderView.shared.isHidden = true
        card.isHidden = false
    }
    func popToRoot(){
        navigationController?.popToRootViewController(animated: false)
    }
    func stopRunning(){
        captureSession.stopRunning()
    }
    func startRunning(){
        if viewRunning == true{
            captureSession.startRunning()
        }
    }
}
