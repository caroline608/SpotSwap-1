//
//  RegisterCarViewController.swift
//  SpotSwap
//
//  Created by C4Q on 3/19/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
import UIKit
import ImagePicker
import Toucan

class RegisterCarViewController: UIViewController, UIImagePickerControllerDelegate {
    // MARK: - Properties
    private let email: String
    private let password: String
    private let userName: String
    private let profileImage: UIImage
    private var imagePickerController: ImagePickerController!
    private let registerCarView = RegisterCarView()
    private let yearsSince1919: [String]
    private var vehicleYear: String
    private var selectedCarMake = ""{
        didSet{
            self.registerCarView.modelsPickerView.reloadAllComponents()
        }
    }
    private var selectedModel = ""
    private var carDict = [String:[String]](){
        didSet{
            self.registerCarView.makesPickerView.reloadAllComponents()
            guard carDict.count > 0 else{ return }
            let carDictKeys = Array(carDict.keys.sorted())
            self.registerCarView.makesPickerView.selectRow(carDictKeys.count/2, inComponent: 0, animated: true)
            self.selectedCarMake = carDictKeys[carDictKeys.count/2]
            guard let defaultModel = carDict[selectedCarMake]?.sorted().first else{return}
            self.selectedModel = defaultModel
        }
    }
    
    //MARK: Inits
    init(userName:String, email: String, password: String, profileImage: UIImage) {
        self.email = email
        self.password = password
        self.userName = userName
        self.profileImage = profileImage
        self.yearsSince1919 = DateProvider.yearsSince1919()
        self.vehicleYear = yearsSince1919.first ?? "2018"
        super.init(nibName: nil, bundle: nil)
        
    }
    // MARK: - View Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        loadCarMakes()
        setupRegisterCarView()
        loadCarMakes()
        setupImagePicker()
        registerCarView.pastelView.startAnimation()
        setupDelegatesAndDataSources()
    }
    // MARK: - Setup NavBar and Views
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
            #selector(goToMapViewController))
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    private func setupRegisterCarView(){
        view.addSubview(registerCarView)
        registerCarView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
    }
    private func setupImagePicker() {
        imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
    }
    // MARK: - Private functions
    func loadCarMakes(){
        DataBaseService.manager.retrieveAllCarMakes(completion: { (carmakesModelsDict) in
            self.carDict = carmakesModelsDict
        }) { (error) in
            Alert.present(title: "There was an error retrieving care makes", message: error.localizedDescription)
        }
    }
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc private func goToMapViewController() {
        guard selectedCarMake != "", selectedModel != "" else {
            Alert.present(title: "Please enter a valid car make and model", message: nil)
            return
        }
        
        guard let vehicleImage = registerCarView.carImageView.image , registerCarView.carImageView.image != #imageLiteral(resourceName: "defaultVehicleImage") else{
            Alert.present(title: "Please select a valid car image, so others will be able to swap easily with you", message: nil)
            return
        }
        
        let vehicleImageSize: CGSize = CGSize(width: 300, height: 300)
        guard let tocanVehicleImage = Toucan.Resize.resizeImage(vehicleImage, size: vehicleImageSize) else{
            Alert.present(title: "There was an error uploading your image please try again", message: nil)
            return
        }
        //Compress the images for the storage
        let profileImageSize: CGSize = CGSize(width: 300, height: 300)
        guard let toucanProfileImage = Toucan.Resize.resizeImage(self.profileImage, size: profileImageSize) else{
            Alert.present(title: "error uploading your image please try again", message: nil)
            return
        }
        self.registerCarView.carImageView.image = vehicleImage
        AuthenticationService.manager.createUser(email: email, password: password, completion: { (user) in
            let newCar = Car(carMake: self.selectedCarMake, carModel: self.selectedModel, carYear: self.vehicleYear)
            let newVehicleOwner = VehicleOwner(user: user, car: newCar, userName: self.userName)
            DataBaseService.manager.addNewVehicleOwner(vehicleOwner: newVehicleOwner, userID: user.uid)
            StorageService.manager.storeImage(imageType: .vehicleOwner, uid: user.uid, image: toucanProfileImage, errorHandler: { (error) in
                print(#function, error)
                Alert.present(title: "There was an error adding your images to the data base \(error.localizedDescription)", message: nil)
            })
            StorageService.manager.storeImage(imageType: .vehicleImage, uid: user.uid, image: tocanVehicleImage, errorHandler: { (error) in
                print(#function, error)
                Alert.present(title: "There was an error adding your images to the data base \(error.localizedDescription)", message: nil)
            })
            let mapViewController = ContainerViewController.storyBoardInstance()
            self.present(mapViewController, animated: true, completion: nil)
        }) { (error) in
            Alert.present(title: error.localizedDescription, message: nil)
        }
    }
    
    private func cameraButtonPressed() {
        //        open up camera and photo gallery
        present(imagePickerController, animated: true, completion: {
            self.imagePickerController.collapseGalleryView({
            })
        })
    }
    private func setupDelegatesAndDataSources(){
        registerCarView.delegate = self
        registerCarView.modelsPickerView.dataSource = self
        registerCarView.makesPickerView.dataSource = self
        registerCarView.yearPickerView.dataSource = self
        registerCarView.modelsPickerView.delegate = self
        registerCarView.makesPickerView.delegate = self
        registerCarView.yearPickerView.delegate = self
    }
    
    
    
}
//MARK: - Picker View data source
extension RegisterCarViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return carDict.keys.count
        case 1:
            return carDict[selectedCarMake]?.count ?? 0
        default :
            return yearsSince1919.count
        }
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch pickerView.tag {
//        case 0:
//            let arrayOfCarMakesNames = Array(carDict.keys)
//            return arrayOfCarMakesNames[row]
//        case 1:
//            guard let carModels = carDict[selectedCarMake]  else{return "BMX"}
//            return carModels[row]
//        default:
//            return yearsSince1919[row]
//        }
//    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch pickerView.tag {
        case 0:
            let arrayOfCarMakesNames = Array(carDict.keys.sorted())
            let attributedString = NSAttributedString(string: arrayOfCarMakesNames[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            return attributedString
        case 1:
            guard let carModels = carDict[selectedCarMake]?.sorted()  else {return nil}
            let attributedString = NSAttributedString(string: carModels[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            return attributedString
        case 2:
            return NSAttributedString(string: yearsSince1919[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        default:
            return NSAttributedString(string: "Default Value", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
    }
}
//MARK: - Picker View data source
extension RegisterCarViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            self.selectedCarMake = Array(carDict.keys.sorted())[row]
            pickerView.view(forRow: row, forComponent: component)?.backgroundColor = .white
        case 1:
            guard let carModels = carDict[selectedCarMake]?.sorted()  else{return}
            self.selectedModel = carModels[row]
        case 2:
            self.vehicleYear = yearsSince1919[row]
        default:
            return
        }
    }
}
//MARK: - Image Picker Delegates
extension RegisterCarViewController: ImagePickerDelegate {
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard !images.isEmpty else { return }
        let selectedImage = images.first!
        registerCarView.carImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        return
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.resetAssets()
        return
    }
    
}
//MARK: - RegisterCarView Delegate
extension RegisterCarViewController: RegisterCarViewDelegate{
    func changeCarImage() {
        cameraButtonPressed()
    }
    
    
}


