//
//  Walkthrough.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 4/3/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation
import UIKit
class Walkthrough {
    let headerLabelText: String
    let descriptionText: String
    let tutorialImage: UIImage?
    let pageControlIndex: Int
    let isLastWalkthrough: Bool
    let gifName: String?
    init(headerLabelText: String, descriptionText: String, tutorialImage: UIImage?, pageControlIndex: Int, isLastWalkthrough: Bool, gifName: String?) {
        self.headerLabelText = headerLabelText
        self.tutorialImage = tutorialImage
        self.descriptionText = descriptionText
        self.isLastWalkthrough = isLastWalkthrough
        self.pageControlIndex = pageControlIndex
        self.gifName = gifName
    }
}

