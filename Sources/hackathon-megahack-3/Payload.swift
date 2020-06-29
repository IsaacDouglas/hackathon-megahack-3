//
//  Payload.swift
//  hackathon-megahack-3
//
//  Created by Isaac Douglas on 29/06/20.
//

import Foundation
import ControllerSwift

struct Payload: PayloadProtocol {
    public var sub: Int
    public var exp: CLong
    public var iat: CLong
    
    func reload() -> Payload {
        let exp = self.exp + TimeIntervalType.minutes(10).totalSeconds
        return .init(sub: self.sub, exp: exp, iat: self.iat)
    }
}
