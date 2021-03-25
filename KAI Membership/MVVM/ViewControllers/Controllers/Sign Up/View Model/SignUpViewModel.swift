//
//  SignUpViewModel.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 07/03/2021.
//

import RxSwift

class SignUpViewModel {
    
    // MARK: Properties
    private var captchaID: String = ""
    
    // MARK: Methods
    func register(captcha: String, username: String, email: String, password: String) -> Observable<AccountInfoRemote> {
        let captchaID = self.captchaID
        return Observable<AccountInfoRemote>.create { (observer) -> Disposable in
            CaptchaServices.verifyCaptcha(with: captchaID, captcha: captcha) {
                switch $0 {
                case .success:
                    AccountManagement.register(username: username, email: email, password: password) {
                        switch $0 {
                        case .success(let result):
                            observer.onNext(result)
                            observer.onCompleted()
                        case .failure:
                            observer.onError(APIErrorResult(with: .custom("🤔 Register account failure!")))
                        }
                    }
                case .failure:
                    observer.onError(APIErrorResult(with: .captcha))
                }
            }

            return Disposables.create()
        }
    }
    
    func generateCaptcha() -> Observable<URL> {
        return Observable<URL>.create { [weak self] observer -> Disposable in
            CaptchaServices.generateCaptcha {
                switch $0 {
                case .success(let result):
                    if let captchaID = result.data?.id, !captchaID.isEmpty, let url = URL(string: CaptchaServices.getCaptchaImageLink(with: captchaID)) {
                        self?.captchaID = captchaID
                        observer.onNext(url)
                        observer.onCompleted()
                    } else {
                        let error = APIErrorResult(code: "1", message: "Error generate url captcha image")
                        observer.onError(error)
                    }
                case .failure:
                    observer.onError(APIErrorResult(code: "1", message: "Error generate captcha"))
                }
            }

            return Disposables.create()
        }
    }
}
