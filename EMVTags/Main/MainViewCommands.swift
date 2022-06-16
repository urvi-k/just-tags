//
//  MainViewCommands.swift
//  EMVTags
//
//  Created by Yurii Zadoianchuk on 05/06/2022.
//

import SwiftUI

internal struct MainViewCommands: Commands {
    
    @Environment(\.openURL) var openURL
    
    @ObservedObject internal var viewModel: AppVM
    
    var body: some Commands {
        fileCommands
        editCommands
    }
    
    @CommandsBuilder
    var editCommands: some Commands {
        CommandGroup(replacing: CommandGroupPlacement.pasteboard) {
            copySelectedTagsButton
            paste
            pasteIntoNewTab
        }
    }
    
    @CommandsBuilder
    var fileCommands: some Commands {
        CommandGroup(replacing: CommandGroupPlacement.newItem, addition: {
            newTabButton
            openTagInfoButton
            openMainViewButton
            openDiffViewButton
        })
    }
    
    private var copySelectedTagsButton: some View {
        Button(action: {
            viewModel.activeVM
                .map(\.hexString)
                .map(NSPasteboard.copyString(_:))
        }, label: {
            copyTagsButtonLabel
        })
        .keyboardShortcut("c", modifiers: [.command])
    }
    
    private var paste: some View {
        Button(
            "Paste",
            action: viewModel.pasteIntoCurrentTab
        ).keyboardShortcut("v", modifiers: [.command])
    }
    
    private var pasteIntoNewTab: some View {
        Button("Paste into new tab") {
            viewModel.openNewTab()
            viewModel.pasteIntoCurrentTab()
        }.keyboardShortcut("v", modifiers: [.command, .shift])
    }
    
    @ViewBuilder
    private var copyTagsButtonLabel: some View {
        if viewModel.activeVM.map(\.selectedTags.count) == 1 {
            Text("Copy selected tag")
        } else {
            Text("Copy selected tags")
        }
    }
    
    private var newTabButton: some View {
        Button(
            "New Tab",
            action: viewModel.openNewTab
        ).keyboardShortcut("t", modifiers: [.command])
    }
    
    private var openTagInfoButton: some View {
        Button(
            "Open tag info list",
            action: viewModel.loadInfoJSON
        ).keyboardShortcut("o", modifiers: [.command, .shift])
    }
    
    private var openDiffViewButton: some View {
        Button("Diff view") {
            openURL(URL(string: "emvtags://diff")!)
        }.keyboardShortcut("d", modifiers: [.command, .shift])
    }
    
    private var openMainViewButton: some View {
        Button("Main view") {
            openURL(URL(string: "emvtags://main")!)
        }.keyboardShortcut("m", modifiers: [.command, .shift])
    }
    
}