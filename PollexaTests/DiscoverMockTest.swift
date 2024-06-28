import XCTest
@testable import Pollexa

final class DiscoverMockTest: XCTestCase {
    
    var mockModelView: DiscoverModelView!
    var mockPosts: [Post] = []
    private let postProvider = PostProvider.shared
    
    override func setUp() {
        super.setUp()
        mockModelView = DiscoverModelView()
        
        // Fetch mock posts using PostProvider
        let expectation = XCTestExpectation(description: "Fetch posts expectation")
        postProvider.fetchAll { result in
            switch result {
            case .success(let posts):
                self.mockPosts = posts
                self.mockModelView.posts = posts
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error fetching posts: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 5) 
    }
    
    override func tearDown() {
        mockModelView = nil
        super.tearDown()
    }
    
    func testFetchPosts() {
        XCTAssertEqual(mockModelView.posts.count, mockPosts.count)
    }
    
    func testPost() {
        let index = 0 // Assuming there's at least one post
        let post = mockModelView.post(index: index)
        XCTAssertNotNil(post)
        XCTAssertEqual(post?.id, mockPosts[index].id)
        XCTAssertEqual(post?.content, mockPosts[index].content)
    }
    
    func testUpdatePost() {
        if let updatedPost = mockPosts.first {
            mockModelView.updatePost(updatedPost)
            XCTAssertEqual(mockModelView.posts.count, mockPosts.count)
            let updatedPostInMockModelView = mockModelView.posts.first(where: { $0.id == updatedPost.id })
            XCTAssertNotNil(updatedPostInMockModelView)
            XCTAssertEqual(updatedPostInMockModelView?.content, "Which dessert should I serve at my party?")
            XCTAssertEqual(updatedPostInMockModelView?.likedCount, 1)
            XCTAssertEqual(updatedPostInMockModelView?.options[0].optionCount, 1)
            XCTAssertEqual(updatedPostInMockModelView?.options[1].optionCount, 0)
        }
    }
    
    func testRangeLeftCalculate() {
        let post = mockPosts[0] // Assuming there's at least one post
        let result = mockModelView.rangeLeftCalculate(model: post)
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.starts(with: "%"))
        XCTAssertEqual(result, "%100.00")
    }
    
    func testRangeRightCalculate() {
        let post = mockPosts[1] // Assuming there's at least two posts
        let result = mockModelView.rangeRightCalculate(model: post)
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.starts(with: "%"))
        XCTAssertEqual(result, "%nan")
    }
    
    func testIndexPathForIndex() {
        let index = 0 // Assuming there's at least one post
        let indexPath = mockModelView.indexPath(forIndex: index)
        XCTAssertNotNil(indexPath)
        XCTAssertEqual(indexPath?.item, index)
        XCTAssertEqual(indexPath?.section, 0)
    }
}
