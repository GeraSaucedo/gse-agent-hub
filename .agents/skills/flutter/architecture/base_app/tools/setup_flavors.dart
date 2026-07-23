// ignore_for_file: avoid_print
import 'dart:io';

/// Flavors base del proyecto GSE.
/// Cada flavor tiene: nombre, sufijo de bundle ID, prefijo de app name,
/// y URL de API placeholder.
const List<Map<String, String>> _flavors = [
  {
    'name': 'dev',
    'idSuffix': '.dev',
    'namePrefix': '[DEV] ',
    'apiUrl': 'https://api-dev.example.com',
  },
  {
    'name': 'stg',
    'idSuffix': '.stg',
    'namePrefix': '[STG] ',
    'apiUrl': 'https://api-stg.example.com',
  },
  {
    'name': 'prod',
    'idSuffix': '',
    'namePrefix': '',
    'apiUrl': 'https://api.example.com',
  },
];

const List<String> _buildTypes = ['Debug', 'Release', 'Profile'];

void main() {
  final projectRoot = _findProjectRoot();

  print('=== GSE Flavor Setup ===\n');

  final config = _readProjectConfig(projectRoot);
  print('App name:         ${config.appName}');
  print('Android app ID:   ${config.androidAppId}');
  print('iOS bundle ID:    ${config.iosBundleId}\n');

  _generateAndroidFlavors(projectRoot, config);
  _generateIosPbxproj(projectRoot, config);
  _generateIosSchemes(projectRoot);
  _generateEnvConfig(projectRoot);
  _generateVscodeDefines(projectRoot);
  _generateLaunchJson(projectRoot);

  print('\n=== Flavor setup complete! ===');
  print('Flavors configurados: ${_flavors.map((f) => f['name']).join(', ')}');
  print('\nPara ejecutar:');
  for (final flavor in _flavors) {
    print(
      '  flutter run --flavor ${flavor['name']} '
      '--dart-define-from-file .vscode/defines/${flavor['name']}.json',
    );
  }
}

// ---------------------------------------------------------------------------
// Project config
// ---------------------------------------------------------------------------

class _ProjectConfig {
  final String appName;
  final String androidAppId;
  final String iosBundleId;

  _ProjectConfig({
    required this.appName,
    required this.androidAppId,
    required this.iosBundleId,
  });
}

String _findProjectRoot() {
  var dir = Directory.current;
  while (!File('${dir.path}/pubspec.yaml').existsSync()) {
    final parent = dir.parent;
    if (parent.path == dir.path) {
      print('Error: No se encontró pubspec.yaml');
      exit(1);
    }
    dir = parent;
  }
  return dir.path;
}

_ProjectConfig _readProjectConfig(String root) {
  // App name from pubspec.yaml
  final pubspec = File('$root/pubspec.yaml').readAsStringSync();
  final nameMatch = RegExp(
    r'^name:\s*(\S+)',
    multiLine: true,
  ).firstMatch(pubspec);
  final rawName = nameMatch?.group(1) ?? 'app';
  final appName = _toTitleCase(rawName);

  // Android application ID from build.gradle.kts
  final buildGradle = File(
    '$root/android/app/build.gradle.kts',
  ).readAsStringSync();
  final appIdMatch = RegExp(
    r'applicationId\s*=\s*"([^"]+)"',
  ).firstMatch(buildGradle);
  final androidAppId = appIdMatch?.group(1) ?? 'com.example.$rawName';

  // iOS bundle ID — derive from android (camelCase convention)
  final iosBundleId = _androidIdToIosBundleId(androidAppId);

  return _ProjectConfig(
    appName: appName,
    androidAppId: androidAppId,
    iosBundleId: iosBundleId,
  );
}

String _toTitleCase(String snakeCase) {
  return snakeCase
      .split('_')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}

String _androidIdToIosBundleId(String androidId) {
  // com.example.gse_base_app -> com.example.gseBaseApp
  final parts = androidId.split('.');
  if (parts.length < 3) return androidId;

  final lastPart = parts.last;
  final camel = lastPart.split('_').asMap().entries.map((e) {
    if (e.key == 0) return e.value;
    return e.value.isEmpty
        ? ''
        : '${e.value[0].toUpperCase()}${e.value.substring(1)}';
  }).join();

  return [...parts.sublist(0, parts.length - 1), camel].join('.');
}

