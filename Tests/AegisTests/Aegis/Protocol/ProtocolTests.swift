import XCTest
@testable import Aegis

final class ProtocolTests: XCTestCase {
    func testProtocolV1() throws {
        var ncShare = NoCryptShare()
        ncShare.content = Data("VEVTVF9WMV9QQUNLRVRfMTIzNDU2Nzg5MA==".bytes)
        ncShare.total = 5
        ncShare.threshold = 3
        
        let packed = try pack(version: ProtocolVersion.V1, v: ncShare)
        
        let unpacked = try unpack(packet: packed)
        XCTAssertEqual((unpacked as? NoCryptShare)?.content, ncShare.content)
        XCTAssertEqual((unpacked as? NoCryptShare)?.total, ncShare.total)
        XCTAssertEqual((unpacked as? NoCryptShare)?.threshold, ncShare.threshold)
    }
}
