//
//  PlayerSliderView.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/3/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy

class PlayerSliderView: UIView {
    
    // MARK: - Public API
    func prepareToPlay(maximumValue: Int) {
        slider.maximumValue = Float(maximumValue)
        slider.value = 0
        sliderValueDidChange()
    }

    func timeDidChange(_ time: Int) {
        updateTime(time, label: curTimeLabel)
        updateTimeLeft(curTime: time, label: timeLeftLabel)
        updateSlider(with: time)
    }
    
    // MARK: - Properties
    var didSeek: ((Int) -> ())!
    
    // MARK: - Views
    lazy var slider: UISlider = {
        let sl = UISlider()
        sl.tintColor = .white
        sl.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.25)
        sl.setThumbImage(#imageLiteral(resourceName: "slider_thumb"), for: .normal)
        sl.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return sl
    }()
    
    lazy var curTimeLabel: Label = {
        let label = Label(font: UIFont.systemFont(ofSize: 13), textColor: UIColor(r: 216, g: 216, b: 216))
        updateTime(0, label: label)
        return label
    }()
    
    lazy var timeLeftLabel: Label = {
        let label = Label(font: UIFont.systemFont(ofSize: 13), textColor: UIColor(r: 216, g: 216, b: 216))
        return label
    }()
    
    // MARK: - Lifecycle methods
    init() {
        super.init(frame: .zero)
        
        addSubview(slider)
        addSubview(curTimeLabel)
        addSubview(timeLeftLabel)
        slider.easy.layout(
            CenterY(),
            Left(), Right()
        )
        curTimeLabel.easy.layout(
            Left(), Top()
        )
        timeLeftLabel.easy.layout(
            Right(), Top()
        )
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension PlayerSliderView {
    func updateTime(_ time: Int, label: Label) {
        let minutes = time / 60
        let seconds = abs(time) % 60
        let text = String.init(format: "%02d:%02d", minutes, seconds)
        label.set(text: text)
    }
    
    func updateTimeLeft(curTime: Int, label: Label) {
        let leftTime = -(Int(slider.maximumValue) - curTime)
        updateTime(leftTime, label: timeLeftLabel)
    }
    
    func updateSlider(with time: Int) {
        slider.setValue(Float(time), animated: true)
    }
    
    @objc func sliderValueDidChange() {
        let value = Int(slider.value)
        updateTime(value, label: curTimeLabel)
        updateTimeLeft(curTime: value, label: timeLeftLabel)
        didSeek(value)
    }
}
