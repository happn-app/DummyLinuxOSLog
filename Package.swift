// swift-tools-version:5.0

import PackageDescription



let package = Package(
	name: "DummyLinuxOSLog",
	platforms: [
		.macOS(.v10_10),
		.iOS(.v8),
		.tvOS(.v9),
		.watchOS(.v2)
	],
	products: [
		.library(name: "DummyLinuxOSLog", targets: ["DummyLinuxOSLog"]),
	],
	targets: [
		.target(name: "DummyLinuxOSLog", dependencies: [])
	]
)
