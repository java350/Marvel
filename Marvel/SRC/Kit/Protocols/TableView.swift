//
//  TableView.swift
//  Taxikey-Passenger
//
//  Created by Volodymyr
//  Copyright © 2019 DoneIt. All rights reserved.
//

import Foundation
import UIKit

protocol SelectedCell {
    func selectedImage(_ selected: Bool) -> UIImage
}

extension SelectedCell {
    func selectedImage(_ selected: Bool) -> UIImage {
        return selected ? #imageLiteral(resourceName: "choose") : #imageLiteral(resourceName: "uchoose")
    }
}
