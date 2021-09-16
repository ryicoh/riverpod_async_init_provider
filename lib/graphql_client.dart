import 'package:riverpod/riverpod.dart';

// GraphqlClient type is dummy
typedef GraphqlClient = String;

final graphqlClientProvider =
    StateNotifierProvider<GraphqlClientStateNotifier, AsyncValue<String>>((_) {
  return GraphqlClientStateNotifier();
});

class GraphqlClientStateNotifier
    extends StateNotifier<AsyncValue<GraphqlClient>> {
  GraphqlClientStateNotifier() : super(const AsyncValue.loading());

  Future<void> fetch1() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(Duration(seconds: 1));
      return "fetch1";
    });
  }

  Future<void> fetch2() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(Duration(seconds: 1));
      return "fetch2";
    });
  }

  static bool initCalled = false;
  static Future<void> init(ProviderRefBase ref) async {
    if (!initCalled) {
      print('call init');
      await ref.read(graphqlClientProvider.notifier).fetch1();
      initCalled = true;
    }
  }

  static Future<String> getGraphqlClient(ProviderRefBase ref) async {
    init(ref);

    return ref.watch(graphqlClientProvider).data?.value ?? '';
  }

  static AsyncValue<String> getGraphqlClientAsyncValue(ProviderRefBase ref) {
    init(ref);

    return ref.watch(graphqlClientProvider);
  }
}
