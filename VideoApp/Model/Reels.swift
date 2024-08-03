
import Foundation
struct Reels : Codable {
	let arr : [Arr]?

	enum CodingKeys: String, CodingKey {

		case arr = "arr"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		arr = try values.decodeIfPresent([Arr].self, forKey: .arr)
	}

}
