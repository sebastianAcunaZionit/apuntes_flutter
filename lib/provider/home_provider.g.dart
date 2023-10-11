// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getListHash() => r'9db1771d2e7b1f8b2be9a2d1622976777ae8207c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getList].
@ProviderFor(getList)
const getListProvider = GetListFamily();

/// See also [getList].
class GetListFamily extends Family<AsyncValue<List<Note>>> {
  /// See also [getList].
  const GetListFamily();

  /// See also [getList].
  GetListProvider call([
    int page = 0,
  ]) {
    return GetListProvider(
      page,
    );
  }

  @override
  GetListProvider getProviderOverride(
    covariant GetListProvider provider,
  ) {
    return call(
      provider.page,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getListProvider';
}

/// See also [getList].
class GetListProvider extends AutoDisposeFutureProvider<List<Note>> {
  /// See also [getList].
  GetListProvider([
    int page = 0,
  ]) : this._internal(
          (ref) => getList(
            ref as GetListRef,
            page,
          ),
          from: getListProvider,
          name: r'getListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getListHash,
          dependencies: GetListFamily._dependencies,
          allTransitiveDependencies: GetListFamily._allTransitiveDependencies,
          page: page,
        );

  GetListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
  }) : super.internal();

  final int page;

  @override
  Override overrideWith(
    FutureOr<List<Note>> Function(GetListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetListProvider._internal(
        (ref) => create(ref as GetListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Note>> createElement() {
    return _GetListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetListProvider && other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetListRef on AutoDisposeFutureProviderRef<List<Note>> {
  /// The parameter `page` of this provider.
  int get page;
}

class _GetListProviderElement
    extends AutoDisposeFutureProviderElement<List<Note>> with GetListRef {
  _GetListProviderElement(super.provider);

  @override
  int get page => (origin as GetListProvider).page;
}

String _$homeProvHash() => r'19e688d1307915f93afaaeb0865e1c458e46fa52';

/// See also [HomeProv].
@ProviderFor(HomeProv)
final homeProvProvider =
    AutoDisposeAsyncNotifierProvider<HomeProv, HomeState>.internal(
  HomeProv.new,
  name: r'homeProvProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$homeProvHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeProv = AutoDisposeAsyncNotifier<HomeState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
