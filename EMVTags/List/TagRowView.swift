//
//  TagRowView.swift
//  EMVTags
//
//  Created by Yurii Zadoianchuk on 22/04/2022.
//

import SwiftUI
import SwiftyEMVTags

internal struct TagRowView: View {
    
    @EnvironmentObject private var windowVM: AnyWindowVM

    private let tag: EMVTag
    private let byteDiffResults: [DiffResult]
    private let isDiffing: Bool
    private let canExpand: Bool
    private let showsDetails: Bool
    
    @State private var isExpanded: Bool = false
    
    internal init(diffedTag: DiffedTag) {
        self.tag = diffedTag.tag
        self.byteDiffResults = diffedTag.diff
        self.isDiffing = true
        self.canExpand = diffedTag.tag.decodedMeaningList.isEmpty == false
        self.showsDetails = canExpand
    }
    
    internal init(tag: EMVTag) {
        self.tag = tag
        self.byteDiffResults = []
        self.isDiffing = false
        self.canExpand = tag.decodedMeaningList.isEmpty == false
        self.showsDetails = canExpand
    }
    
    internal var body: some View {
        GroupBox {
            if tag.isConstructed {
                ConstructedTagView(tag: tag)
            } else {
                PrimitiveTagView(
                    tag: tag,
                    byteDiffResults: byteDiffResults,
                    isDiffing: isDiffing,
                    canExpand: canExpand,
                    showsDetails: showsDetails
                )
            }
        }
        .contextMenu { contextMenu }
        .contentShape(Rectangle())
        .if(windowVM.contains(id: tag.id)) { view in
            view.overlay {
                RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                    .strokeBorder(lineWidth: 1.0, antialiased: true)
                    .foregroundColor(.secondary)
            }.transition(.opacity)
        }
    }
    
    @ViewBuilder
    private var contextMenu: some View {
        Button("Copy full tag") {
            NSPasteboard.copyString(tag.hexString)
        }
        Button("Copy value") {
            NSPasteboard.copyString(tag.value.hexString)
        }
        if windowVM.selectedTags.count > 1 {
            Button("Copy selected tags") {
                NSPasteboard.copyString(windowVM.hexString)
            }
        }
    }

}

internal struct TagValueView: View {
    internal let tag: EMVTag
    
    internal var body: some View {
        HStack(spacing: commonPadding * 2) {
            Text(tag.value.hexString)
                .font(.title3.monospaced())
            if let text = tag.textRepresentation {
                Text(text)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
    }
}

internal struct TagHeaderView: View {
    internal let tag: EMVTag
    
    internal var body: some View {
        HStack {
            Text(tag.tag.hexString)
                .font(.body.monospaced())
                .fontWeight(.semibold)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Text(tag.name)
                .font(.body)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.5)
        }
    }
}

#if DEBUG
struct TagRowView_Previews: PreviewProvider {
    static var previews: some View {
        TagRowView(tag: .init(hexString: "e181c7df810c01029f060aa0000000041010d076129f150260519f160f3130303920202020202020202020209f1a0205289f1c0832313930303031389f090200029f3501229f40056000b0a003df812005fc50bca000df8121050010000000df812205fc50bcf8009f1d009f6d02ffffdf81170120df81180120df81190108df811b01b0df811e0110df811f0108df812306000000002500df812406000009999999df812506000009999999df8126060000000050009f530152df811c020078df811d0102df812c0100"))
        TagRowView(
            diffedTag: (tag: .init(hexString: "9F33032808C8"), diff: [.equal, .different, .different])
        )
        TagRowView(tag: EMVTag(tlv: mockTLV, info: mockInfo, subtags: []))
    }
}
#endif
