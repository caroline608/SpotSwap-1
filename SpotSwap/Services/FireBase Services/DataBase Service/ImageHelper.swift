//
//  ImageHelper.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/22/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    private init() {}
    static let manager = ImageHelper()
    func getImage(from urlStr: String,
                  completionHandler: @escaping (UIImage) -> Void,
                  errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL)
            return
        }
        if let sotredImageInCache = NSCacheHelper.manager.getImage(with: urlStr){
            completionHandler(sotredImageInCache)
            return
        }
        let completion = {(data: Data) in
            if let onlineImage = UIImage(data: data) {
                NSCacheHelper.manager.addImage(with: urlStr, and: onlineImage)
                completionHandler(onlineImage)
            } else {
                errorHandler(AppError.badData)
            }
        }

        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}

class NSCacheHelper {
    private init() {}
    static let manager = NSCacheHelper()
    private var myCache = NSCache<NSString, UIImage>()
    func addImage(with urlStr: String, and image: UIImage) {
        myCache.setObject(image, forKey: urlStr as NSString)
    }
    func getImage(with urlStr: String) -> UIImage? {
        return myCache.object(forKey: urlStr as NSString)
    }
}
