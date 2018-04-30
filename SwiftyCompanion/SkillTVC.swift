//
//  SkillTVC.swift
//  SwiftyCompanion
//
//  Created by Павел Привалов on 4/30/18.
//  Copyright © 2018 Павел Привалов. All rights reserved.
//

import UIKit

class SkillTVC: UITableViewCell {
	
	@IBOutlet weak var progress: UIProgressView!
	@IBOutlet weak var label: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		progress.transform = progress.transform.scaledBy(x: 1, y: 2)
		progress.layer.cornerRadius = progress.frame.height / 2
		progress.clipsToBounds = true
		progress.layer.sublayers![1].cornerRadius = progress.frame.height / 2
		progress.subviews[1].clipsToBounds = true
	}
	
}

class  ProjectsTVC: UITableViewCell {
	
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var status: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
