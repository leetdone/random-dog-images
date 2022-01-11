//
//  ViewController.swift
//  mRandog
//
//  Created by lindong on 1/8/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var pickView: UIPickerView!
    
    //a list containing the names of breeds
    var breeds = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickView.delegate = self
        DogAPI.requestAllBreeds { list, error in
            self.breeds = list ?? ["noListInfo"]//get the list of all breeds
        }
    }
    
    //request an image by an url
    func handleRandomImageResponse(imageData: DogImage?, error: Error?){
        guard let imageURL = URL(string: imageData?.message ?? "") else{return}
        DogAPI.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
    }
    
    //load image in the image view
    func handleImageFileResponse(image: UIImage?, error: Error?){
        DispatchQueue.main.async {
            self.dogImage.image = image
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogAPI.requestRandomImage(breed: breeds[row],completionHandler: handleRandomImageResponse(imageData:error:))
    }
    
}



