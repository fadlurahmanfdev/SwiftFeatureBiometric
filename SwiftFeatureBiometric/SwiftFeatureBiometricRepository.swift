//
//  SwiftFeatureBiometricProtocol.swift
//
//
//  Created by Taufik Fadlurahman Fajari on 16/10/24.
//

import LocalAuthentication

public protocol SwiftFeatureBiometricRepository {
    func supportedBiometric() -> LABiometryType
    func isDeviceSupportBiometric() -> Bool
    func canAuthenticate(policy: LAPolicy) -> Bool
    func isBiometricChanged(key: String) -> Bool
    func authenticate(
        key: String,
        policy: LAPolicy,
        localizedReason: String,
        completion: @escaping (
            FeatureBiometricAuthenticationStatus
        ) -> Void
    )
}
