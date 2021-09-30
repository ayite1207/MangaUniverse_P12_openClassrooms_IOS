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
    
    func testGetCharacterMangaData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.characterData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getCharacterDetailManga(idOfTheCharacter: "40882") { result in
            guard case .success(let character) = result else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            XCTAssertTrue(character.name == "Gokuu Son")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetResultMangaData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.resultsData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getSearchResultManga(str: "dragon ball"){ result in
            guard case .success(let result) = result else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            XCTAssertTrue(result.results[0].title == "Dragon Ball")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetData_WhenCorrectResponseIsPassed_ThenShouldReturnSuccesCallback() {
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.topMangaDetailData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getMangaTopPopularityDetail(idOfTheManga: "13") { result in
            guard case .success(let data) = result else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            XCTAssertTrue(data.title == "One Piece")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCharactersMangaData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.charactersData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getCharactersManga(idOfTheManga: "42"){ result in
            guard case .success(let characters) = result else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            XCTAssertTrue(characters.characters[0].name == "Bulma")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGetCategoryMangaData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.topMangaPopularityData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getMangaTopPopularity(){ result in
            guard case .success(let characters) = result else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            XCTAssertTrue(characters.top[0].title == "Shingeki no Kyojin")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    
    func testGetSamouraiMangaData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let samouraiMangaRequestConstructor = RequestMangaConstructor.samouraiManga
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.samouraiMangaData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getCategoryManga(category: samouraiMangaRequestConstructor.mangaCategory, path: samouraiMangaRequestConstructor.path){ result in
            guard case .success(let mangaCategory) = result else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            XCTAssertTrue(mangaCategory.manga[0].title == "Vagabond")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
        
    func testGetParodyMangaData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let parodyMangaRequestConstructor = RequestMangaConstructor.parodyManga
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.parodyMangaData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getCategoryManga(category: parodyMangaRequestConstructor.mangaCategory, path: parodyMangaRequestConstructor.path){ result in
            guard case .success(let mangaCategory) = result else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            XCTAssertTrue(mangaCategory.manga[0].title == "One Punch-Man")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
        
    func testGetPsychologicalMangaData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let psychologicalMangaRequestConstructor = RequestMangaConstructor.psychologicalManga
        let session = FakeJikanSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.PsychologicaData))
        let requestService = JikanService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getCategoryManga(category: psychologicalMangaRequestConstructor.mangaCategory, path: psychologicalMangaRequestConstructor.path){ result in
            guard case .success(let mangaCategory) = result else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            XCTAssertTrue(mangaCategory.manga[0].title == "Berserk")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    
}
