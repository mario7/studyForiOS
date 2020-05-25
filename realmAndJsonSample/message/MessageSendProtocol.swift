//
//  MessageSendProtocol.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/05/23.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import UIKit

protocol MessageSendProtocol {
    func sendImageMessage(image: UIImage?)
    func getImageMessage(result: @escaping (Bool, UIImage?) -> Void)
}
extension MessageSendProtocol {
    
    func sendImageMessage(image: UIImage?) {
        
    }
    
    func getImageMessage(result: @escaping (Bool, UIImage?) -> Void) {
        result(false, nil)
    }
}
