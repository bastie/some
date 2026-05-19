/*
 * SPDX-FileCopyrightText: 2026 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: 0BSD
 */

import PackagePlugin
import struct Foundation.URL
import struct Foundation.Date
import class Foundation.FileManager

@main
struct `some` : CommandPlugin {
  // Entry point for command plugins applied to Swift Packages.
  func performCommand(context: PluginContext, arguments: [String]) async throws {
    let outputFileName = "SourceMerged.swift"
    let outputPath = context.pluginWorkDirectoryURL.appending(component: outputFileName)
    
    // - MARK: argument to show help
    if arguments.contains("usage") || arguments.contains("--help") || arguments.contains("-h") {
      print ("""
        Source Merger plugin
        Version 1.0.0
        
        usage: swift package some [clean|usage]
        
        Parameters:
        clean        - remove existing file \(outputFileName)
        usage        - show this information
        -h --help    - show this information
        <none|other> - merge all source files of in Package.swift defined targets
        """)
      return
    }
    
    // - MARK: argument to clean up
    if arguments.contains("clean"){
      let relativePath = outputPath.absoluteString.replacingOccurrences(of: context.package.directoryURL.absoluteString, with: "")
      do {
        try FileManager.default.removeItem(at: outputPath)
        print("✅ \(relativePath) removed")
        return
      }
      catch _ {
        if FileManager.default.fileExists(atPath: outputPath.path) {
          print("❎ \(relativePath) not removed")
        }
        return
      }
    }
    
    // - MARK: let plugin work
    
    // get files
    let swiftTargets = context.package.targets.compactMap { $0 as? SwiftSourceModuleTarget }
    var allSwiftFiles: [File] = []
    
    for target in swiftTargets {
      let swiftFiles = target.sourceFiles.filter { $0.url.lastPathComponent.reversed().starts(with: "tfiws.") }
      allSwiftFiles.append(contentsOf: swiftFiles)
    }
    
    // merge content of files
    var mergedContent = "// Merged Swift files from package at \(Date())\n"
    mergedContent += "// Total files: \(allSwiftFiles.count)\n\n"
    
    for file in allSwiftFiles {
      let relativePath = file.url.absoluteString.replacingOccurrences(of: context.package.directoryURL.absoluteString, with: "")
      let fileContent = try String(contentsOf: file.url, encoding: .utf8)
      mergedContent += "// MARK: - \(relativePath)\n"
      mergedContent += fileContent
      mergedContent += "\n\n"
    }
    
    try mergedContent.write(toFile: outputPath.path(), atomically: true, encoding: .utf8)
    
    let relativePath = outputPath.absoluteString.replacingOccurrences(of: context.package.directoryURL.absoluteString, with: "")
    print("✅ \(allSwiftFiles.count) Swift-Dateien wurden zusammengefügt in: \(relativePath)")
  }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension `some` : XcodeCommandPlugin {
  // Entry point for command plugins applied to Xcode projects.
  func performCommand(context: XcodePluginContext, arguments: [String]) throws {
    print("Hi, Xcode! I'm a freak on CLI to SOurcecode MErge!")
  }
}

#endif

