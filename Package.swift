// swift-tools-version:5.0

import PackageDescription



let package = Package(
	name: "DummyLinuxOSLog",
	products: [
		.library(name: "DummyLinuxOSLog", targets: ["DummyLinuxOSLog"]),
	],
	targets: [
		.target(name: "DummyLinuxOSLog", dependencies: [])
	]
)
