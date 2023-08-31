//
//  ViewController.swift
//  StopWatch
//
//  Created by Dias Zait on 31.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    //UIElements
    var timerImageView = UIImageView()
    let timerStopwatchSegmet = UISegmentedControl()
    let clockfaceLabel = UILabel()
    let pickerView = UIPickerView()
    var stopButton = UIButton()
    var pauseButton = UIButton()
    var playButton = UIButton()
    
    var hour: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var timeSec = 0
    
    var time = 0
    var counter = 1
    var pauseTime = 0
    var pauseSec = 0
    var startTime = 0
    var timer = Timer()
    var isTimeRunning = false
    
    var playButtonTouched = false
    var pauseButtonTouched = false
    var stopButtonTouched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        

        pickerView.isHidden = false
        pickerView.delegate = self
        pickerView.dataSource = self
        
        setupViews()
        setupConstraints()
    }
    func setupViews() {

        //timer image
        timerImageView.image = UIImage(systemName: "timer")
        timerImageView.tintColor = .black
        timerImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerImageView)
        
        // timer stopWatch segmented control
        timerStopwatchSegmet.insertSegment(withTitle: "Timer", at: 0, animated: false)
        timerStopwatchSegmet.insertSegment(withTitle: "Stopwatch", at: 1, animated: false)
        timerStopwatchSegmet.selectedSegmentIndex = 0
        timerStopwatchSegmet.translatesAutoresizingMaskIntoConstraints = false
        timerStopwatchSegmet.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        view.addSubview(timerStopwatchSegmet)
        
        //clockface label
        clockfaceLabel.text = timeToString(timeSec: time)
        clockfaceLabel.font = UIFont.boldSystemFont(ofSize: 60)
        clockfaceLabel.textAlignment = .center
        clockfaceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clockfaceLabel)
        
        //time picker
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
        
        //stop button
        stopButton.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
        stopButton.tintColor = .black
        stopButton.contentMode = .scaleToFill
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.addTarget(self, action: #selector(stop), for: .touchDown)
        view.addSubview(stopButton)
        
        //pause button
        pauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        pauseButton.tintColor = .black
        pauseButton.contentMode = .scaleToFill
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.addTarget(self, action: #selector(pause), for: .touchDown)
        view.addSubview(pauseButton)
        
        //play button
        playButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        playButton.tintColor = .black
        playButton.contentMode = .scaleToFill
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(start), for: .touchDown)
        view.addSubview(playButton)

}
    func setupConstraints() {
        //timer image
        NSLayoutConstraint.activate([
            timerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            timerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerImageView.widthAnchor.constraint(equalToConstant: 70),
            timerImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        //segmented control
        NSLayoutConstraint.activate([
            timerStopwatchSegmet.topAnchor.constraint(equalTo: timerImageView.bottomAnchor, constant: 10),
            timerStopwatchSegmet.centerXAnchor.constraint(equalTo: timerImageView.centerXAnchor)
        ])
        
        //clockface label
        NSLayoutConstraint.activate([
            clockfaceLabel.topAnchor.constraint(equalTo: timerStopwatchSegmet.bottomAnchor, constant: 45),
            clockfaceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 45),
            clockfaceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -45)
        ])
        
        //time picker
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            pickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            pickerView.heightAnchor.constraint(equalToConstant: 170)
        ])
        
        //stop button
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 80),
            stopButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            stopButton.widthAnchor.constraint(equalToConstant: 70),
            stopButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        //pause button
        NSLayoutConstraint.activate([
            pauseButton.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor),
            pauseButton.centerYAnchor.constraint(equalTo: stopButton.centerYAnchor),
            pauseButton.widthAnchor.constraint(equalToConstant: 70),
            pauseButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        //play button
        NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: pauseButton.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70),
            playButton.widthAnchor.constraint(equalToConstant: 70),
            playButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    //convert time to String
    func timeToString(timeSec: Int) -> String {
        let sec = timeSec % 60
        let min = timeSec / 60 % 60
        let hour = timeSec / 60 / 60
        
        return String(format: "%0.2d:%0.2d:%0.2d", hour, min, sec)
    }
    
    //switch between segmented controls
   @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            timerImageView.image = UIImage(systemName: "timer")
            clean()
            counter = 1
            pickerView.isHidden = false
        }
        if sender.selectedSegmentIndex == 1 {
            timerImageView.image = UIImage(systemName: "stopwatch")
            clean()
            counter = 2
            pickerView.isHidden = true
        }
        
    }
    
    //reset elements to the initial value
    func clean() {
        timer.invalidate()
        time = 0
        timeSec = 0
        pauseTime = 0
        pauseSec = 0
        isTimeRunning = false
        
        playButtonTouched = false
        pauseButtonTouched = false
        stopButtonTouched = false
        changeButtonImagesWhenTouched()
        
        if counter == 1 {
            pickerView.selectRow(0, inComponent: 0, animated: false)
            pickerView.selectRow(0, inComponent: 1, animated: false)
            pickerView.selectRow(0, inComponent: 2, animated: false)
            pickerView.reloadAllComponents()
            pickerView.isHidden = false
        }
        
        clockfaceLabel.text = timeToString(timeSec: time)
        
    }
    
    //run timer/stopwatch
    @objc func start() {
        pickerView.isHidden = true
    
        if isTimeRunning {
            return
        }
    
        
        if counter == 1 {
            time = timeSec
            if time == 0 {
                pickerView.isHidden = false
                
                playButtonTouched = false
                pauseButtonTouched = false
                stopButtonTouched = false
                changeButtonImagesWhenTouched()
                
                return
            }
            
            if pauseTime != 0 {
                time = pauseTime
            }
            playButtonTouched = true
            pauseButtonTouched = false
            changeButtonImagesWhenTouched()
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTimer), userInfo: nil, repeats: true)
                
            } else if counter == 2 {
                
                time = 0
                if pauseSec != 0 {
                    time = pauseSec
                }
                playButtonTouched = true
                pauseButtonTouched = false
                changeButtonImagesWhenTouched()
                
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countStopwatch), userInfo: nil, repeats: true)
        }
                isTimeRunning = true
    }
    //counter of timer
    @objc func countTimer() {
        time -= 1
        clockfaceLabel.text = timeToString(timeSec: time)
        
        if time == 0 {
            timer.invalidate()
            isTimeRunning = false
            clean()
        }
    }
    //counter of stopwatch
    @objc func countStopwatch() {
        time += 1
        clockfaceLabel.text = timeToString(timeSec: time)
    }
    //pause running timer/stopwatch
    @objc func pause() {
        if isTimeRunning {
            
            if counter == 1 {
                pauseTime = time
            } else if counter == 2 {
                pauseSec = time
            }
            
            playButtonTouched = false
            pauseButtonTouched = true
            changeButtonImagesWhenTouched()
            
            timer.invalidate()
            isTimeRunning = false
        }
    }
    //stop running/paused  timer/stopwatch
    @objc func stop() {
        clean()
    }
    //change image of the touched button
    func changeButtonImagesWhenTouched() {
        if !playButtonTouched && !pauseButtonTouched && !stopButtonTouched {
            playButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            pauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            stopButton.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
        }
        if playButtonTouched {
            playButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
            pauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            stopButton.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
        }
        if pauseButtonTouched {
            playButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            pauseButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
            stopButton.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
        }
    }
}
//install pickerView and get specified time in seconds from it
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in timePicker: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1, 2:
            return 60
        default:
            return 0
        }
    }

    func timePicker(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "\(row)"
        case 2:
            return "\(row)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row
        case 1:
            minutes = row
        case 2:
            seconds = row
        default:
            break;
        }
        
        timeSec = hour * 3600 + minutes * 60 + seconds
    }
}