// ---------------------------------------------------------------------------
// 1. Android — flavor_config.gradle.kts
// ---------------------------------------------------------------------------

void _generateAndroidFlavors(String root, _ProjectConfig config) {
  final buffer = StringBuffer()
    ..writeln('import com.android.build.api.dsl.ApplicationExtension')
    ..writeln()
    ..writeln('val appName = "${config.appName}"')
    ..writeln()
    ..writeln('configure<ApplicationExtension> {')
    ..writeln('    flavorDimensions += "environment"')
    ..writeln()
    ..writeln('    productFlavors {');

  for (final flavor in _flavors) {
    final name = flavor['name']!;
    final suffix = flavor['idSuffix']!;
    final prefix = flavor['namePrefix']!;

    buffer.writeln('        create("$name") {');
    buffer.writeln('            dimension = "environment"');
    if (suffix.isNotEmpty) {
      buffer.writeln('            applicationIdSuffix = "$suffix"');
      buffer.writeln('            versionNameSuffix = "$suffix"');
    }
    final displayName = prefix.isNotEmpty ? '$prefix\$appName' : 'appName';
    buffer
      ..writeln(
        '            resValue("string", "app_name", ${prefix.isNotEmpty ? '"$displayName"' : 'appName'})',
      )
      ..writeln('        }')
      ..writeln();
  }

  buffer
    ..writeln('    }')
    ..writeln('}');

  File(
    '$root/android/app/flavor_config.gradle.kts',
  ).writeAsStringSync(buffer.toString());
  print('[OK] android/app/flavor_config.gradle.kts');
}

// ---------------------------------------------------------------------------
// 2. iOS — project.pbxproj
// ---------------------------------------------------------------------------

void _generateIosPbxproj(String root, _ProjectConfig config) {
  final pbxprojPath = '$root/ios/Runner.xcodeproj/project.pbxproj';
  final content = File(pbxprojPath).readAsStringSync();

  // Extract everything before XCBuildConfiguration section
  final beforeConfigs = content.substring(
    0,
    content.indexOf('/* Begin XCBuildConfiguration section */'),
  );

  // Extract everything after XCConfigurationList section
  final afterConfigLists = content.substring(
    content.indexOf('/* End XCConfigurationList section */') +
        '/* End XCConfigurationList section */'.length,
  );

  final buffer = StringBuffer()
    ..write(beforeConfigs)
    ..write(_generateBuildConfigurations(config))
    ..writeln()
    ..write(_generateConfigurationLists())
    ..write(afterConfigLists);

  File(pbxprojPath).writeAsStringSync(buffer.toString());
  print('[OK] ios/Runner.xcodeproj/project.pbxproj');
}

String _generateBuildConfigurations(_ProjectConfig config) {
  final buffer = StringBuffer();
  buffer.writeln('/* Begin XCBuildConfiguration section */');

  // ID prefixes: AA=project, BB=runner target, CC=runner tests
  final prefixes = {'project': 'AA', 'runner': 'BB', 'tests': 'CC'};
  final typeLetters = {'Debug': 'D', 'Release': 'R', 'Profile': 'P'};

  // ----- Project-level configs -----
  buffer.writeln('\t\t/* === Project-level configurations === */');
  for (final buildType in _buildTypes) {
    for (var i = 0; i < _flavors.length; i++) {
      final flavor = _flavors[i];
      final id = _makeId(prefixes['project']!, typeLetters[buildType]!, i + 1);
      final name = '$buildType-${flavor['name']}';
      buffer.write(_projectLevelConfig(id, name, buildType));
    }
  }

  // ----- Runner target configs -----
  buffer.writeln();
  buffer.writeln('\t\t/* === Runner target configurations === */');
  for (final buildType in _buildTypes) {
    for (var i = 0; i < _flavors.length; i++) {
      final flavor = _flavors[i];
      final id = _makeId(prefixes['runner']!, typeLetters[buildType]!, i + 1);
      final name = '$buildType-${flavor['name']}';
      final bundleId = flavor['idSuffix']!.isNotEmpty
          ? '${config.iosBundleId}${flavor['idSuffix']}'
          : config.iosBundleId;
      final isDebug = buildType == 'Debug';
      final xcconfigRef = isDebug
          ? '9740EEB21CF90195004384FC /* Debug.xcconfig */'
          : '7AFA3C8E1D35360C0083082E /* Release.xcconfig */';
      buffer.write(
        _runnerTargetConfig(id, name, bundleId, isDebug, xcconfigRef),
      );
    }
  }

  // ----- RunnerTests configs -----
  buffer.writeln();
  buffer.writeln('\t\t/* === RunnerTests target configurations === */');
  for (final buildType in _buildTypes) {
    for (var i = 0; i < _flavors.length; i++) {
      final flavor = _flavors[i];
      final id = _makeId(prefixes['tests']!, typeLetters[buildType]!, i + 1);
      final name = '$buildType-${flavor['name']}';
      final isDebug = buildType == 'Debug';
      buffer.write(_testsTargetConfig(id, name, config.iosBundleId, isDebug));
    }
  }

  buffer.writeln('/* End XCBuildConfiguration section */');
  return buffer.toString();
}

