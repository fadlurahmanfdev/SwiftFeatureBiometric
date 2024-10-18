//
//  SwiftFeatureBiometric.swift
//  SwiftFeatureBiometric
//
//  Created by Taufik Fadlurahman Fajari on 16/10/24.
//

import LocalAuthentication

class SwiftFeatureBiometricRepositoryImpl: SwiftFeatureBiometricRepository {
    let laContext: LAContext = LAContext()

    func supportedBiometric() -> LABiometryType {
        return laContext.biometryType
    }

    func isDeviceSupportBiometric() -> Bool {
        var supportedBiometric =
            laContext.biometryType == .faceID
            || laContext.biometryType == .touchID

        if #available(iOS 17.0, *) {
            supportedBiometric = laContext.biometryType == .opticID
        }
        return supportedBiometric
    }

    func canAuthenticate() -> Bool {
        return
            laContext
            .canEvaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                error: nil
            )
    }

    func isBiometricChanged(key: String) -> Bool {
        let defaults = UserDefaults.standard
        let oldDomainState = defaults.object(forKey: key) as? Data
        let domainState = laContext.evaluatedPolicyDomainState
        return domainState != oldDomainState
    }

    func authenticate(
        key: String, localizedReason: String,
        completion: @escaping (FeatureBiometricAuthenticationStatus) -> Void
    ) {
        let defaults = UserDefaults.standard
        let domainState = laContext.evaluatedPolicyDomainState
        laContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: localizedReason
        ) { success, error in
            if success {
                defaults.set(domainState, forKey: key)
                completion(.success)
            } else {
                completion(.canceled)
            }

        }
    }
}
