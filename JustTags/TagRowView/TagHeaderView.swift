//
//  TagHeaderView.swift
//  JustTags
//
//  Created by Yurii Zadoianchuk on 03/09/2022.
//

import SwiftUI
import SwiftyEMVTags

internal struct TagHeaderVM: Equatable {
    internal let tag: String
    internal let name: String
    internal let kernels: [String]
}

internal struct TagHeaderView: View {
    internal let vm: TagHeaderVM
    
    internal var body: some View {
        HStack {
            Text(vm.tag)
                .font(.title3.monospaced())
                .fontWeight(.medium)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            Text(vm.name)
                .font(.title3)
                .fontWeight(.regular)
                .minimumScaleFactor(0.5)
            
            kernels
        }
    }
    
    @ViewBuilder
    private var kernels: some View {
        if vm.kernels.count > 1 {
            ForEach(
                vm.kernels,
                id: \.self,
                content: kernelLabel(for:)
            )
        }
    }
    
    private func kernelLabel(for kernel: String) -> some View {
        GroupBox {
            // TODO: make this a button?
            Text(kernel)
                .font(.subheadline.weight(.ultraLight))
                .padding(-2)
        }
    }
}

struct TagHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            TagHeaderView(vm: EMVTag.mockTagMultipleKernels.tagHeaderVM)
            TagHeaderView(vm: EMVTag.mockTagExtended.tagHeaderVM)
        }
    }
}