String _makeId(String prefix, String typeLetter, int index) {
  return '${prefix}000000000000000000${typeLetter}0${index.toString().padLeft(3, '0')}';
}

String _projectLevelConfig(String id, String name, String buildType) {
  final isDebug = buildType == 'Debug';
  final buffer = StringBuffer()
    ..writeln('\t\t$id /* $name */ = {')
    ..writeln('\t\t\tisa = XCBuildConfiguration;')
    ..writeln('\t\t\tbuildSettings = {')
    ..writeln('\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;')
    ..writeln(
      '\t\t\t\tASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;',
    )
    ..writeln('\t\t\t\tCLANG_ANALYZER_NONNULL = YES;')
    ..writeln('\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++0x";')
    ..writeln('\t\t\t\tCLANG_CXX_LIBRARY = "libc++";')
    ..writeln('\t\t\t\tCLANG_ENABLE_MODULES = YES;')
    ..writeln('\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_BOOL_CONVERSION = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_COMMA = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_CONSTANT_CONVERSION = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;')
    ..writeln('\t\t\t\tCLANG_WARN_EMPTY_BODY = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_ENUM_CONVERSION = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_INFINITE_RECURSION = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_INT_CONVERSION = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_OBJC_LITERAL_CONVERSION = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;')
    ..writeln('\t\t\t\tCLANG_WARN_RANGE_LOOP_ANALYSIS = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_STRICT_PROTOTYPES = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_SUSPICIOUS_MOVE = YES;')
    ..writeln('\t\t\t\tCLANG_WARN_UNREACHABLE_CODE = YES;')
    ..writeln('\t\t\t\tCLANG_WARN__DUPLICATE_METHOD_MATCH = YES;')
    ..writeln(
      '\t\t\t\t"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";',
    )
    ..writeln('\t\t\t\tCOPY_PHASE_STRIP = NO;');

  if (isDebug) {
    buffer
      ..writeln('\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;')
      ..writeln('\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;')
      ..writeln('\t\t\t\tENABLE_TESTABILITY = YES;')
      ..writeln('\t\t\t\tENABLE_USER_SCRIPT_SANDBOXING = NO;')
      ..writeln('\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu99;')
      ..writeln('\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;')
      ..writeln('\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;')
      ..writeln('\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;')
      ..writeln('\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (')
      ..writeln('\t\t\t\t\t"DEBUG=1",')
      ..writeln('\t\t\t\t\t"\$(inherited)",')
      ..writeln('\t\t\t\t);');
  } else {
    buffer
      ..writeln('\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";')
      ..writeln('\t\t\t\tENABLE_NS_ASSERTIONS = NO;')
      ..writeln('\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;')
      ..writeln('\t\t\t\tENABLE_USER_SCRIPT_SANDBOXING = NO;')
      ..writeln('\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu99;')
      ..writeln('\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;');
  }

  buffer
    ..writeln('\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;')
    ..writeln('\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;')
    ..writeln('\t\t\t\tGCC_WARN_UNDECLARED_SELECTOR = YES;')
    ..writeln('\t\t\t\tGCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;')
    ..writeln('\t\t\t\tGCC_WARN_UNUSED_FUNCTION = YES;')
    ..writeln('\t\t\t\tGCC_WARN_UNUSED_VARIABLE = YES;')
    ..writeln('\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 13.0;');

  if (isDebug) {
    buffer
      ..writeln('\t\t\t\tMTL_ENABLE_DEBUG_INFO = YES;')
      ..writeln('\t\t\t\tONLY_ACTIVE_ARCH = YES;')
      ..writeln('\t\t\t\tSDKROOT = iphoneos;');
  } else {
    buffer
      ..writeln('\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;')
      ..writeln('\t\t\t\tSDKROOT = iphoneos;')
      ..writeln('\t\t\t\tSUPPORTED_PLATFORMS = iphoneos;');
    if (buildType == 'Release') {
      buffer
        ..writeln('\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;')
        ..writeln('\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-O";');
    }
  }

  buffer.writeln('\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";');
  if (!isDebug) {
    buffer.writeln('\t\t\t\tVALIDATE_PRODUCT = YES;');
  }

  buffer.writeln('\t\t\t};');
  buffer.writeln('\t\t\tname = "$name";');
  buffer.writeln('\t\t};');
  return buffer.toString();
}

