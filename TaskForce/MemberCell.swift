//
//  MemberCell.swift
//  TaskForce
//
//  Created by Rexi Sheredy on 4/10/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    @IBOutlet weak var memberName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        profileImage.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
        super.awakeFromNib()
    }
    
    func setMemberName(name: String){
        memberName.text = name
        
    }
    func setImage(profile: UIImage){
        
        let newImage = resizeImage(image: profile, toTheSize: CGSize(width: 60, height: 60))
        profileImage.image = newImage
        
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        let scale = CGFloat(max(size.width/image.size.width, size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale
        
        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}
