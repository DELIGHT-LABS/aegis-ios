import XCTest
@testable import Aegis

final class ProtocolTests: XCTestCase {
    var ncShare: NoCryptShare = NoCryptShare()
    
    override func setUp() {
        super.setUp()

        ncShare = NoCryptShare()
        ncShare.content = Data("VEVTVF9WMV9QQUNLRVRfMTIzNDU2Nzg5MA==".bytes)
        ncShare.total = 5
        ncShare.threshold = 3
    }
    
    func testProtocolV1() throws {
        let timestamp = Int64(1723096536082)
        
        let packed = try pack(version: ProtocolVersion.V1, v: ncShare, timestamp: timestamp)
        
        let (unpacked, ts) = try unpack(packet: packed)
        XCTAssertEqual((unpacked as? NoCryptShare)?.content, ncShare.content)
        XCTAssertEqual((unpacked as? NoCryptShare)?.total, ncShare.total)
        XCTAssertEqual((unpacked as? NoCryptShare)?.threshold, ncShare.threshold)
        XCTAssertEqual(ts, timestamp)
    }
    
    func testProtocolV1CompatibilityWithoutTimestamp() throws {
        let packed = "eyJwcm90b2NvbF92ZXJzaW9uIjoiVjEiLCJwYWNrZXQiOiJleUpqY25sd2RGOWhiR2R2Y21sMGFHMGlPaUpPVDE5RFVsbFFWQ0lzSW5Ob1lYSmxYM0JoWTJ0bGRDSTZJbVY1U2pCaU0xSm9Za05KTms1VGQybGtSMmg1V2xoT2IySXllR3RKYW05NlRFTkthbUl5TlRCYVZ6VXdTV3B2YVZadGRGZFdNVnBIVjJ0a1VGWnRVazlXYlhCelZXeFdWMVpyT1ZWU2EzQllWbGN4WVZSc1drWmlSRnBWWVRGS1YxUlhjekZPYkhBMlZtczFVbFpFUVRWSmJqQTlJbjA9In0="
        
        let (unpacked, ts) = try unpack(packet: packed)
        XCTAssertEqual((unpacked as? NoCryptShare)?.content, ncShare.content)
        XCTAssertEqual((unpacked as? NoCryptShare)?.total, ncShare.total)
        XCTAssertEqual((unpacked as? NoCryptShare)?.threshold, ncShare.threshold)
        XCTAssertEqual(ts, 0)
    }
}
