//
//  APICallTests.swift
//  inkcluded-405
//
//  Created by Nancy on 3/11/17.
//  Copyright © 2017 Boba. All rights reserved.
//

import XCTest
import AZSClient
@testable import inkcluded_405

class APICallTests: XCTestCase {
    
    var apiCalls : APICalls!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        // mock MSClient
        class mockMSClient: MSClient {
            var table: MSTable?
            
            init(user: MSUser) {
                super.init()
                self.currentUser = user
            }
            
            func setTable(mTable: MSTable) {
                self.table = mTable
            }
            
            override func table(withName tableName: String) -> MSTable {
                return self.table!
            }
            
        }
        // mock MSUser
        class mockMSUser: MSUser {
            
        }
        // mock MSTable
        class mockMSTable: MSTable {
            
        }
        // mock azure storage account
        class mockAZSAccount: CloudStorageAccountProtocol {
            var blobStorage: BlobClientProtocol
            
            init(mBlobStorage: BlobClientProtocol) {
                self.blobStorage = mBlobStorage
            }
            
            func getBlobStorageClient() -> BlobClientProtocol {
                return self.blobStorage
            }
        }
        // mock azure blob storage
        class mockBlobStorage: BlobClientProtocol {
            func containerReference(fromName: String) -> AZSCloudBlobContainer {
                return mockBlobContainer()
            }
        }
        // mock azure blob container
        class mockBlobContainer: AZSCloudBlobContainer {
            
        }
        
