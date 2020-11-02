//
//  Track Array Extension.swift
//  
//
//  Created by Aoikazto on 2020/10/27.
//

import Foundation


extension Array {
    func index(of: Int) -> Element? {
        if 0 <= of && of < self.count {
            return self[of]
        }
        else {
            return nil
        }
    }
}
