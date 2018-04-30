//
//  Auth.swift
//  SwiftyCompanion
//
//  Created by Павел Привалов on 4/29/18.
//  Copyright © 2018 Павел Привалов. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Auth: NSObject {

	var token = String()
	let url = "https://api.intra.42.fr/oauth/token"
	let config = [
		"grant_type": "client_credentials",
		"client_id": "bc57acff781dc596f871c2f14c7ac2540ebc922f5ea5b1fc6dc6137e42ffab5b",
		"client_secret": "1818350fc98da146f66c9ca8dc4f5d59eec6a52fe759a029a43ec62a715f2686"]

	func getToken() {
		let verify = UserDefaults.standard.object(forKey: "token")
		if verify == nil {
			Alamofire.request(url, method: .post, parameters: config).validate().responseJSON {
				response in
				switch response.result {
				case .success:
					if let value = response.result.value {
						let json = JSON(value)
						self.token = json["access_token"].stringValue
						UserDefaults.standard.set(json["access_token"].stringValue, forKey: "token")
						print("NEW token:", self.token)
						self.checkToken()
					}
				case .failure(let error):
					print(error)
				}
			}
		} else {
			self.token = verify as! String
			print("SAME token:", self.token)
			checkToken()
		}
	}
	
	private func checkToken() {
		let url = URL(string: "https://api.intra.42.fr/oauth/token/info")
		let bearer = "Bearer " + self.token
		var request = URLRequest(url: url!)
		request.httpMethod = "GET"
		request.setValue(bearer, forHTTPHeaderField: "Authorization")
		Alamofire.request(request as URLRequestConvertible).validate().responseJSON {
			response in
			switch response.result {
			case .success:
				if let value = response.result.value {
					let json = JSON(value)
					print("The token will expire in:", json["expires_in_seconds"], "seconds.")
				}
			case .failure:
				print("Error: Trying to get a new token...")
				UserDefaults.standard.removeObject(forKey: "token")
				self.getToken()
			}
		}
	}
	
	func checkUser(_ user: String, completion: @escaping (JSON?) -> Void) {
		let userUrl = URL(string: "https://api.intra.42.fr/v2/users/" + user)
		let bearer = "Bearer " + self.token
		var request = URLRequest(url: userUrl!)
		request.httpMethod = "GET"
		request.setValue(bearer, forHTTPHeaderField: "Authorization")
		Alamofire.request(request as URLRequestConvertible).validate().responseJSON {
			response in
			switch response.result {
			case .success:
				if let value = response.result.value {
					let json = JSON(value)
					completion(json)
				}
			case .failure:
				completion(nil)
				print("Error: This login doesn't exists")
			}
		}
	}
}
