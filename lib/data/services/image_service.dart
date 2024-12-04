import 'dart:io';
import 'package:appwrite/appwrite.dart';

Future<String?> uploadFile(File file) async {
  Client client = Client(selfSigned: true);

  client.setProject('674839a900288fa7bb3e');

  Storage storage = Storage(client);
  try {
    final result = await storage.createFile(
      bucketId: '674fa5a2001133726af4',
      fileId: ID.unique(),
      file: InputFile.fromPath(path: file.path),
    );

    // Get the file ID or other details from the result
    print('File uploaded successfully: ${result.$id}');
    return await getImageUrl(
        result.$id); // Return the file ID or any other identifier
  } catch (e) {
    print('Error uploading file: $e');
    return '';
  }
}

Future<String?> getImageUrl(String fileId) async {
  Client client = Client(selfSigned: true);

  client.setProject('674839a900288fa7bb3e');
  Storage storage = Storage(client);

  try {
    // Generate the preview URL
    final String previewUrl = client.endPoint +
        '/storage/buckets/674fa5a2001133726af4/files/$fileId/view?project=674839a900288fa7bb3e&project=674839a900288fa7bb3e&mode=admin';

    print('Preview URL: $previewUrl');
    return previewUrl; // Return the URL
  } catch (e) {
    print('Error fetching file: $e');
    return null; // Return null if there's an error
  }
}
