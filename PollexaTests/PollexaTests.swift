//
//  PollexaTests.swift
//  PollexaTests
//
//  Created by Busra Ece on 27.06.2024.
//

import XCTest
@testable import Pollexa


class MockDataProvider {
    
    static func loadPostsFromMockJSON() -> [Post] {
        var posts: [Post] = []
        
        if let path = Bundle.main.path(forResource: "mockData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                posts = try JSONDecoder().decode([Post].self, from: data)
            } catch {
                fatalError("Error loading mock data: \(error.localizedDescription)")
            }
        }
        
        return posts
    }
    
    
    final class PollexaTests: XCTestCase {
   
        var mockModelView: DiscoverModelView!
        var mockPosts: [Post] = []
        
        override func setUp() {
            super.setUp()
            mockModelView = DiscoverModelView()

            mockPosts = MockDataProvider.loadPostsFromMockJSON()
            mockModelView.posts = mockPosts
        }
        
        override func tearDown() {
            mockModelView = nil
            super.tearDown()
        }
        

        
        func testFetchPosts() {
            let expectation = XCTestExpectation(description: "Fetch posts expectation")
            mockModelView.fetchPosts()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                XCTAssertEqual(self.mockModelView.posts.count, self.mockPosts.count)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 3)
        }
        
        func testPost() {
           
            let index = 0 // Assuming there's at least one post
            let post = mockModelView.post(index: index)
            XCTAssertNotNil(post)
            XCTAssertEqual(post?.id, mockPosts[index].id)
            XCTAssertEqual(post?.content, mockPosts[index].content)
        }
        
        
        func testUpdatePost() {
            
            if let updatedPost = mockPosts.first{
                mockModelView.updatePost(updatedPost)
                XCTAssertEqual(mockModelView.posts.count, mockPosts.count)
                let updatedPostInmockModelView = mockModelView.posts.first(where: { $0.id == updatedPost.id })
                XCTAssertNotNil(updatedPostInmockModelView)
                XCTAssertEqual(updatedPostInmockModelView?.content, "Updated Post")
                XCTAssertEqual(updatedPostInmockModelView?.likedCount, 120)
                XCTAssertEqual(updatedPostInmockModelView?.options[0].optionCount, 70)
                XCTAssertEqual(updatedPostInmockModelView?.options[1].optionCount, 50)
            }
            
            
        }
        
        func testRangeLeftCalculate() {
            
            let post = mockPosts[0] // Assuming there's at least one
            let result = mockModelView.rangeLeftCalculate(model: post)
        
            XCTAssertFalse(result.isEmpty)
            XCTAssertTrue(result.starts(with: "%"))
            XCTAssertEqual(result, "%60.00")
        }
        
        func testRangeRightCalculate() {
            // Given
            let post = mockPosts[1] // Assuming there's at least one
            let result = mockModelView.rangeRightCalculate(model: post)
            
            XCTAssertFalse(result.isEmpty)
            XCTAssertTrue(result.starts(with: "%"))
            XCTAssertEqual(result, "%40.00")
        }
        
        func testIndexPathForIndex() {
            let index = 0 // Assuming there's at least one post
            let indexPath = mockModelView.indexPath(forIndex: index)
            XCTAssertNotNil(indexPath)
            XCTAssertEqual(indexPath?.item, index)
            XCTAssertEqual(indexPath?.section, 0)
        }
        
    }
    
}
