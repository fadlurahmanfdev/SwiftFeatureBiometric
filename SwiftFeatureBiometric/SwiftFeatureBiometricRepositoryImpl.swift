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

    public init() {}

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

    public func canAuthenticate(policy: LAPolicy) -> Bool {
        return LAContext().canEvaluatePolicy(
            policy,
            error: nil
        )
    }

    public func isBiometricChanged(key: String) -> Bool {
        let defaults = UserDefaults.standard
        let oldDomainState = defaults.object(forKey: key) as? Data
        let domainState = LAContext().evaluatedPolicyDomainState
        return domainState != oldDomainState
    }

    public func authenticate(
        key: String,
        policy: LAPolicy,
        localizedReason: String,
        completion: @escaping (FeatureBiometricAuthenticationStatus) -> Void
    ) {
        let context = LAContext()
        let defaults = UserDefaults.standard
        context.evaluatePolicy(
            policy,
            localizedReason: localizedReason
        ) { success, error in
            if success {
                let domainState = context.evaluatedPolicyDomainState
                defaults.set(domainState, forKey: key)
                completion(
                    .success(
                        encodedDomainState: domainState?.base64EncodedString()))
            } else {
                completion(.canceled)
            }

        }
    }
}
