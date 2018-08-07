//
//  certificate.swift
//  floatingUpload
//
//  Created by Amir on 8/5/2016.
//  Copyright © 2018 uni. All rights reserved.
//

import Foundation
import Alamofire

class certificate {
    
     static func publicKey(for certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?
        
        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)
        
        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }
        
        return publicKey
    }
    
     static func pinnedKeys() -> [SecKey] {
        
        var publicKeys : [SecKey] = []
        let clientBundle: Bundle? = Bundle.main
        
        for localKey in ServerTrustPolicy.publicKeys(in: clientBundle!){
            
            publicKeys.append(localKey)
        }
        
        return publicKeys
    }
    
    static func SSLPinning(sessionManager : SessionManager){
        
        let delegate : SessionDelegate = sessionManager.delegate
        
        delegate.sessionDidReceiveChallengeWithCompletion = { session, challenge, completionHandler in
            
            guard let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 else {
                // This case will probably get handled by ATS, but still...
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("number of certs are lese than 0")
                return
            }
            
            if let serverCertificate = SecTrustGetCertificateAtIndex(trust, 0), let serverCertificateKey = publicKey(for: serverCertificate) {
                print("serverCertKey is \(serverCertificateKey)")
                print("pinn key is \(pinnedKeys())")
                if self.pinnedKeys().contains(serverCertificateKey) {
                    completionHandler(.useCredential, URLCredential(trust: trust))
                }
            }
        }
        
    }
    
}
