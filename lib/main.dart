import 'package:file_downloader/core/utilities/file_downloader.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "File_downloader",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> pdfUrls = [
    "https://www.sharedfilespro.com/shared-files/38/?sample.pdf",
    "https://morth.nic.in/sites/default/files/dd12-13_0.pdf",
    "https://icseindia.org/document/sample.pdf",
    'https://cartographicperspectives.org/index.php/journal/article/view/cp13-full/pdf'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Files"),
      ),
      body: ListView.builder(
          itemCount: pdfUrls.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("pdf-${index}"),
              trailing: InkWell(
                  onTap: () async {
                    FileDownloader fileDownloader = FileDownloader();
                    fileDownloader.downloadFile(
                      pdfUrls[index],
                      'pdf-${index}',
                      (p0, p1) {},
                    );
                  },
                  child: const Icon(Icons.download)),
            );
          }),
    );
  }
}
