//
//  JustTagsApp.swift
//  JustTags
//
//  Created by Yurii Zadoianchuk on 20/03/2022.
//

import SwiftUI
import SwiftyEMVTags

@main
internal struct JustTagsApp: App {
    
    @StateObject private var appVM: AppVM = .shared
    @FocusedObject private var mainVM: MainVM?
    
    internal var body: some Scene {
        WindowGroup("Main", id: WindowType.main.rawValue) {
            MainView()
                .blur(radius: appVM.setUpInProgress ? 30.0 : 0.0)
                .overlay {
                    if appVM.setUpInProgress {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
                .environmentObject(appVM)
        }
        .commands {
            MainViewCommands(vm: appVM)
        }
        
        Window("Diff", id: WindowType.diff.rawValue) {
            DiffView()
                .environmentObject(appVM)
        }
        
        Window("TagLibrary", id: WindowType.library.rawValue) {
            LibraryView(
                vm: .init(tagParser: TagParser(tagDecoder: appVM.tagDecoder))
            )
        }
        
        Settings {
            SettingsView(selectedTab: $appVM.selectedTab)
                .environmentObject(appVM.kernelInfoRepo!)
                .environmentObject(appVM.tagMappingRepo!)
        }
    }

}
