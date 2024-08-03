
import Foundation
struct Arr : Codable {
	let _id : String?
	let video : String?
	let thumbnail : String?

	enum CodingKeys: String, CodingKey {

		case _id = "_id"
		case video = "video"
		case thumbnail = "thumbnail"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		video = try values.decodeIfPresent(String.self, forKey: .video)
		thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
	}

}
