//
//  RswiftPlugin.swift
//
//
//  Created by Quentin Fasquel on 01/04/2022.
//

import PackagePlugin
import Foundation

@main struct RswiftPlugin: BuildToolPlugin {
  /// This plugin's implementation returns a single `prebuild` command to run `rswift`.
  func createBuildCommands(
    context: PluginContext,
    target: Target
  ) async throws -> [Command] {
    return [
      .prebuildCommand(
        displayName: "Running rswift-plugin",
        executable: try context.tool(named: "rswift").path,
        arguments: [
          "generate", context.pluginWorkDirectory.appending("R.generated.swift"),
          "--swiftPackage", context.package.directory.string,
          "--target", target.name,
          "--accessLevel", "public",
        ],
        environment: [
          "SDKROOT": shell("xcrun", "--sdk", "macosx", "--show-sdk-path")
            .output
            .flatMap { $0.split(separator: "\n").first }
            .map(String.init) ?? "",
        ],
        outputFilesDirectory: context.pluginWorkDirectory
      )
    ]
  }
}

@discardableResult
func shell(_ args: String...) -> (
  output: String?,
  status: Int32
) {
  let task = Process()
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  let pipe = Pipe()
  task.standardOutput = pipe
  task.standardError = pipe
  task.launch()
  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  let output = String(data: data, encoding: .utf8)
  task.waitUntilExit()
  return (output, task.terminationStatus)
}
