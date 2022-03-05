//
//  RecordingViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 4.03.2022.
//

import UIKit
import AVFoundation
import MapKit

typealias Record = (path: String, title: String, dataKey: String)

class RecordingViewController: BaseViewController {
    
    @IBOutlet private weak var audioSpectrumView: WaveView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var recordingButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var recordListTableView: UITableView!
    
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
            playButton.tintColor = .green
            shareButton.tintColor = .green
        }
    }
    
    var stopRecordingButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var locationManager: CLLocationManager!
    var player: AVAudioPlayer!
    
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
            // TO DO: Alert will be added
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
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(userLocation.coordinate.latitude):\(userLocation.coordinate.longitude).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            audioSpectrumView.isHidden = false
            stopRecordingButton.isHidden = false
            recordingButton.isEnabled = false
        } catch {
            // TO DO: Alert will be implemented
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func finishRecording() {
        DispatchQueue.main.async {
            self.stopRecordingButton.isHidden = true
            self.recordingButton.isEnabled = true
            self.audioSpectrumView.isHidden = true
        }
        let fileName = "\(userLocation.coordinate.latitude):\(userLocation.coordinate.longitude).m4a"
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
        let buttonImage = UIImage(systemName: "pause.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        stopRecordingButton = UIButton(frame: CGRect(x: stackView.frame.midX - 48, y: stackView.frame.midY - 24, width: 64, height: 64))
        stopRecordingButton.layer.cornerRadius = 32
        stopRecordingButton.setImage(buttonImage, for: .normal)
        stopRecordingButton.backgroundColor = .red
        stopRecordingButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        stopRecordingButton.addTarget(self, action: #selector(finishRecording), for: .touchUpInside)
        view.addSubview(stopRecordingButton)
        stopRecordingButton.isHidden = true
    }
    
    private func playSelectedRecording() {
        isButtonsDeactivated(value: true)
        audioSpectrumView.isHidden = false
        let resourceName = recordList.filter { $0.path == recordingSelected?.path }.first?.path
        guard let resource = resourceName,
              let url = URL(string: resource) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            player.prepareToPlay()
            player.delegate = self
            player.play()
        } catch {
            // TO DO: Alert will be implemented
        }
    }
    
    private func isButtonsDeactivated(value: Bool) {
        playButton.isEnabled = !value
        recordingButton.isEnabled = !value
        shareButton.isEnabled = !value
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
        audioSpectrumView.animationStart(direction: .right, speed: 5, preferredColor: .green)
        recordListTableView.isUserInteractionEnabled = false
        playSelectedRecording()
    }
    
    @IBAction func didTappedShareButton(_ sender: Any) {
        // TO DO: Sharing will be implemented
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