String _runnerTargetConfig(
  String id,
  String name,
  String bundleId,
  bool isDebug,
  String xcconfigRef,
) {
  final buffer = StringBuffer();
  buffer.writeln('\t\t$id /* $name */ = {');
  buffer.writeln('\t\t\tisa = XCBuildConfiguration;');
  buffer.writeln('\t\t\tbaseConfigurationReference = $xcconfigRef;');
  buffer.writeln('\t\t\tbuildSettings = {');
  buffer.writeln('\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;');
  buffer.writeln('\t\t\t\tCLANG_ENABLE_MODULES = YES;');
  buffer.writeln(
    '\t\t\t\tCURRENT_PROJECT_VERSION = "\$(FLUTTER_BUILD_NUMBER)";',
  );
  buffer.writeln('\t\t\t\tENABLE_BITCODE = NO;');
  buffer.writeln('\t\t\t\tINFOPLIST_FILE = Runner/Info.plist;');
  buffer.writeln('\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (');
  buffer.writeln('\t\t\t\t\t"\$(inherited)",');
  buffer.writeln('\t\t\t\t\t"@executable_path/Frameworks",');
  buffer.writeln('\t\t\t\t);');
  buffer.writeln('\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = $bundleId;');
  buffer.writeln('\t\t\t\tPRODUCT_NAME = "\$(TARGET_NAME)";');
  buffer.writeln(
    '\t\t\t\tSWIFT_OBJC_BRIDGING_HEADER = "Runner/Runner-Bridging-Header.h";',
  );
  if (isDebug) {
    buffer.writeln('\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";');
  }
  buffer.writeln('\t\t\t\tSWIFT_VERSION = 5.0;');
  buffer.writeln('\t\t\t\tVERSIONING_SYSTEM = "apple-generic";');
  buffer.writeln('\t\t\t};');
  buffer.writeln('\t\t\tname = "$name";');
  buffer.writeln('\t\t};');
  return buffer.toString();
}

String _testsTargetConfig(
  String id,
  String name,
  String baseBundleId,
  bool isDebug,
) {
  final buffer = StringBuffer();
  buffer.writeln('\t\t$id /* $name */ = {');
  buffer.writeln('\t\t\tisa = XCBuildConfiguration;');
  buffer.writeln('\t\t\tbuildSettings = {');
  buffer.writeln('\t\t\t\tBUNDLE_LOADER = "\$(TEST_HOST)";');
  buffer.writeln('\t\t\t\tCODE_SIGN_STYLE = Automatic;');
  buffer.writeln('\t\t\t\tCURRENT_PROJECT_VERSION = 1;');
  buffer.writeln('\t\t\t\tGENERATE_INFOPLIST_FILE = YES;');
  buffer.writeln('\t\t\t\tMARKETING_VERSION = 1.0;');
  buffer.writeln(
    '\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = $baseBundleId.RunnerTests;',
  );
  buffer.writeln('\t\t\t\tPRODUCT_NAME = "\$(TARGET_NAME)";');
  if (isDebug) {
    buffer.writeln('\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;');
    buffer.writeln('\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";');
  }
  buffer.writeln('\t\t\t\tSWIFT_VERSION = 5.0;');
  buffer.writeln(
    '\t\t\t\tTEST_HOST = "\$(BUILT_PRODUCTS_DIR)/Runner.app/\$(BUNDLE_EXECUTABLE_FOLDER_PATH)/Runner";',
  );
  buffer.writeln('\t\t\t};');
  buffer.writeln('\t\t\tname = "$name";');
  buffer.writeln('\t\t};');
  return buffer.toString();
}

