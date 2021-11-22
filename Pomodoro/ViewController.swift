//
//  ViewController.swift
//  Pomodoro
//
//  Created by 장기화 on 2021/11/19.
//

import UIKit
import AudioToolbox

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var toggleButton: UIButton!
    
    var duration = 60
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureToggleButton()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch timerStatus {
        case .start, .pause:
            stopTimer()
        default:
            break
        }
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        duration = Int(datePicker.countDownDuration)
        
        switch timerStatus {
        case .start:
            timerStatus = .pause
            toggleButton.isSelected = false
            timer?.suspend()
        case .pause:
            timerStatus = .start
            toggleButton.isSelected = true
            timer?.resume()
        case .end:
            timerStatus = .start
            setTimerInfoViewVisible(isHidden: false)
            datePicker.isHidden = true
            toggleButton.isSelected = true
            cancelButton.isEnabled = true
            currentSeconds = duration
            startTimer()
        }
    }
    
    func setTimerInfoViewVisible(isHidden: Bool) {
        timerLabel.isHidden = isHidden
        progressView.isHidden = isHidden
    }
    
    func configureToggleButton() {
        toggleButton.setTitle("시작", for: .normal)
        toggleButton.setTitle("일시정지", for: .selected)
    }
    
    func startTimer() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            timer?.schedule(deadline: .now(), repeating: 1)
            timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self.currentSeconds -= 1
                let hour = self.currentSeconds / 3600
                let minute = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minute, seconds)
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                debugPrint(self.progressView.progress)
                
                if self.currentSeconds <= 0 {
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)
                }
            })
            timer?.resume()
        }
    }
    
    func stopTimer() {
        if timerStatus == .pause {
            timer?.resume()
        }
        timerStatus = .end
        cancelButton.isEnabled = false
        setTimerInfoViewVisible(isHidden: true)
        datePicker.isHidden = false
        toggleButton.isSelected = false
        timer?.cancel()
        timer = nil
    }
}

