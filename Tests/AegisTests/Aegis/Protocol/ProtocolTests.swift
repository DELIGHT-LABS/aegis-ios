import XCTest
@testable import Aegis

final class ProtocolTests: XCTestCase {
    func testProtocolV1() throws {
        var ncShare = NoCryptShare()
        ncShare.content = Data("TEST_V1_PACKET_1234567890".bytes)
        
        let packed = try pack(version: ProtocolVersion.V1, v: ncShare)
        
        let unpacked = try unpack(packet: packed)
        XCTAssertEqual((unpacked as? NoCryptShare)?.content, ncShare.content)
    }
}
