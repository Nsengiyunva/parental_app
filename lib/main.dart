import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vpn_controller.dart';
import 'blocklist.dart';
import 'browser_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VpnController()),
        Provider(create: (_) => Blocklist()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parental Control',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vpn = Provider.of<VpnController>(context);
    final blocklist = Provider.of<Blocklist>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Parental Control')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('VPN Status: ${vpn.isRunning ? "Running" : "Stopped"}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => vpn.isRunning ? vpn.stopVpn() : vpn.startVpn(),
              child: Text(vpn.isRunning ? 'Stop VPN' : 'Start VPN'),
            ),
            const SizedBox(height: 20),
            const Text('Blocked Domains:'),
            Expanded(
              child: ListView(
                children: blocklist.domains
                    .map((d) => ListTile(title: Text(d)))
                    .toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BrowserScreen()),
                );
              },
              child: const Text('Open Child Browser'),
            ),
          ],
        ),
      ),
    );
  }
}
