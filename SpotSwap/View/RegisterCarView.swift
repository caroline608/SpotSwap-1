//
//  RegisterCarView.swift
//  SpotSwap
//
//  Created by C4Q on 3/16/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import UIKit
import SnapKit
import Pastel
protocol RegisterCarViewDelegate: class {
    func changeCarImage()
}
class RegisterCarView: UIView, UIGestureRecognizerDelegate {
    
    lazy var pastelView: PastelView = {
        let pastelView = PastelView()
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        // Custom Duration
        pastelView.animationDuration = 3.0
        // Custom Color
        pastelView.setColors([Stylesheet.Colors.BlueMain,
                              Stylesheet.Colors.GrayMain,
                              Stylesheet.Colors.LightGray,
                              Stylesheet.Colors.OrangeMain,
                              Stylesheet.Colors.PinkMain,
                              Stylesheet.Colors.OrangeMain])
        return pastelView
    }()
    lazy var carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "defaultVehicleImage")
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(changeCarImage))
        tabGesture.delegate = self
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tabGesture)
        return imageView
    }()
    
    lazy var makeLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Make"
        label.font = UIFont(name: Stylesheet.Fonts.Bold, size: 25)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    lazy var makesPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 0
        return picker
    }()
    
    
    lazy var modelLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Model"
        label.font = UIFont(name: Stylesheet.Fonts.Bold, size: 25)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var modelsPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 1
        return picker
    }()
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Year"
        label.font = UIFont(name: Stylesheet.Fonts.Bold, size: 25)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    lazy var yearPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 2
        return picker
    }()
    
    
    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus-button"), for: .normal)
        button.addTarget(self, action: #selector(changeCarImage), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    //MARK: - Delegates
    weak var delegate: RegisterCarViewDelegate?
    
    
    override func layoutSubviews() {
        // here you get the actual frame size of the elements before getting
        // laid out on screen
        super.layoutSubviews()
        carImageView.layer.cornerRadius = carImageView.bounds.width/2.0
        carImageView.layer.masksToBounds = true
        carImageView.layer.borderColor = Stylesheet.Colors.PinkMain.cgColor
        carImageView.layer.borderWidth = 4
    }
    
    private func setupViews() {
        setupPastelView()
        setupCarImage()
        setupAddImageButton()
        setupMakeLabel()
        setupMakePickerView()
        setupModelLabel()
        setupModelPickerView()
        setupYearLabel()
        setupYearPickerView()
        
    }
    private func setupPastelView() {
        addSubview(pastelView)
        pastelView.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
    }
    private func setupCarImage() {
        addSubview(carImageView)
        carImageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(snp.width).multipliedBy(0.40)
            make.height.equalTo(carImageView.snp.width)
        }
    }
    
    private func setupAddImageButton(){
        addSubview(addImageButton)
        addImageButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(carImageView.snp.right)
            make.top.equalTo(carImageView.snp.top).offset(5)
            make.width.height.equalTo(carImageView.snp.width).multipliedBy(0.20)
        }
    }
    
    private func setupMakeLabel() {
        addSubview(makeLabel)
        makeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(carImageView.snp.bottom).offset(10)
            make.left.equalTo(snp.left).offset(40)
        }
    }
    private func setupMakePickerView(){
        addSubview(makesPickerView)
        makesPickerView.snp.makeConstraints { (make) in
            make.top.equalTo(makeLabel.snp.bottom)
            make.width.equalTo(snp.width).multipliedBy(0.85)
            make.height.equalTo(snp.height).multipliedBy(0.15)
            make.centerX.equalTo(snp.centerX)
        }
    }
    private func setupModelLabel() {
        addSubview(modelLabel)
        modelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(makesPickerView.snp.bottom)
            make.left.equalTo(snp.left).offset(40)
        }
    }
    private func setupModelPickerView(){
        addSubview(modelsPickerView)
        modelsPickerView.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(modelLabel.snp.bottom)
            make.width.equalTo(snp.width).multipliedBy(0.85)
            make.height.equalTo(snp.height).multipliedBy(0.15)
        }
    }
    private func setupYearLabel() {
        addSubview(yearLabel)
        yearLabel.snp.makeConstraints { (make) in
            make.top.equalTo(modelsPickerView.snp.bottom)
            make.left.equalTo(snp.left).offset(40)
        }
    }
    private func setupYearPickerView(){
        addSubview(yearPickerView)
        yearPickerView.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(yearLabel.snp.bottom)
            make.width.equalTo(snp.width).multipliedBy(0.85)
            make.height.equalTo(snp.height).multipliedBy(0.15)
        }
    }
    
    //MARK: - Actions
    @objc func changeCarImage(){
        self.delegate?.changeCarImage()
    }
    
    
}

