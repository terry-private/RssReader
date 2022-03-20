//
//  LoginModelTests.swift
//  RssReaderTests
//
//  Created by 若江照仁 on 2022/03/19.
//

import XCTest
@testable import RssReader

private var testCounter = 1
class LoginModelTests: XCTestCase {
    class UserConfigMock: UserConfigProtocol {
        var loginType: String?
        var userID: String?
        var password: String?
        var photoURL: URL?
        var displayName: String?
        var latestLoginDate: Date?
        var isRemoved = false
        init(loginType: String? = nil, latestLoginDate: Date? = nil) {
            self.loginType = loginType
            self.latestLoginDate = latestLoginDate
        }
        func removeUser() {
            isRemoved = true
        }
    }
    func testToLogoutAlert() throws {
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+4) LoginModel.toLogoutAlert logintype: line") { _ in
            let userConfig = UserConfigMock(loginType: "line", latestLoginDate: Date.current())
            let loginModel = LoginModel(userConfig: userConfig)
            let mock = LoginDelegateMock()
            loginModel.toLogoutAlert(view: mock)
            
            // test01 ちゃんとview.presentが呼ばれているかどうか
            XCTAssertNotNil(mock.presentedResult)
            let alert = mock.presentedResult?.0 as? UIAlertController
            // test02 presentでUIAlertControllerを表示しているかどうか
            XCTAssertNotNil(alert)
            
            // test03 presentで表示されるアラートのタイトルがログアウトかどうか
            XCTAssertEqual(alert?.title, "ログアウト")
            
            // test04 presentで表示されるアラートのメッセージがログアウトしますか？かどうか
            XCTAssertEqual(alert?.message, "ログアウトしますか？")
            
            // test05 presentでアニメーションするかどうか
            XCTAssertEqual(mock.presentedResult?.1, true)
            
            testCounter+=5
        }
        
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+1) LoginModel.toLogoutAlert logintype: test") { _ in
            let userConfig = UserConfigMock(loginType: "test")
            let loginModel = LoginModel(userConfig: userConfig)
            let mock = LoginDelegateMock()
            loginModel.toLogoutAlert(view: mock)
            
            // test06 ちゃんとremoveUserが呼ばれているかどうか
            XCTAssertTrue(userConfig.isRemoved)
            
            // test07 ちゃんとdidLogoutが呼ばれているかどうか
            XCTAssertTrue(mock.isLogoutCompleted)
            
            testCounter += 2
        }
    }
    
    func testAutoLogin() throws {
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+2) LoginModel.autoLogin logintype: line　テストでは認証は失敗になるので認証失敗時のテスト") { _ in
            let userConfig = UserConfigMock(loginType: "line")
            let loginModel = LoginModel(userConfig: userConfig)
            let mock = LoginDelegateMock()
            loginModel.autoLogin(autoLoginDelegate: mock)
            
            // test08 ちゃんとdidAutoLoginが呼ばれているかどうか
            XCTAssertNotNil(mock.autoLoginResult)
            
            // test09 isSuccessがfalseかどうか
            XCTAssertEqual(mock.autoLoginResult, false)
            
            // test10 ちゃんとremoveUserが呼ばれているかどうか
            XCTAssertTrue(userConfig.isRemoved)
            
            testCounter += 3
        }
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+2) LoginModel.autoLogin logintype: mail, latestLoginDate: 昨日") { _ in
            let yesterday = Date().addingTimeInterval(-60*60*24)
            let userConfig = UserConfigMock(loginType: "mail", latestLoginDate: yesterday)
            let loginModel = LoginModel(userConfig: userConfig)
            let mock = LoginDelegateMock()
            loginModel.autoLogin(autoLoginDelegate: mock)
            
            // test11 latestLoginDateが更新されているかどうか
            XCTAssertEqual(userConfig.latestLoginDate?.longDate(), Date.current().longDate())
            
            // test12 ちゃんとdidAutoLoginが呼ばれているかどうか
            XCTAssertNotNil(mock.autoLoginResult)
            
            // test13 isSuccessがtrueかどうか
            XCTAssertEqual(mock.autoLoginResult, true)
            testCounter += 3
        }
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+1) LoginModel.autoLogin logintype: mail, latestLoginDate: 一週間前") { _ in
            let lastWeek = Date().addingTimeInterval(-60*60*24*7)
            let userConfig = UserConfigMock(loginType: "mail", latestLoginDate: lastWeek)
            let loginModel = LoginModel(userConfig: userConfig)
            let mock = LoginDelegateMock()
            loginModel.autoLogin(autoLoginDelegate: mock)
            
            // test14 ちゃんとdidAutoLoginが呼ばれているかどうか
            XCTAssertNotNil(mock.autoLoginResult)
            
            // test15 isSuccessがfalseかどうか
            XCTAssertEqual(mock.autoLoginResult, false)
            
            testCounter += 2
        }
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+1) LoginModel.autoLogin logintype: test") { _ in
            let userConfig = UserConfigMock(loginType: "test")
            let loginModel = LoginModel(userConfig: userConfig)
            let mock = LoginDelegateMock()
            loginModel.autoLogin(autoLoginDelegate: mock)
            
            // test16 ちゃんとdidAutoLoginが呼ばれているかどうか
            XCTAssertNotNil(mock.autoLoginResult)
            
            // test17 isSuccessがfalseかどうか
            XCTAssertEqual(mock.autoLoginResult, false)
            
            testCounter += 2
        }
    }
    
    func testSetUserConfig() throws {
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+3) LoginModel.setUserConfig") { _ in
            let userConfig = UserConfigMock()
            let loginModel = LoginModel(userConfig: userConfig)
            let testID = "ok"
            let testURL = URL(string: "http://test.com")
            let testName = "test_account"
            loginModel.setUserConfig(userID: testID, photoURL: testURL, displayName: testName)
            
            // test18 userIDが更新されているかどうか
            XCTAssertEqual(loginModel.userConfig.userID, testID)
            
            // test19 photoURLが更新されているかどうか
            XCTAssertEqual(loginModel.userConfig.photoURL, testURL)
            
            // test20 displayNameが更新されているかどうか
            XCTAssertEqual(loginModel.userConfig.displayName, testName)
            
            // test21 latestLoginDateが更新されているかどうか
            XCTAssertEqual(loginModel.userConfig.latestLoginDate?.longDate(), Date.current().longDate())
            
            testCounter += 4
        }
    }
}
