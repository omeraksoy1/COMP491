//
//  NewRecordingViewController.swift
//  BirdsOfIstanbul
//
//  Created by Andrew Bond on 3/27/22.
//

import UIKit
import AVFoundation
import MapKit
import FirebaseFirestore
import FirebaseStorage

typealias Record = (path: String, title: String, dataKey: String)

class NewRecordingViewController: UIViewController {
    var spectrogram: AudioSpectrogram!
    //@IBOutlet private var spectrogram: SpectrogramView!
    //@IBOutlet private weak var stackView: UIStackView!
    //@IBOutlet private weak var recordingButton: UIButton!
    //@IBOutlet private weak var playButton: UIButton!
    //@IBOutlet private weak var shareButton: UIButton!
    //@IBOutlet private weak var stopRecordButton: UIButton!
    //@IBOutlet private weak var recordListTableView: UITableView!
    
    
    /*private var recordList: [Record] = [] {
        didSet {
            recordListTableView.reloadData()
            recordListTableView.scrollToRow(at: IndexPath(row: recordList.count - 1, section: 0), at: .bottom, animated: true)
        }
    }*/
    
    var importedRecord: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spectrogram = AudioSpectrogram()
        spectrogram.contentsGravity = .resize
        view.layer.addSublayer(spectrogram)
        
        view.backgroundColor = .black
        
        spectrogram.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        spectrogram.frame = view.frame
        }
        
        override var prefersHomeIndicatorAutoHidden: Bool {
            true
        }
        
        override var prefersStatusBarHidden: Bool {
            true
        }
}
