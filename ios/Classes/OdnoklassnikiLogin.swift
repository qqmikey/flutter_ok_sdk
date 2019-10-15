//
//  OdnoklassnikiLogin.swift
//  FlutterOKSDK
//
//  Created by Mikhail Rymarev on 16.08.17.
//  Copyright © 2017 Mikhail Rymarev. All rights reserved.
//

import Foundation
import SafariServices

@available(iOS 9.0, *)
class OKLogin {
    static var appId = "1259574528"
    static var secret = "EA3FC589629C4FEB4E444DB2"

    static var cb: ((Any?, String?) -> ())? = nil
    static var vc: OKLoginViewController? = nil
    
    static func login(parent: UIViewController, cb: ((Any?, String?) -> ())?=nil) {
        let vc = OKLoginViewController(url: URL(string: "https://connect.ok.ru/oauth/authorize?client_id=\(appId)&scope=VALUABLE_ACCESS;LONG_ACCESS_TOKEN&response_type=token&redirect_uri=ok\(appId)://authorize&layout=m&state=odnoklassniki")!)
        self.cb = cb
        self.vc = vc
        vc.cb = cb
        parent.present(vc, animated: true, completion: nil)
    }
    
    static func processOpen(_ passedUrl: URL!, _ sourceApplication: String! = "") {
        if passedUrl.scheme == "ok\(OKLogin.appId)" {
            if let url = URL(string: passedUrl.absoluteString.replacingOccurrences(of: "#", with: "?", options: .literal, range: nil)), let accessToken = url.getQueryStringParameter(param: "access_token"), let sessionSecret = url.getQueryStringParameter(param: "session_secret_key") {
                let token = OKToken(tokenString: accessToken, sessionSecret: sessionSecret)
                self.cb?(token, nil)
                self.vc?.dismiss(animated: true, completion: nil)
            } else {
                self.cb?(nil, "OK login error")
                self.vc?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

struct OKToken {
    var tokenString: String
    var sessionSecret: String
}

@available(iOS 9.0, *)
class OKLoginViewController: SFSafariViewController, SFSafariViewControllerDelegate {
    var cb: ((Any?, String?) -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.cb?(nil, "dissmiss")
        self.dismiss(animated: true, completion: nil)
    }
}

extension URL {
    func getQueryStringParameter(param: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
