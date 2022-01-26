import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/provider/provider.dart';
import 'package:nearby_test/screens/graph_screen.dart';
import 'package:nearby_test/script/script.dart';
import 'package:nearby_test/widgets/dialogs/dialogs.dart';

///The main entry point for a dart application
///
///Adds the widget NearbyTestApp to the flutter engine
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [
          Locale('en'),
          Locale('de'),
        ],
        home: const NearbyTestApp(),
      ),
    ),
  );
}

///Root of the application
///
///Paints the "Advertise" and "Discover" buttons to the screen
///Adds AppBar with text and "Stop" button
///Asks user for required permissions and nickname
class NearbyTestApp extends ConsumerStatefulWidget {
  const NearbyTestApp({Key? key}) : super(key: key);

  @override
  ConsumerState<NearbyTestApp> createState() => _NearbyTestAppState();
}

class _NearbyTestAppState extends ConsumerState<NearbyTestApp> {
  final nearby = Nearby();

  Future<void> initialise() async {
    if (!await nearby.checkLocationPermission()) {
      await showDialog(
        context: context,
        builder: (context) => LocationDialog(),
      );
    }
    await showDialog(
      context: context,
      builder: (context) => const NickNameDialog(),
    );
    await nearby.enableLocationServices();
    swithcAdDi();
  }

  Future<void> swithcAdDi() async {
    while (true) {
      advertise(nearby, ref);
      await Future.delayed(const Duration(seconds: 5));
      discover(nearby, ref);
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
    final logs = ref.watch(logProvider).logs;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            onPressed: () async {
              ref.refresh(graphProvider);
              ref.read(meProvider).ownId = 'unknown';
              ref.read(logProvider).clear();
              await nearby.stopAdvertising();
              await nearby.stopDiscovery();
            },
            icon: const Icon(Icons.stop),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GraphScreen(),
              ),
            ),
            icon: const Icon(Icons.auto_graph),
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return ListTile(
            title: Text(log),
          );
        },
      ),
    );
  }
}