String _generateConfigurationLists() {
  final typeLetters = {'Debug': 'D', 'Release': 'R', 'Profile': 'P'};
  final buffer = StringBuffer();
  buffer.writeln('/* Begin XCConfigurationList section */');

  // RunnerTests config list
  buffer.writeln(
    '\t\t331C8087294A63A400263BE5 /* Build configuration list for PBXNativeTarget "RunnerTests" */ = {',
  );
  buffer.writeln('\t\t\tisa = XCConfigurationList;');
  buffer.writeln('\t\t\tbuildConfigurations = (');
  for (final bt in _buildTypes) {
    for (var i = 0; i < _flavors.length; i++) {
      final id = _makeId('CC', typeLetters[bt]!, i + 1);
      buffer.writeln('\t\t\t\t$id /* $bt-${_flavors[i]['name']} */,');
    }
  }
  buffer.writeln('\t\t\t);');
  buffer.writeln('\t\t\tdefaultConfigurationIsVisible = 0;');
  buffer.writeln('\t\t\tdefaultConfigurationName = "Release-prod";');
  buffer.writeln('\t\t};');

  // Project config list
  buffer.writeln(
    '\t\t97C146E91CF9000F007C117D /* Build configuration list for PBXProject "Runner" */ = {',
  );
  buffer.writeln('\t\t\tisa = XCConfigurationList;');
  buffer.writeln('\t\t\tbuildConfigurations = (');
  for (final bt in _buildTypes) {
    for (var i = 0; i < _flavors.length; i++) {
      final id = _makeId('AA', typeLetters[bt]!, i + 1);
      buffer.writeln('\t\t\t\t$id /* $bt-${_flavors[i]['name']} */,');
    }
  }
  buffer.writeln('\t\t\t);');
  buffer.writeln('\t\t\tdefaultConfigurationIsVisible = 0;');
  buffer.writeln('\t\t\tdefaultConfigurationName = "Release-prod";');
  buffer.writeln('\t\t};');

  // Runner target config list
  buffer.writeln(
    '\t\t97C147051CF9000F007C117D /* Build configuration list for PBXNativeTarget "Runner" */ = {',
  );
  buffer.writeln('\t\t\tisa = XCConfigurationList;');
  buffer.writeln('\t\t\tbuildConfigurations = (');
  for (final bt in _buildTypes) {
    for (var i = 0; i < _flavors.length; i++) {
      final id = _makeId('BB', typeLetters[bt]!, i + 1);
      buffer.writeln('\t\t\t\t$id /* $bt-${_flavors[i]['name']} */,');
    }
  }
  buffer.writeln('\t\t\t);');
  buffer.writeln('\t\t\tdefaultConfigurationIsVisible = 0;');
  buffer.writeln('\t\t\tdefaultConfigurationName = "Release-prod";');
  buffer.writeln('\t\t};');

  buffer.writeln('/* End XCConfigurationList section */');
  return buffer.toString();
}

// ---------------------------------------------------------------------------
// 3. iOS — Xcode Schemes
// ---------------------------------------------------------------------------

void _generateIosSchemes(String root) {
  final schemesDir = '$root/ios/Runner.xcodeproj/xcshareddata/xcschemes';
  final dir = Directory(schemesDir);
  if (!dir.existsSync()) dir.createSync(recursive: true);

  // Remove old Runner.xcscheme if it exists
  final oldScheme = File('$schemesDir/Runner.xcscheme');
  if (oldScheme.existsSync()) oldScheme.deleteSync();

  for (final flavor in _flavors) {
    final name = flavor['name']!;
    File('$schemesDir/$name.xcscheme').writeAsStringSync(_xcscheme(name));
    print('[OK] ios/.../xcschemes/$name.xcscheme');
  }
}

