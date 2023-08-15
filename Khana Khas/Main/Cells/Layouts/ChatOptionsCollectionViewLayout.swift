//
//  ChatOptionsCollectionViewLayout.swift
//  Khana Khas
//
//  Created by Preet Jagani on 13/08/23.
//

import UIKit

public protocol ChatOptionsFlowLayoutDelegate: AnyObject {
    func numberOfItemsIn(row: Int) -> Int
    
    func rowForIndexPath(indexPath: IndexPath) -> Int
}

public class ChatOptionsCollectionViewLayout: UICollectionViewLayout {

    public var rowsCount = 2
    public var height: CGFloat = 36
    let spacing : CGFloat = 8.0
    
    
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    var contentSize: CGSize = .zero
    public weak var delegate: ChatOptionsFlowLayoutDelegate?

    override public var collectionViewContentSize: CGSize {
        return contentSize
    }

    override public func prepare() {
        super.prepare()

        cachedAttributes.removeAll()
        calculateCollectionViewFrames()
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter { $0.frame.intersects(rect) }
    }

    public func calculateCollectionViewFrames() {

        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }

        contentSize.width = collectionView.frame.size.width
        
        var curRow = 0
        
        var ccxOffsets = [CGFloat](repeating: 0, count: rowsCount)

        for section in 0..<collectionView.numberOfSections {
            let itemsCount = collectionView.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                
                curRow = delegate.rowForIndexPath(indexPath: indexPath)
                let numItems = delegate.numberOfItemsIn(row: curRow)

                let width = collectionView.frame.width - (CGFloat((numItems - 1)) * spacing)
                let cellwWidth : CGFloat = width / CGFloat(numItems)
                let cellHeight = height
                let cellSize = CGSize(width: cellwWidth, height: cellHeight)

                let ccx = ccxOffsets[curRow]
                let ccy = CGFloat(curRow) * spacing + (CGFloat(curRow) * height)
                let origin = CGPoint(x: ccx, y: ccy)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(origin: origin, size: cellSize)
                cachedAttributes.append(attributes)

                ccxOffsets[curRow] += cellwWidth + spacing
            }
        }
    }
}
