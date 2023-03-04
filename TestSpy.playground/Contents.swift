import UIKit
import XCTest

struct User {
    let email: String
    let invitationCode: String?
}
protocol UserServices {
    func signup(with mail: String, password: String, completion: (Result<User, Error>) -> Void)
    func validateCode(code: String, user: User, completion: @escaping(Result<User, Error>) -> Void)
}

class UserUseCase {
    private let userServices: UserServices
    
    // 1
    init(userServices: UserServices) {
        self.userServices = userServices
    }
    
    // 2
    func signupWithReferralCode(email: String, password: String, referral: String, completion: @escaping (User) -> Void) {
        userServices.signup(with: email, password: password) { result in
            switch result {
            case .success(let user):
                self.userServices.validateCode(code: referral, user: user) { result in
                   if let updatedUser = try? result.get() {
                       completion(updatedUser)
                   }
                }
            case .failure:
                break
            }

        }

    }
}
private class UserServicesSpy: UserServices {
    func signup(with mail: String, password: String, completion: (Result<User, Error>) -> Void) {
        
    }
    
    func validateCode(code: String, user: User, completion: @escaping (Result<User, Error>) -> Void) {
        
    }
}

class UserUseCaseTests: XCTestCase {
    private func makeSUT() -> (UserUseCase, UserServices ) {
        let userServices = UserServicesSpy()
        let sut = UserUseCase(userServices: userServices)
        return (sut, userServices)
    }
}
