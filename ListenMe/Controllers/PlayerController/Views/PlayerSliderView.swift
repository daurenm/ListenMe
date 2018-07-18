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
        sl.tintColor = .iconTint
        sl.maximumTrackTintColor = UIColor.iconTint.withAlphaComponent(0.25)
        sl.setThumbImage(#imageLiteral(resourceName: "slider_thumb").withTintColor(.iconTint), for: .normal)
        sl.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return sl
    }()
    
    lazy var curTimeLabel: Label = {
        let label = Label(font: UIFont.systemFont(ofSize: 13), textColor: .passiveText)
        updateTime(0, label: label)
        return label
    }()
    
    lazy var timeLeftLabel: Label = {
        let label = Label(font: UIFont.systemFont(ofSize: 13), textColor: .passiveText)
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
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension PlayerSliderView {
    func updateTime(_ time: Int, label: Label) {
        let text = time.asTrackDurationFormat
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
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translationX = gesture.translation(in: slider).x
        let add = Float(translationX / slider.frame.width) * slider.maximumValue
        let value = slider.value + add
        slider.setValue(value, animated: false)
        gesture.setTranslation(.zero, in: slider)

        sliderValueDidChange()
    }
}