String _xcscheme(String flavor) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1510"
   version = "1.3">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "97C146ED1CF9000F007C117D"
               BuildableName = "Runner.app"
               BlueprintName = "Runner"
               ReferencedContainer = "container:Runner.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug-$flavor"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      customLLDBInitFile = "\$(SRCROOT)/Flutter/ephemeral/flutter_lldbinit"
      shouldUseLaunchSchemeArgsEnv = "YES">
      <MacroExpansion>
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </MacroExpansion>
      <Testables>
         <TestableReference
            skipped = "NO"
            parallelizable = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "331C8080294A63A400263BE5"
               BuildableName = "RunnerTests.xctest"
               BlueprintName = "RunnerTests"
               ReferencedContainer = "container:Runner.xcodeproj">
            </BuildableReference>
         </TestableReference>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug-$flavor"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      customLLDBInitFile = "\$(SRCROOT)/Flutter/ephemeral/flutter_lldbinit"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      enableGPUValidationMode = "1"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Profile-$flavor"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug-$flavor">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release-$flavor"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
''';
}

// ---------------------------------------------------------------------------
// 4. Dart — env_config.dart
// ---------------------------------------------------------------------------

void _generateEnvConfig(String root) {
  final flavorNames = _flavors.map((f) => f['name']).join(', ');
  final switchCases = _flavors
      .map((f) => "    '${f['name']}' => Environment.${f['name']},")
      .join('\n');

  final boolGetters = _flavors
      .map((f) {
        final name = f['name']!;
        final capitalized = '${name[0].toUpperCase()}${name.substring(1)}';
        return '  static bool get is$capitalized => environment == Environment.$name;';
      })
      .join('\n');

  final content =
      '''enum Environment { $flavorNames, unknown }

class EnvConfig {
  static const String apiUrl = String.fromEnvironment('API_URL');
  static const String _env = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'null',
  );
  static const bool useMockAuth = bool.fromEnvironment('USE_MOCK_AUTH');

  static Environment get environment => switch (_env) {
$switchCases
    _ => Environment.unknown,
  };

$boolGetters
}
''';

  File(
    '$root/lib/core/environments/env_config.dart',
  ).writeAsStringSync(content);
  print('[OK] lib/core/environments/env_config.dart');
}

// ---------------------------------------------------------------------------
// 5. VSCode — defines
// ---------------------------------------------------------------------------

void _generateVscodeDefines(String root) {
  final definesDir = '$root/.vscode/defines';
  Directory(definesDir).createSync(recursive: true);

  for (final flavor in _flavors) {
    final name = flavor['name']!;
    final apiUrl = flavor['apiUrl']!;
    final isMock = name == 'dev' ? 'true' : 'false';
    final content =
        '{\n'
        '  "ENVIRONMENT": "$name",\n'
        '  "API_URL": "$apiUrl",\n'
        '  "USE_MOCK_AUTH": "$isMock"\n'
        '}\n';
    File('$definesDir/$name.json').writeAsStringSync(content);
    print('[OK] .vscode/defines/$name.json');
  }
}

// ---------------------------------------------------------------------------
// 6. VSCode — launch.json
// ---------------------------------------------------------------------------

void _generateLaunchJson(String root) {
  final configs = <String>[];

  for (final flavor in _flavors) {
    final name = flavor['name']!;
    final upper = name.toUpperCase();

    // debug (default mode, no flutterMode needed)
    configs.add('''    {
      "name": "$upper (debug)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--flavor", "$name",
        "--dart-define-from-file", ".vscode/defines/$name.json"
      ]
    }''');

    // release
    configs.add('''    {
      "name": "$upper (release)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "flutterMode": "release",
      "args": [
        "--flavor", "$name",
        "--dart-define-from-file", ".vscode/defines/$name.json"
      ]
    }''');

    // profile
    configs.add('''    {
      "name": "$upper (profile)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "flutterMode": "profile",
      "args": [
        "--flavor", "$name",
        "--dart-define-from-file", ".vscode/defines/$name.json"
      ]
    }''');
  }

  final content =
      '{\n'
      '  "version": "0.2.0",\n'
      '  "configurations": [\n'
      '${configs.join(',\n')}\n'
      '  ]\n'
      '}\n';

  File('$root/.vscode/launch.json').writeAsStringSync(content);
  print('[OK] .vscode/launch.json');
}
