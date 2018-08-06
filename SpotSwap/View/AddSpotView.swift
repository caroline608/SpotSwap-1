//
//  AddSpotView.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 4/4/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import UIKit
import Pastel
protocol AddSpotDelegate: class{
    func addSpotButtonClicked()
//    func dismisAddSpotView()
}
class AddSpotView: UIView,UIGestureRecognizerDelegate {
    lazy var layerMask: PastelView = {
        let pastelView = PastelView(frame: frame)
        pastelView.layer.opacity = 0.85
        pastelView.startPastelPoint = .topRight
        pastelView.endPastelPoint = .bottomLeft
        pastelView.animationDuration = 3.0
        pastelView.setColors([Stylesheet.Colors.GrayMain,
                              UIColor.white,
                              Stylesheet.Colors.LightGray,
                              UIColor.white,
                              Stylesheet.Colors.GrayMain,])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        tapGesture.delegate = self
        pastelView.addGestureRecognizer(tapGesture)
        return pastelView
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
        
    }()
    
    lazy var tileLabel: UILabel = {
        var label = UILabel()
        label.text = "How many minutes it will take you to get to your car ?"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var pickerView: UIPickerView = {
        var pView = UIPickerView()
        return pView
    }()
    
    lazy var swapButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.setTitle("Offer Spot", for: .normal)
        button.layer.backgroundColor = Stylesheet.Colors.BlueMain.cgColor
        button.addTarget(self, action: #selector(addSpotAction(_:)), for: .touchUpInside)
        return button
    }()
    weak var delegate: AddSpotDelegate?
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        commonInit()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        addGestureRecognizer(tapGesture)
        setupViews()
    }
    
    // MARK: - LayoutSubViews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    private func setupViews(){
        setupLayerMask()
        setupContentView()
        setupLabel()
        setupPickerView()
        setupSwapButton()
        
    }
    private func setupLayerMask(){
        addSubview(layerMask)
        layerMask.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
        layerMask.startAnimation()
    }
    
    func setupContentView() {
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(self.snp.width).multipliedBy(0.85)
            make.height.equalTo(self.snp.height).multipliedBy(0.45)
        }
    }
    
    private func setupLabel() {
        addSubview(tileLabel)
        tileLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.9)
        }
    }
    
    private func setupPickerView() {
        addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(tileLabel.snp.bottom)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.20)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.45)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
    private func setupSwapButton(){
        addSubview(swapButton)
        swapButton.snp.makeConstraints { (make) in
            //            make.top.equalTo(pickerView.snp.bottom)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.45)
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(pickerView.snp.bottom).offset(5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    //MARK: - Actions
    @objc func addSpotAction(_ sender: UIButton){
        self.delegate?.addSpotButtonClicked()
    }
    @objc func dismissView(_ sender: UIButton){
        removeFromSuperview()
    }
    
    
}




