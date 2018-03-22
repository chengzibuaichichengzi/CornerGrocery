//
//  LibraryTableViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 31/5/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import AnimatableReload

class LibraryTableViewController: UITableViewController {

    @IBOutlet var LibraryTableView: UITableView!
    
    //4 library titles
    var libraries = ["SwiftMessages", "SwiftSpinner", "AnimatableReload", "Firebase"]
    //4 licenses
    var licenses = ["Copyright (c) 2016 SwiftKick Mobile LLC" + "\n\n" + "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:" + "\n\n" +
        "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software",
            "Copyright (c) 2015 Marin Todorov <touch-code-magazine@underplot.com>" + "\n\n" +
        "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:" + "\n\n" +
        "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.",
            "Copyright (c) 2017 harshalrj25 <harshalrj25@gmail.com>" + "\n\n" +
                "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:" + "\n\n" +
        "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.",
            "Created by Adam Preble on 1/23/12. Copyright (c) 2012 Adam Preble. All rights reserved." + "\n\n" +
                "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:" + "\n\n" +
        "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."]
    
    override func viewDidLoad() {
        LibraryTableView.delegate = self
        LibraryTableView.dataSource = self
        
        super.viewDidLoad()
        //animation of reloading data
        AnimatableReload.reload(tableView: self.LibraryTableView, animationDirection: "left")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //animation of reloading data
        AnimatableReload.reload(tableView: self.LibraryTableView, animationDirection: "left")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryCell", for: indexPath) as! LibraryCell
        cell.nameLabel.text = libraries[indexPath.row]
        cell.licenseText.text = licenses[indexPath.row]
        //make cell unclickable
        cell.selectionStyle = .none
        return cell
        
    }

    //set section height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 220.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
