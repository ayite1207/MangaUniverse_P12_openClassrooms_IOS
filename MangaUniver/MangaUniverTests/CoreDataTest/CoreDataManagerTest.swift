//
//  CoreDataManagerTest.swift
//  MangaUniverTests
//
//  Created by ayite on 04/09/2021.
//

@testable import MangaUniver
import XCTest

class CoreDataManagerTest: XCTestCase {

    // MARK: - Properties

    var coreDataMangaCollection: MockCoreDataMangaCollectionTest!
    var coreDataManager: CoreDataManager!

    //MARK: - Tests Life Cycle

    override func setUp() {
        super.setUp()
        coreDataMangaCollection = MockCoreDataMangaCollectionTest()
        coreDataManager = CoreDataManager(coreDataMangaCollection: coreDataMangaCollection)
    }

    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataMangaCollection = nil
    }
    
    

    // MARK: - Tests

    func testAddTeskMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        let data = Data()
        coreDataManager.createMangaCollection(image: data, title: "Naruto", synopsis: "Ninja Storie", volumes: 12.0, id: 123, publishingStart: "12/04/203", score: 340.0, type: "Ninja Battle", isFollowManga: true, isLibraryManga: true, numberOfManga: 3.0)
        XCTAssertTrue(!coreDataManager.mangaCollection.isEmpty)
        XCTAssertTrue(coreDataManager.mangaCollection.count == 1)
        XCTAssertTrue(coreDataManager.mangaCollection[0].title == "Naruto")
    }
    
    func testChekIfEntityExiste_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        let data = Data()
        coreDataManager.createMangaCollection(image: data, title: "Naruto", synopsis: "Ninja Storie", volumes: 12.0, id: 123, publishingStart: "12/04/203", score: 340.0, type: "Ninja Battle", isFollowManga: true, isLibraryManga: true, numberOfManga: 3.0)
        XCTAssertTrue(!coreDataManager.entityExist(title: "Naruto"))
    }

    func testDeleteTeskMethods_WhenAnEntityIsdeleted_ThenShouldBeCorrectlySaved() {
        let data = Data()
        coreDataManager.createMangaCollection(image: data, title: "Naruto", synopsis: "Ninja Storie", volumes: 12.0, id: 123, publishingStart: "12/04/203", score: 340.0, type: "Ninja Battle", isFollowManga: true, isLibraryManga: true, numberOfManga: 3.0)
        coreDataManager.deleteMangaCollection(title: "Naruto")
        XCTAssertTrue(coreDataManager.mangaCollection.isEmpty)
    }

}
