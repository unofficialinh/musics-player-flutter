import 'package:path_provider/path_provider.dart';

Future<String> getDownloadPath() async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}


