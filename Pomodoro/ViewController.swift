//
//  ViewController.swift
//  Pomodoro
//
//  Created by 장기화 on 2021/11/19.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureToggleButton()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch timerStatus {
        case .start, .pause:
            timerStatus = .end
            cancelButton.isEnabled = false
            setTimerInfoViewVisible(isHidden: true)
            datePicker.isHidden = false
            toggleButton.isSelected = false
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
        case .pause:
            timerStatus = .start
            toggleButton.isSelected = true
        case .end:
            timerStatus = .start
            setTimerInfoViewVisible(isHidden: false)
            datePicker.isHidden = true
            toggleButton.isSelected = true
            cancelButton.isEnabled = true
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
}

