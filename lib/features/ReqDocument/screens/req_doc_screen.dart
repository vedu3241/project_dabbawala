import 'dart:io';

import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentRequestScreen extends StatefulWidget {
  // User ID is passed to the screen
  // final String userId;

  const DocumentRequestScreen({super.key});

  @override
  _DocumentRequestScreenState createState() => _DocumentRequestScreenState();
}

class _DocumentRequestScreenState extends State<DocumentRequestScreen> {
  bool _isLoading = true;
  bool _isRequesting = false;
  String _status = "none"; // none, pending, completed, error
  String? _docLink;
  String? _documentId;

  String userId = GetStorage().read('user_id');

  @override
  void initState() {
    super.initState();
    _checkDocumentStatus();
  }

  Future<void> _checkDocumentStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${UsedConstants.baseUrl}/dab/document/getDocument/$userId'),
      );

      if (response.statusCode == 200) {
        print("get doc 200");
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['docDetails'] != null &&
            jsonResponse['docDetails'].length > 0) {
          final document = jsonResponse['docDetails'][0];
          setState(() {
            _documentId = document['id'];
            _status = document['status'];
            _docLink = document['doc_link'];
          });
        } else {
          setState(() {
            _status = "none";
          });
        }
      } else {
        setState(() {
          _status = "error";
        });
      }
    } catch (e) {
      setState(() {
        _status = "error";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestDocument() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${UsedConstants.baseUrl}/dab/document/reqDocument/$userId'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null && jsonResponse['data'].length > 0) {
          final document = jsonResponse['data'][0];
          setState(() {
            _documentId = document['id'];
            _status = document['status'];
            _docLink = document['doc_link'];
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to request document')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isRequesting = false;
      });
    }
  }

  Future<String?> downloadPngFromUrl(String url) async {
    try {
      // Check if the URL is valid
      if (!url.startsWith('http')) {
        return 'Invalid URL format';
      }

      // Request storage permission on Android
      if (!kIsWeb && Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          return 'Storage permission denied';
        }
      }

      // Get the file name from the URL
      String fileName = url.split('/').last;

      // Get the download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory();
      }

      if (directory == null) {
        return 'Unable to access download directory';
      }

      // Create the file path
      String filePath = '${directory.path}/$fileName';

      // Download the file
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Write the file
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        return 'Failed to download file: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error downloading file: $e';
    }
  }

  void downloadImage() async {
    String url = _docLink!;
    String? result = await downloadPngFromUrl(url);

    if (result != null &&
        !result.startsWith('Error') &&
        !result.startsWith('Failed')) {
      print('File downloaded successfully to: $result');
      Get.snackbar("Success", "File downloaded successfully");
    } else {
      print('Download failed: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Request'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _checkDocumentStatus,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Document Status',
                          ),
                          SizedBox(height: 16),
                          _buildStatusInfo(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildActionButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusInfo() {
    switch (_status) {
      case "none":
        return Text(
            'No document request found. Click the button below to request a document.');
      case "pending":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your document request is being processed.'),
            SizedBox(height: 8),
            Text('Request ID: $_documentId'),
            SizedBox(height: 8),
            Text('Status: Pending', style: TextStyle(color: Colors.orange)),
          ],
        );
      case "Completed":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your document is ready for download.'),
            SizedBox(height: 8),
            Text('Request ID: $_documentId'),
            SizedBox(height: 8),
            Text('Status: Completed', style: TextStyle(color: Colors.green)),
          ],
        );
      case "error":
        return Text(
          'Error loading document status. Please try again later.',
          style: TextStyle(color: Colors.red),
        );
      default:
        return Text('Unknown status: $_status');
    }
  }

  Widget _buildActionButton() {
    if (_status == "none") {
      return ElevatedButton(
        onPressed: _isRequesting ? null : _requestDocument,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: _isRequesting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('Requesting...'),
                ],
              )
            : Text('Request Document'),
      );
    } else if (_status == "pending") {
      return ElevatedButton(
        onPressed: _checkDocumentStatus,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text('Check Status'),
      );
    } else if (_status == "Completed" && _docLink != null) {
      return ElevatedButton(
        onPressed: downloadImage,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text('Download Document'),
      );
    } else {
      return ElevatedButton(
        onPressed: _checkDocumentStatus,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text('Refresh'),
      );
    }
  }
}
