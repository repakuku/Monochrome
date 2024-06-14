import ProjectDescription

// MARK: - Project Settings

enum ProjectSettings {
	public static var organizationName: String { "repakuku" }
	public static var projectName: String { "Monochrome" }
	public static var appVersionName: String { "1.0.0" }
	public static var appVersionBuild: Int { 1 }
	public static var developmentTeam: String { "" }
	public static var targetVersion: String { "15.0" }
	public static var bundleId: String { "\(organizationName).\(projectName)" }
}

let swiftLintScriptBody = "SwiftLint/swiftlint --fix && SwiftLint/swiftlint"
let swiftLintScript = TargetScript.post(
	script: swiftLintScriptBody,
	name: "SwiftLint",
	basedOnDependencyAnalysis: false
)

private let scripts: [TargetScript] = [
	swiftLintScript
]

private let infoPlistExtension: [String: Plist.Value] = [
	"UIApplicationSceneManifest": [
		"UIApplicationSupportsMultipleScenes": false,
		"UISceneConfigurations": [
			"UIWindowSceneSessionRoleApplication": [
				[
					"UISceneConfigurationName": "Default Configuration",
					"UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
				]
			]
		]
	],
	"UILaunchStoryboardName": "LaunchScreen",
	"UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
]

// MARK: - Targets

let target = Target(
	name: ProjectSettings.projectName,
	destinations: .iOS,
	product: .app,
	bundleId: ProjectSettings.bundleId,
	deploymentTargets: .iOS(ProjectSettings.targetVersion),
	infoPlist: .extendingDefault(with: infoPlistExtension),
	sources: ["Sources/**", "Shared/**"],
	resources: ["Resources/**"],
	scripts: scripts,
	dependencies: [],
	settings: .settings(
		base: [
			"TARGETED_DEVICE_FAMILY": "1"
		]
	)
)

let testTarget = Target(
	name: "\(ProjectSettings.projectName)Tests",
	destinations: .iOS,
	product: .unitTests,
	bundleId: "\(ProjectSettings.bundleId)Tests",
	deploymentTargets: .iOS(ProjectSettings.targetVersion),
	sources: ["Tests/**", "Shared/**"],
	scripts: scripts,
	dependencies: [
		.target(name: "\(ProjectSettings.projectName)")
	],
	settings: .settings(
		base: [
			"TARGETED_DEVICE_FAMILY": "1"
		]
	)
)

// MARK: - Schemes

let scheme = Scheme(
	name: ProjectSettings.projectName,
	shared: true,
	buildAction: .buildAction(targets: ["\(ProjectSettings.projectName)"]),
	testAction: .targets(["\(ProjectSettings.projectName)Tests"]),
	runAction: .runAction(executable: "\(ProjectSettings.projectName)")
)

let testScheme = Scheme(
	name: "\(ProjectSettings.projectName)Tests",
	shared: true,
	buildAction: .buildAction(targets: ["\(ProjectSettings.projectName)Tests"]),
	testAction: .targets(["\(ProjectSettings.projectName)Tests"]),
	runAction: .runAction(executable: "\(ProjectSettings.projectName)Tests")
)

// MARK: - Project

let project = Project(
	name: ProjectSettings.projectName,
	organizationName: ProjectSettings.organizationName,
	packages: [],
	settings: .settings(
		base: [
			"DEVELOPMENT_TEAM": "\(ProjectSettings.developmentTeam)",
			"MARKETING_VERSION": "\(ProjectSettings.appVersionName)",
			"CURRENT_PROJECT_VERSION": "\(ProjectSettings.appVersionBuild)",
			"DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
		],
		defaultSettings: .recommended()
	),
	targets: [
		target,
		testTarget
	],
	schemes: [
		scheme,
		testScheme
	],
	resourceSynthesizers: []
)

