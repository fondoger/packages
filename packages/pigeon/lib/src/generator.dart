// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'ast.dart';
import 'generator_tools.dart';

/// The internal options used by the generator.
abstract class PigeonInternalOptions {
  /// Constructor.
  const PigeonInternalOptions();
}

/// An abstract base class of generators.
///
/// This provides the structure that is common across generators for different languages.
abstract class Generator<PigeonInternalOptions> {
  /// Constructor.
  const Generator();

  /// Generates files for specified language with specified [generatorOptions]
  void generate(
    PigeonInternalOptions generatorOptions,
    Root root,
    StringSink sink, {
    required String dartPackageName,
  });
}

/// An abstract base class that enforces code generation across platforms.
abstract class StructuredGenerator<PigeonInternalOptions>
    extends Generator<PigeonInternalOptions> {
  /// Constructor.
  const StructuredGenerator();

  @override
  void generate(
    PigeonInternalOptions generatorOptions,
    Root root,
    StringSink sink, {
    required String dartPackageName,
  }) {
    final Indent indent = Indent(sink);

    writeFilePrologue(
      generatorOptions,
      root,
      indent,
      dartPackageName: dartPackageName,
    );

    writeFileImports(
      generatorOptions,
      root,
      indent,
      dartPackageName: dartPackageName,
    );

    writeOpenNamespace(
      generatorOptions,
      root,
      indent,
      dartPackageName: dartPackageName,
    );

    writeGeneralUtilities(
      generatorOptions,
      root,
      indent,
      dartPackageName: dartPackageName,
    );

    if (root.apis.any((Api api) => api is AstProxyApi)) {
      writeInstanceManager(
        generatorOptions,
        root,
        indent,
        dartPackageName: dartPackageName,
      );

      writeInstanceManagerApi(
        generatorOptions,
        root,
        indent,
        dartPackageName: dartPackageName,
      );

      writeProxyApiBaseCodec(generatorOptions, root, indent);
    }

    writeEnums(
      generatorOptions,
      root,
      indent,
      dartPackageName: dartPackageName,
    );

    writeDataClasses(
      generatorOptions,
      root,
      indent,
      dartPackageName: dartPackageName,
    );

    writeGeneralCodec(
      generatorOptions,
      root,
      indent,
      dartPackageName: dartPackageName,
    );

    writeApis(
      generatorOptions,
      root,
      indent,
      dartPackageName: dartPackageName,
    );

    writeCloseNamespace(
      generatorOptions,
      root,
      indent,
      dartPackageName: dartPackageName,
    );
  }

  /// Adds specified headers to [indent].
  void writeFilePrologue(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  });

  /// Writes specified imports to [indent].
  void writeFileImports(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  });

  /// Writes code to [indent] that opens file namespace if needed.
  ///
  /// This method is not required, and does not need to be overridden.
  void writeOpenNamespace(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {}

  /// Writes code to [indent] that closes file namespace if needed.
  ///
  /// This method is not required, and does not need to be overridden.
  void writeCloseNamespace(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {}

  /// Writes any necessary helper utilities to [indent] if needed.
  ///
  /// This method is not required, and does not need to be overridden.
  void writeGeneralUtilities(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {}

  /// Writes all enums to [indent].
  ///
  /// Can be overridden to add extra code before/after enums.
  void writeEnums(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {
    for (final Enum anEnum in root.enums) {
      writeEnum(
        generatorOptions,
        root,
        indent,
        anEnum,
        dartPackageName: dartPackageName,
      );
    }
  }

  /// Writes a single Enum to [indent]. This is needed in most generators.
  void writeEnum(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent,
    Enum anEnum, {
    required String dartPackageName,
  }) {}

  /// Writes all data classes to [indent].
  ///
  /// Can be overridden to add extra code before/after apis.
  void writeDataClasses(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {
    for (final Class classDefinition in root.classes) {
      writeDataClass(
        generatorOptions,
        root,
        indent,
        classDefinition,
        dartPackageName: dartPackageName,
      );
    }
  }

  /// Writes the custom codec to [indent].
  void writeGeneralCodec(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  });

  /// Writes a single data class to [indent].
  void writeDataClass(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent,
    Class classDefinition, {
    required String dartPackageName,
  });

  /// Writes a single class encode method to [indent].
  void writeClassEncode(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent,
    Class classDefinition, {
    required String dartPackageName,
  }) {}

  /// Writes a single class decode method to [indent].
  void writeClassDecode(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent,
    Class classDefinition, {
    required String dartPackageName,
  }) {}

  /// Writes a single class decode method to [indent].
  void writeClassEquality(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent,
    Class classDefinition, {
    required String dartPackageName,
  }) {}

  /// Writes all apis to [indent].
  ///
  /// Can be overridden to add extra code before/after classes.
  void writeApis(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {
    for (final Api api in root.apis) {
      switch (api) {
        case AstHostApi():
          writeHostApi(
            generatorOptions,
            root,
            indent,
            api,
            dartPackageName: dartPackageName,
          );
        case AstFlutterApi():
          writeFlutterApi(
            generatorOptions,
            root,
            indent,
            api,
            dartPackageName: dartPackageName,
          );
        case AstProxyApi():
          writeProxyApi(
            generatorOptions,
            root,
            indent,
            api,
            dartPackageName: dartPackageName,
          );
        case AstEventChannelApi():
          writeEventChannelApi(
            generatorOptions,
            root,
            indent,
            api,
            dartPackageName: dartPackageName,
          );
      }
    }
  }

  /// Writes a single Flutter Api to [indent].
  void writeFlutterApi(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent,
    AstFlutterApi api, {
    required String dartPackageName,
  });

  /// Writes a single Host Api to [indent].
  void writeHostApi(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent,
    AstHostApi api, {
    required String dartPackageName,
  });

  /// Writes the implementation of an `InstanceManager` to [indent].
  void writeInstanceManager(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {}

  /// Writes the implementation of the API for the `InstanceManager` to
  /// [indent].
  void writeInstanceManagerApi(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {}

  /// Writes the base codec to be used by all ProxyApis.
  ///
  /// This codec should use `128` as the identifier for objects that exist in
  /// an `InstanceManager`. The write implementation should convert an instance
  /// to an identifier. The read implementation should covert the identifier
  /// to an instance.
  ///
  /// This will serve as the default codec for all ProxyApis. If a ProxyApi
  /// needs to create its own codec (it has methods/fields/constructor that use
  /// a data class) it should extend this codec and not `StandardMessageCodec`.
  void writeProxyApiBaseCodec(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent,
  ) {}

  /// Writes a single Proxy Api to [indent].
  void writeProxyApi(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent,
    AstProxyApi api, {
    required String dartPackageName,
  }) {}

  /// Writes a single event channel Api to [indent].
  void writeEventChannelApi(
    PigeonInternalOptions generatorOptions,
    Root root,
    Indent indent,
    AstEventChannelApi api, {
    required String dartPackageName,
  }) {}
}
