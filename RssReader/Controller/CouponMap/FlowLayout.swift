//
//  FlowLayout.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/06/01.
//

import UIKit

class FlowLayout: UICollectionViewFlowLayout {
    private var layoutAttributesForPaging: [UICollectionViewLayoutAttributes]?
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        guard let targetAttributes = layoutAttributesForPaging else { return proposedContentOffset }
        
        let nextAttributes: UICollectionViewLayoutAttributes?
        if velocity.x == 0 {
            nextAttributes = layoutAttributesForNearbyCenterX(in: targetAttributes, collectionView: collectionView)
        } else if velocity.x > 0 {
            nextAttributes = targetAttributes.last
        } else {
            nextAttributes = targetAttributes.first
        }
        guard let attributes = nextAttributes else { return proposedContentOffset }
        
        if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
            return CGPoint(x: 0, y: collectionView.contentOffset.y)
        } else {
            let cellLeftMargin = (collectionView.bounds.width - attributes.bounds.width) * 0.5
            return CGPoint(x: attributes.frame.minX - cellLeftMargin, y: collectionView.contentOffset.y)
        }
    }
    
    private func layoutAttributesForNearbyCenterX(in attributes: [UICollectionViewLayoutAttributes], collectionView: UICollectionView) -> UICollectionViewLayoutAttributes? {
        let screenCenterX = collectionView.contentOffset.x + collectionView.bounds.width * 0.5
        let result = attributes.reduce((attributes: nil as UICollectionViewLayoutAttributes?, distance: CGFloat.infinity)) { result, attributes in
            let distance = attributes.frame.midX - screenCenterX
            return abs(distance) < abs(result.distance) ? (attributes, distance) : result
        }
        return result.attributes
    }
    
    func prepareForPaging() {
        guard let collectionView = collectionView else { return }
        let expansionMargin = sectionInset.left + sectionInset.right
        let expandedVisibleRect = CGRect(x: collectionView.contentOffset.x - expansionMargin,
                                         y: 0,
                                         width: collectionView.bounds.width + (expansionMargin * 2),
                                         height: collectionView.bounds.height)
        layoutAttributesForPaging = layoutAttributesForElements(in: expandedVisibleRect)?.sorted { $0.frame.minX < $1.frame.minX }
    }
}
