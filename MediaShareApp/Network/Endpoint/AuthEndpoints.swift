import Foundation

enum AuthEndpoints {
    case sendEmailVerification(body: SendVerificationRequestBody)
    case register(body: RegisterRequestBody)
    case logout(accessToken: String)
    case login(body: LoginRequestBody)
    case forgotPassword
    case verifyOTPToResetPassword
    case resetPassword
    case refreshAccessToken(refreshToken: String)
}

extension AuthEndpoints: Endpoint {
    var version: APIVersion {
        .v1
    }

    var path: String {
        switch self {
        case .sendEmailVerification:
            return "auth/emails/verify"
        case .register:
            return "auth/register"
        case .logout:
            return "auth/logout"
        case .login:
            return "auth/login"
        case .forgotPassword:
            return "auth/forgot-password"
        case .verifyOTPToResetPassword:
            return "auth/forgot-password/verify"
        case .resetPassword:
            return "auth/forgot-password/reset"
        case .refreshAccessToken:
            return "auth/tokens/refresh"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .sendEmailVerification:
            return .post
        case .register:
            return .post
        case .logout:
            return .post
        case .login:
            return .post
        case .forgotPassword:
            return .post
        case .verifyOTPToResetPassword:
            return .post
        case .resetPassword:
            return .post
        case .refreshAccessToken:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case .sendEmailVerification(let body):
            return .withParams(urlParams: nil, bodyParams: body.dictionary)
        case .register(let body):
            return .withParams(urlParams: nil, bodyParams: body.dictionary)
        case .login(let body):
            return .withParams(urlParams: nil, bodyParams: body.dictionary)
        case  .logout, .forgotPassword, .verifyOTPToResetPassword, .resetPassword, .refreshAccessToken:
            return .plain
        }
    }

    var header: HTTPHeaders? {
        var defaults = [
            "Content-Type": "application/json",
            "Accepts-Language": "en"
        ]
        
        switch self {
        case .logout(let accessToken):
            defaults["Authorization"] = "Bearer \(accessToken)"
            return defaults
        case .refreshAccessToken(let refreshToken):
            defaults["Authorization"] = "Bearer \(refreshToken)"
            return defaults
        default:
            return defaults
        }
    }

    var params: Parameters? {
        return nil
    }

    var authProtected: Bool {
        switch self {
        case .logout, .refreshAccessToken:
            return true
        default:
            return false
        }
    }
}
