//
//  RecordingViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 4.03.2022.
//

import UIKit
import AVFoundation
import MapKit
import FirebaseFirestore
import FirebaseStorage

typealias Record = (path: String, title: String, dataKey: String)

class RecordingViewController: BaseViewController {
    
    @IBOutlet private weak var audioSpectrumView: WaveView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var recordingButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var stopRecordButton: UIButton!
    @IBOutlet private weak var recordListTableView: UITableView!
    
    var importedRecord: Record?
    private var recordList: [Record] = [] {
        didSet {
            recordListTableView.reloadData()
            recordListTableView.scrollToRow(at: IndexPath(row: recordList.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    private var userLocation: CLLocation = .init() {
        didSet {
            startRecording()
        }
    }
    
    private var recordingSelected: Record? = nil {
        didSet {
            playButton.isEnabled = true
            shareButton.isEnabled = true
            playButton.tintColor = .systemGreen
            shareButton.tintColor = .systemGreen
        }
    }
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var locationManager: CLLocationManager!
    var player: AVAudioPlayer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let importedRecord = importedRecord {
            recordList.append(importedRecord)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setRecordingState()
        setLocationManager()
        setRecordListTableView()
        configureAudioSpectrumView()
        configureStopRecordingButton()
    }
    
    private func setRecordingState() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    recordingButton.isEnabled = allowed
                }
            }
        } catch {
            presentAlert(title: "Error", message: "Please check device hardware.", buttonTitle: "OK")
        }
    }
    
    private func setLocationManager() {
        locationManager = .init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setRecordListTableView() {
        recordListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        recordListTableView.allowsMultipleSelection = false
    }
    
    private func configureAudioSpectrumView() {
        audioSpectrumView.animationStart(direction: .right, speed: 5)
        audioSpectrumView.clipsToBounds = true
        audioSpectrumView.isHidden = true
    }
    
    private func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(userLocation.coordinate.latitude):\(userLocation.coordinate.longitude).wav")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            audioSpectrumView.isHidden = false
            stopRecordButton.isHidden = false
            recordingButton.isEnabled = false
        } catch {
            presentAlert(title: "Error", message: "Please check device hardware.", buttonTitle: "OK")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func finishRecording() {
        DispatchQueue.main.async {
            self.stopRecordButton.isHidden = true
            self.recordingButton.isEnabled = true
            self.audioSpectrumView.isHidden = true
        }
        let fileName = "\(userLocation.coordinate.latitude):\(userLocation.coordinate.longitude).wav"
        let record = Record(
            path: getDocumentsDirectory().appendingPathComponent(fileName).absoluteString,
            title: String().getCurrentTime(),
            dataKey: fileName
        )
        recordList.append(record)
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    private func configureStopRecordingButton() {
        stopRecordButton.addTarget(self, action: #selector(finishRecording), for: .touchUpInside)
        view.addSubview(stopRecordButton)
        stopRecordButton.isHidden = true
    }
    
    private func playSelectedRecording() {
        isButtonsDeactivated(value: true)
        audioSpectrumView.isHidden = false
        let resourceName = recordList.filter { $0.path == recordingSelected?.path }.first?.path
        guard let resource = resourceName,
              let url = URL(string: resource) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player.prepareToPlay()
            player.delegate = self
            player.play()
        } catch {
            presentAlert(title: "Error", message: "Please check device hardware.", buttonTitle: "OK")
        }
    }
    
    private func isButtonsDeactivated(value: Bool) {
        playButton.isEnabled = !value
        recordingButton.isEnabled = !value
        shareButton.isEnabled = !value
    }
    
    private func uploadSelectedSoundFile() {
        let resourceName = recordList.filter { $0.path == recordingSelected?.path }.first?.path
        let childName = recordList.filter { $0.path == recordingSelected?.path }.first?.dataKey
        guard let resource = resourceName,
              let childName = childName,
              let url = URL(string: resource) else { return }
        showLoading()
        let storage = Storage.storage()
        let metadata = StorageMetadata.init()
        metadata.contentType = "audio/wav"
        let storageRef = storage.reference().child(childName)
        
        storageRef.putFile(from: url, metadata: metadata) { [weak self] metadata, error in
            self?.hideLoading()
            
            if error == nil {
                self?.presentAlert(title: "Success", message: "Uploaded successfully.", buttonTitle: "OK")
            }
            else {
                self?.presentAlert(title: "Error", message: "An error occurred while uploading to the server. Please try again.", buttonTitle: "OK")
            }
        }
    }
    
    @IBAction func didTappedRecordingButton(_ sender: Any) {
        showLoading()
        playButton.isEnabled = false
        shareButton.isEnabled = false
        recordListTableView.reloadData()
        recordListTableView.isUserInteractionEnabled = false
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func didTappedPlayButton(_ sender: UITableViewCell) {
        audioSpectrumView.animationStart(direction: .right, speed: 5, preferredColor: .systemGreen)
        recordListTableView.isUserInteractionEnabled = false
        playSelectedRecording()
    }
    
    @IBAction func didTappedShareButton(_ sender: Any) {
        uploadSelectedSoundFile()
    }
}

extension RecordingViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordListTableView.isUserInteractionEnabled = true
        }
    }
}

extension RecordingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            hideLoading()
            userLocation = location
            locationManager.stopUpdatingLocation()
        }
    }
}

extension RecordingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordListTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = recordList[indexPath.row].title
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recordingSelected = recordList[indexPath.row]
    }
}

extension RecordingViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isButtonsDeactivated(value: false)
        recordListTableView.isUserInteractionEnabled = true
        configureAudioSpectrumView()
        player.stop()
    }
}
