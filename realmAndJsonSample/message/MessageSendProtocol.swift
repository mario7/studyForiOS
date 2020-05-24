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
    func getImageMessage(result: @escaping (Bool, String?) -> Void)
}
extension MessageSendProtocol {
    func getImageMessage(result: @escaping (Bool, String?) -> Void) {
        result(false, nil)
    }
}
