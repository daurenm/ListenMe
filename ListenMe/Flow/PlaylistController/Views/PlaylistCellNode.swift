//
//  PlaylistCellNode.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/15/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy
import AsyncDisplayKit

class PlaylistCellNode: ASCellNode {
    
    // MARK: - Properties
    let track: Track
    
    // MARK: - Views
    lazy var trackNameNode: TextNode = {
        let node = TextNode(font: UIFont.systemFont(ofSize: 15, weight: .regular), textColor: .white)
        node.style.flexShrink = 1
        node.maximumNumberOfLines = 1

        let trackName = track.url.fileName
        node.setText(trackName)

        return node
    }()
    
    lazy var durationNode: TextNode = {
        let node = TextNode(font: UIFont.systemFont(ofSize: 14, weight: .regular), textColor: UIColor(r: 216, g: 216, b: 216))
        
        let duration = track.durationInSeconds.asTrackDurationFormat
        node.setText(duration)
        
        return node
    }()
    
    lazy var separatorNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        node.style.height = ASDimension(unit: .points, value: 1)
        return node
    }()
    
    // MARK: - Lifecycle methods
    init(track: Track) {
        self.track = track
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let horizontalStack = ASStackLayoutSpec(direction: .horizontal, spacing: 20, justifyContent: .spaceBetween, alignItems: .center, children: [trackNameNode, durationNode])
        horizontalStack.style.flexGrow = 2
        let verticalStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .spaceBetween, alignItems: .stretch, children: [horizontalStack, separatorNode])
        let insetLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), child: verticalStack)
        return insetLayout
    }
}










