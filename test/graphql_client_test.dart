import 'package:riverpod/riverpod.dart';
import 'package:riverpod_async_init_provider/graphql_client.dart';
import 'package:test/test.dart';

void main() {
  group("GraphqlClientStateNotifier", () {
    group("used inside Widget", () {
      late AsyncValue<String> cli;
      final prov = Provider((ref) {
        cli = GraphqlClientStateNotifier.getGraphqlClientAsyncValue(ref);
        print('cli: $cli');
      });

      final container = ProviderContainer();
      container.listen(prov, (value) {});

      test("initalize", () async {
        expect(cli, equals(AsyncValue.loading()));
        await Future.delayed(Duration(seconds: 2));
        expect(cli, equals(AsyncValue.data("fetch1")));
      });

      test("fetch with await", () async {
        expect(cli, equals(AsyncValue.data("fetch1")));

        await container.read(graphqlClientProvider.notifier).fetch2();
        await Future.delayed(Duration(seconds: 2));
        expect(cli, equals(AsyncValue.data("fetch2")));
      });

      test("fetch without await", () async {
        expect(cli, equals(AsyncValue.data("fetch2")));

        container.read(graphqlClientProvider.notifier).fetch1();
        await Future.delayed(Duration(milliseconds: 500));
        expect(cli, equals(AsyncValue.loading()));
        await Future.delayed(Duration(milliseconds: 600));
        expect(cli, equals(AsyncValue.data("fetch1")));
      });
    });

    group("used outside Widget", () {
      late String cli;

      final prov = Provider((ref) async {
        cli = await GraphqlClientStateNotifier.getGraphqlClient(ref);
        print('cli: $cli');
      });

      final container = ProviderContainer();
      container.listen(prov, (value) {});

      test("initalize", () async {
        await Future.delayed(Duration(seconds: 2));
        expect(cli, equals("fetch1"));
      });

      test("fetch with await", () async {
        expect(cli, equals("fetch1"));

        await container.read(graphqlClientProvider.notifier).fetch2();
        await Future.delayed(Duration(seconds: 2));
        expect(cli, equals("fetch2"));
      });

      test("fetch without await", () async {
        expect(cli, equals("fetch2"));

        container.read(graphqlClientProvider.notifier).fetch1();
        await Future.delayed(Duration(milliseconds: 500));
        expect(cli, equals(""));
        await Future.delayed(Duration(milliseconds: 600));
        expect(cli, equals("fetch1"));
      });
    });
  });
}
