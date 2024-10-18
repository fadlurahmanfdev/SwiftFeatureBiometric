//
//  SwiftFeatureBiometricProtocol.swift
//
//
//  Created by Taufik Fadlurahman Fajari on 16/10/24.
//

import LocalAuthentication

protocol SwiftFeatureBiometricRepository {
    func supportedBiometric() -> LABiometryType
    func isDeviceSupportBiometric() -> Bool
    func canAuthenticate() -> Bool
    func isBiometricChanged(key:String) -> Bool
    func authenticate(key:String, localizedReason:String, completion: @escaping(FeatureBiometricAuthenticationStatus) -> Void)
}
