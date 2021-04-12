//
//  LoginViewTests.swift
//  RssReaderTests
//
//  Created by 若江照仁 on 2021/04/05.
//

import XCTest
@testable import RssReader

class LoginViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidId_returnNil() throws {
        let testLoginView = LoginViewController()
        let testCases = [
            "12345678", // 数字8文字
            "abcdefjh", // 英字8文字
            "123456789012", // 数字12文字
            "abcdefghijkl", // 英字12文字
            "Aa10Zad8D3" // ランダム10文字
        ]
        for testCase in testCases {
            let testReturn: String? = testLoginView.validId(uid: testCase)
            XCTAssertEqual(testReturn, nil)
        }
    }
    
    // 8文字で英数字以外を含むケース
    func testValidId_returnAlphaNumericError() throws {
        let testLoginView = LoginViewController()
        let sevenString = "1234567"
        var testCases = [String]()
        let testCasesAdds = [
            "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", "¥", "|", "`", "~", "[", "{", "}" , ";", ":", "'", "\"", ",", "<", ".", ">", "/", "?", "\\",
            "１", // 全角
            "Ⅳ" // ギリシャ数字
        ]
        for add in testCasesAdds {
            testCases.append(sevenString + add)
        }
        for testCase in testCases {
            let testReturn: String? = testLoginView.validId(uid: testCase)
            XCTAssertEqual(testReturn, "ログインIDは英数字のみです。")
        }
    }
    
    // 8~12文字ではない文字列ケース
    func testValidId_returnCountError() throws {
        let testLoginView = LoginViewController()
        let testCases = [
            "", // 数字0文字
            "1234567", // 7文字
            "1234567890123", // 13文字
            "!", // 記号1文字　これはエラーメッセージはカウントエラーを優先するため英数字エラーメッセージは出ないことを確認するためのテストケース
        ]
        for testCase in testCases {
            let testReturn: String? = testLoginView.validId(uid: testCase)
            XCTAssertEqual(testReturn, "ログインIDは8〜12文字です。")
        }
    }

}
