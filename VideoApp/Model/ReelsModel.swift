 
import Foundation
struct ReelsModel : Codable {
	let reels : [Reels]?

	enum CodingKeys: String, CodingKey {

		case reels = "reels"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		reels = try values.decodeIfPresent([Reels].self, forKey: .reels)
	}

}
