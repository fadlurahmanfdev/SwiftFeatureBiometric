//
//  SwiftFeatureBiometric.swift
//  SwiftFeatureBiometric
//
//  Created by Taufik Fadlurahman Fajari on 16/10/24.
//

import LocalAuthentication

public class SwiftFeatureBiometricRepositoryImpl:
    SwiftFeatureBiometricRepository
{

    init() {

    }
    let laContext: LAContext = LAContext()

    public func supportedBiometric() -> LABiometryType {
        return laContext.biometryType
    }

    public func isDeviceSupportBiometric() -> Bool {
        var supportedBiometric =
            laContext.biometryType == .faceID
            || laContext.biometryType == .touchID

        if #available(iOS 17.0, *) {
            supportedBiometric = laContext.biometryType == .opticID
        }
        return supportedBiometric
    }

    public func canAuthenticate() -> Bool {
        return
            laContext
            .canEvaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                error: nil
            )
    }

    public func isBiometricChanged(key: String) -> Bool {
        let defaults = UserDefaults.standard
        let oldDomainState = defaults.object(forKey: key) as? Data
        let domainState = laContext.evaluatedPolicyDomainState
        return domainState != oldDomainState
    }

    public func authenticate(
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