        let mockClient = mockMSClient(user: mockMSUser(userId: "enrique"))
        let mockTable = mockMSTable(name: "User", client: mockClient)
        mockClient.setTable(mTable: mockTable)
        let mockBlob = mockBlobStorage()
        let mockAzsAccount = mockAZSAccount(mBlobStorage: mockBlob)
        let apiCalls = APICalls(mClient: mockClient, mAzsAccount: mockAzsAccount)
        
        
        // Testing if there are no users in the User table
        apiCalls.login(closure:
            {(userEntry) -> Void in
                XCTAssertNotNil(userEntry)
        })
    }
    
    func testFindUserByEmail() {
        // mock MSClient
        class mockMSClient: MSClient {
            var table: MSTable?
            
            init(user: MSUser) {
                super.init()
                self.currentUser = user
            }
            
            func setTable(mTable: MSTable) {
                self.table = mTable
            }
            
            override func table(withName tableName: String) -> MSTable {
                return self.table!
            }
            
        }
        
        // mock MSUser
        class mockMSUser: MSUser {
            
        }
        
        // mock error
        enum mockError: Error {
            case mockError
        }
        
        // mock MSQuery
        class mockMSQuery: MSQuery {
            
            var pred: String
            
            init(predicate: String) {
                self.pred = predicate
                super.init()
            }
            
            override func read(completion: MSReadQueryBlock?) {
                if (pred == "email == \"testnil\"") {
                    completion!(nil, mockError.mockError)
                }
                else {
                    let items = [["id" : "sid:8080", "firstName" : "Josh", "lastName" : "Choi"]]
                    XCTAssertEqual(pred, "email == \"testemail@test.com\"")
                    completion!(MSQueryResult(items: items, totalCount: 1, nextLink: nil), nil)
                }
            }
        }
        
        // mock MSTable
        class mockMSTable: MSTable {
            
            override func query(with predicate: NSPredicate) -> MSQuery {
                return mockMSQuery(predicate: predicate.predicateFormat)
            }
            
        }
        
        // mock azure storage account
        class mockAZSAccount: CloudStorageAccountProtocol {
            var blobStorage: BlobClientProtocol
            
            init(mBlobStorage: BlobClientProtocol) {
                self.blobStorage = mBlobStorage
            }
            
            func getBlobStorageClient() -> BlobClientProtocol {
                return self.blobStorage
            }
        }
        // mock azure blob storage
        class mockBlobStorage: BlobClientProtocol {
            func containerReference(fromName: String) -> AZSCloudBlobContainer {
                return mockBlobContainer()
            }
        }
        // mock azure blob container
        class mockBlobContainer: AZSCloudBlobContainer {
            
        }
        
        let mockClient = mockMSClient(user: mockMSUser(userId: "enrique"))
        let mockTable = mockMSTable(name: "User", client: mockClient)
        mockClient.setTable(mTable: mockTable)
        
        let mockBlob = mockBlobStorage()
        let mockAzsAccount = mockAZSAccount(mBlobStorage: mockBlob)
        
        let apiCalls = APICalls(mClient: mockClient, mAzsAccount: mockAzsAccount)
        
        apiCalls.findUserByEmail(email: "testnil", closure: {
            (user) in
            XCTAssertNil(user)
        })
        
        // Testing if there are no users in the User table
        apiCalls.findUserByEmail(email: "testemail@test.com", closure: {
            (user) in
                XCTAssertNotNil(user)
                XCTAssertEqual(user![0].id, "sid:8080")
                XCTAssertEqual(user![0].firstName, "Josh")
                XCTAssertEqual(user![0].lastName, "Choi")
        })
    }
    
    func testCreateGroup() {
        // mock MSClient
        class mockMSClient: MSClient {
            var tables: [String : MSTable]
            
            init(user: MSUser) {
                self.tables = [String : MSTable]()
                super.init()
                self.currentUser = user
            }
            
            func setTable(key: String, mTable: MSTable) {
                self.tables[key] = mTable
            }
            
            override func table(withName tableName: String) -> MSTable {
                return tables[tableName]!
            }
            
        }
        
        // mock MSUser
        class mockMSUser: MSUser {
            
        }
        
        // mock error
        enum mockError: Error {
            case mockError
        }
        
        // mock MSTable
        class mockMSTable: MSTable {
            
            override func insert(_ item: [AnyHashable : Any], completion: MSItemBlock?) {
                
                print(item)
                if (item["name"] != nil && item["name"] as! String == "nil") {
                    completion!(nil, mockError.mockError)
                }
                else {
                    completion!(["id" : "sid:1010"], nil)
                }
            }
        }
        
        // mock azure storage account
        class mockAZSAccount: CloudStorageAccountProtocol {
            var blobStorage: BlobClientProtocol
            
            init(mBlobStorage: BlobClientProtocol) {
                self.blobStorage = mBlobStorage
            }
            
            func getBlobStorageClient() -> BlobClientProtocol {
                return self.blobStorage
            }
        }
        // mock azure blob storage
        class mockBlobStorage: BlobClientProtocol {
            func containerReference(fromName: String) -> AZSCloudBlobContainer {
                return mockBlobContainer()
            }
        }
        // mock azure blob container
        class mockBlobContainer: AZSCloudBlobContainer {
            
        }
        
        let mockClient = mockMSClient(user: mockMSUser(userId: "enrique"))
        let mockGroupTable = mockMSTable(name: "Group", client: mockClient)
        let mockGXUTable = mockMSTable(name: "User", client: mockClient)
        mockClient.setTable(key: "Group", mTable: mockGroupTable)
        mockClient.setTable(key: "GroupXUser", mTable: mockGXUTable)
        
        let mockBlob = mockBlobStorage()
        let mockAzsAccount = mockAZSAccount(mBlobStorage: mockBlob)

        let apiCalls = APICalls(mClient: mockClient, mAzsAccount: mockAzsAccount)
        apiCalls.currentUser = User(id: "sid:8080", firstName: "Josh", lastName: "Choi")
        
        let users = [User(id: "sid:8080", firstName: "Josh", lastName: "Choi"), User(id: "sid:9090", firstName: "Eric", lastName: "Nguyen")]
        
        apiCalls.createGroup(members: users, name: "nil", closure: {
            (group) in
            XCTAssertNil(group)
        })
        
        apiCalls.currentUser = User(id: "sid:8080", firstName: "Josh", lastName: "Choi")
        
        apiCalls.createGroup(members: users, name: "Test Group", closure: {
            (group) in
            XCTAssertNotNil(group)
            
            XCTAssertEqual(group!.id, "sid:1010")
            XCTAssertEqual(group!.members, users)
            XCTAssertEqual(group!.admin, "sid:8080")
            XCTAssert(group!.messages.isEmpty)
            
            XCTAssertEqual(apiCalls.groupList[0].id, group!.id)
            XCTAssertEqual(apiCalls.groupList[0].members, group!.members)
            XCTAssertEqual(apiCalls.groupList[0].admin, group!.admin)
            XCTAssertEqual(apiCalls.groupList[0].messages.isEmpty, group!.messages.isEmpty)
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}