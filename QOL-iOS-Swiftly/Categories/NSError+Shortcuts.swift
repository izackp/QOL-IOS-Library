//
//  NSError+Shortcuts.swift
//  QOL-iOS-Library
//
//  Created by Isaac Paul on 9/17/19.
//  Copyright © 2019 Isaac Paul. All rights reserved.
//

import Foundation
import Foundation.FoundationErrors

public extension NSError {
    
    func isFileError() -> Bool {
        return code >= NSFileErrorMinimum && code <= NSFileErrorMaximum
    }
    
    func customerDesc() -> String {
        switch code {
        case NSFileWriteUnknownError:
            return "Oh no! We are unable to save data to this device. (Unknown Error)"
        case NSFileWriteOutOfSpaceError:
            return "Oh no! You may be running out of storage space on this device.  Please free up some space!"
        case NSFileWriteVolumeReadOnlyError: fallthrough
        case NSFileWriteNoPermissionError: fallthrough
        case NSFileWriteInvalidFileNameError: fallthrough
        case NSFileWriteFileExistsError: fallthrough
        case NSFileWriteInapplicableStringEncodingError: fallthrough
        case NSFileWriteUnsupportedSchemeError: fallthrough
        default:
            return localizedDescription
        }
    }
    
    static func localizedError<Subject>(subject: Subject, _ errorDesc:String, code:Int) -> NSError {
        let domain = String(describing: subject)
        return NSError.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey:errorDesc])
    }
}
