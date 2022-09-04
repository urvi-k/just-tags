//
//  DiffedTagRowView.swift
//  JustTags
//
//  Created by Yurii Zadoianchuk on 03/09/2022.
//

import SwiftUI
import SwiftyEMVTags

internal struct DiffedTagRowView: View {
    
    internal let diffedTag: DiffedTag
    
    internal var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: commonPadding) {
                TagHeaderView(tag: diffedTag.tag)
                DiffedTagValueView(diffedTag: diffedTag)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contextMenu { contextMenu }
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private var contextMenu: some View {
        Button("Copy full tag") {
            NSPasteboard.copyString(diffedTag.tag.hexString)
        }
        Button("Copy value") {
            NSPasteboard.copyString(diffedTag.tag.value.hexString)
        }
    }
    
}

internal let mockDiffedShortTag = DiffedTag(
    tag: mockShortTag, results: [.equal, .different, .different]
)

struct DiffedTagRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DiffedTagRowView(diffedTag: mockDiffedShortTag)
        }.environmentObject(MainVM())
    }
}