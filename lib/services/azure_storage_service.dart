// // File: AzureStorageService.dart
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:mime/mime.dart';
// import 'package:path/path.dart' as path;

// class AzureStorageService {
//   static final AzureStorageService _instance = AzureStorageService._internal();
//   factory AzureStorageService() => _instance;
//   AzureStorageService._internal();

//   final String _accountName = 'ibrahimskripsi';
//   final String _containerName = 'uploads';

//   final String _sasTokenGeneratorUrlBase = 'https://banannda.azurewebsites.net/api/generatetoken';
//   final String _functionKey = 'M8cHNJVLupV2Lj40YXmYRmTmFiJy8Z_-ztJ5Uv0TaJxXAzFuT_u_lw==';

//   String get baseUrl => 'https://$_accountName.blob.core.windows.net';

//   Future<String?> _fetchSasToken({String? blobName, required String permissions}) async {
//     try {
//       // BUAT QUERY UNTUK SAS GENERATOR
//       Map<String, String> sasRequestParams = {
//         'containerName': _containerName,
//         'permissions': permissions,
//       };
//       if (blobName != null) {
//         sasRequestParams['blobName'] = blobName;
//       }

//       // BUAT URI UNTUK AZURE FUNCTION
//       Uri functionUri;
//       if (_functionKey.isNotEmpty) {
//         Map<String, String> allParams = Map.from(sasRequestParams);
//         allParams['code'] = _functionKey;
//         functionUri = Uri.parse(_sasTokenGeneratorUrlBase).replace(queryParameters: allParams);
//       } else {
//         // MISAL AUTENTIKASI SEBAGAI ANONYMOUS
//         functionUri = Uri.parse(_sasTokenGeneratorUrlBase).replace(queryParameters: sasRequestParams);
//       }
      
//       print('>>> Flutter: Fetching SAS token from URI: $functionUri');

//       final response = await http.get(functionUri);

//       print('>>> Flutter: SAS Token Response Status: ${response.statusCode}');
//       print('>>> Flutter: SAS Token Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         final sasToken = responseData['sasToken'] as String?; 
//         if (sasToken != null && sasToken.startsWith('?')) {
//           print('>>> Flutter: SAS Token received: $sasToken');
//           return sasToken;
//         } else {
//           print('>>> Flutter: Error: SAS token from backend is invalid or missing in JSON. Response was: ${response.body}');
//           return null;
//         }
//       } else {
//         print('>>> Flutter: Error fetching SAS token from backend. Status: ${response.statusCode}, Body: ${response.body}');
//         return null;
//       }
//     } catch (e, stackTrace) {
//       print('>>> Flutter: Exception while fetching SAS token: $e');
//       print('>>> Flutter: StackTrace: $stackTrace');
//       return null;
//     }
//   }

//    Future<String?> uploadImage(File imageFile, String optName) async {
//     try {
//       final String originalFileName = path.basename(imageFile.path);
//       final String blobName = '${DateTime.now().millisecondsSinceEpoch}_${optName.replaceAll(RegExp(r'\s+'), '_')}_$originalFileName';
//       final String? contentType = lookupMimeType(imageFile.path);

//       if (contentType == null) {
//         print('Error: Could not determine MIME type of the file.');
//         return null;
//       }

//       final String? sasToken = await _fetchSasToken(blobName: blobName, permissions: 'w');
//       if (sasToken == null) {
//         print('Error: Could not obtain SAS token for upload.');
//         return null;
//       }

//       final Uri uploadUrl = Uri.parse('$baseUrl/$_containerName/$blobName$sasToken');
//       final Uint8List fileBytes = await imageFile.readAsBytes();

//       final response = await http.put(
//         uploadUrl,
//         headers: {
//           'x-ms-blob-type': 'BlockBlob',
//           'Content-Type': contentType,
//           'Content-Length': fileBytes.length.toString(),
//           // 'x-ms-version': '2020-08-04', // Jika kapan-kapan dibutuhkan
//         },
//         body: fileBytes,
//       );

//       print('Azure Upload Response Status: ${response.statusCode}');

//       if (response.statusCode == 201) {
//         print('Image uploaded successfully: $blobName');
//         return '$baseUrl/$_containerName/$blobName'; // Tanpa SAS
//       } else {
//         print('Error uploading image: ${response.statusCode}');
//         print('Response body (upload error): ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }

//   Future<List<String>> listImages() async {

//     try {
//       final String? sasTokenList = await _fetchSasToken(permissions: 'l');
//       if (sasTokenList == null) {
//         print('Error: Could not obtain SAS token for listing.');
//         return [];
//       }

//       final response = await http.get(
//         Uri.parse('$baseUrl/$_containerName?restype=container&comp=list$sasTokenList'),
//       );

//       if (response.statusCode == 200) {

//         final xmlResponse = response.body;
//         final List<String> imageUrls = [];
//         final regex = RegExp(r'<Name>(.*?)</Name>');
//         final matches = regex.allMatches(xmlResponse);

//         for (var match in matches) {
//           final blobName = match.group(1)!;
//           // JIKA PERLU FILTRASI GAMBAR
//            if (blobName.toLowerCase().endsWith('.jpg') ||
//               blobName.toLowerCase().endsWith('.jpeg') ||
//               blobName.toLowerCase().endsWith('.png')) {
//             final imageUrlWithSas = await getImageUrl(blobName); // FETCH GAMBARNYA
//             if (imageUrlWithSas != null) {
//               imageUrls.add(imageUrlWithSas);
//             }
//           }
//         }
//         return imageUrls;
//       } else {
//         print('Error listing blobs: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         return [];
//       }
//     } catch (e) {
//       print('Error listing images: $e');
//       return [];
//     }
//   }

//   Future<void> deleteImage(String blobUrlOrName) async {
//     // JIKA BUTUH DELESI
//     String blobName;
//     if (blobUrlOrName.startsWith('http')) {
//       blobName = extractBlobName(blobUrlOrName);
//     } else {
//       blobName = blobUrlOrName;
//     }
    
//     if (blobName.isEmpty) {
//         throw Exception('Invalid blob name or URL provided.');
//     }
//     final String? sasToken = await _fetchSasToken(blobName: blobName, permissions: 'd');
//     if (sasToken == null) {
//       throw Exception('Gagal mendapatkan SAS token untuk menghapus gambar.');
//     }

//     final url = '$baseUrl/$_containerName/$blobName$sasToken';
//     final response = await http.delete(Uri.parse(url));

//     if (response.statusCode != 202) { // 202 Accepted
//       throw Exception('Gagal menghapus gambar di Azure: ${response.statusCode} - ${response.body}');
//     }
//     print('Image deleted successfully: $blobName');
//   }

//   String extractBlobName(String url) {

//     try {
//       final uri = Uri.parse(url);
//       final segments = uri.pathSegments;
//       if (segments.length > 1 && segments[0] == _containerName) {
//         return segments.sublist(1).join('/');
//       }
//       if (segments.isNotEmpty) return segments.last;
//       return '';
//     } catch (e) {
//       print("Error parsing URL to extract blob name: $e");
//       return '';
//     }
//   }

//   Future<String?> getImageUrl(String blobName) async {

//     if (blobName.isEmpty) return null;
//     final String? sasToken = await _fetchSasToken(blobName: blobName, permissions: 'r');
//     if (sasToken == null) {
//       print('Error: Could not obtain SAS token for reading blob $blobName.');
//       return null;
//     }
//     return '$baseUrl/$_containerName/$blobName$sasToken';
//   }
// }