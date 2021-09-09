//
//  JikanServiceTest.swift
//  MangaUniverTests
//
//  Created by ayite on 04/09/2021.
//

import Foundation
import XCTest
@testable import MangaUniver

class RequestServiceTests: XCTestCase {

    func testGetData_WhenNoDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: nil, data: nil))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getCategoryManga(category: "12", path: "path/path") { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with no data failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetData_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getMangaTopPopularityDetail(idOfTheManga: "13") { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with incorrect response failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
////
    func testGetData_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getMangaTopPopularity { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with undecodable data failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getMangaTopPopularity { result in
            guard case .success(let data) = result else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            XCTAssertTrue(data.top[0].title == "Shingeki no Kyojin")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
}