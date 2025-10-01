import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'blocklist.dart';
import 'package:provider/provider.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  final TextEditingController _urlController = TextEditingController(
    text: 'https://www.google.com',
  );
  String? pageContent;
  bool blocked = false;
  List<String> history = [];
  int currentIndex = -1;

  Future<void> loadPage(String url) async {
    final blocklist = Provider.of<Blocklist>(context, listen: false);
    for (var domain in blocklist.domains) {
      if (url.contains(domain)) {
        setState(() {
          blocked = true;
          pageContent = null;
        });
        return;
      }
    }

    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          blocked = false;
          pageContent = response.body;
          // history
          history = history.sublist(0, currentIndex + 1);
          history.add(url);
          currentIndex++;
        });
      } else {
        setState(() {
          blocked = false;
          pageContent = "<h2>Error: ${response.statusCode}</h2>";
        });
      }
    } catch (e) {
      setState(() {
        blocked = false;
        pageContent = "<h2>Failed to load page</h2>";
      });
    }
  }

  void goBack() {
    if (currentIndex > 0) {
      currentIndex--;
      _urlController.text = history[currentIndex];
      loadPage(history[currentIndex]);
    }
  }

  void goForward() {
    if (currentIndex + 1 < history.length) {
      currentIndex++;
      _urlController.text = history[currentIndex];
      loadPage(history[currentIndex]);
    }
  }

  @override
  void initState() {
    super.initState();
    loadPage(_urlController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter URL',
          ),
          onSubmitted: (url) => loadPage(url),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.arrow_back), onPressed: goBack),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: goForward,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => loadPage(_urlController.text),
          ),
        ],
      ),
      body: blocked
          ? Center(
              child: Text(
                "This site is blocked by parental controls.",
                style: const TextStyle(color: Colors.red, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            )
          : pageContent != null
          ? SingleChildScrollView(child: Html(data: pageContent))
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
