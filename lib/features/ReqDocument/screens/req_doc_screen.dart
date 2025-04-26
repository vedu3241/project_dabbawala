// import 'dart:io';

// import 'package:dabbawala/utils/constants/used_constants.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get_storage/get_storage.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:insta_image_viewer/insta_image_viewer.dart';
// // import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class DocumentRequestScreen extends StatefulWidget {
//   // User ID is passed to the screen
//   // final String userId;

//   const DocumentRequestScreen({super.key});

//   @override
//   _DocumentRequestScreenState createState() => _DocumentRequestScreenState();
// }

// class _DocumentRequestScreenState extends State<DocumentRequestScreen> {
//   bool _isLoading = true;
//   bool _isRequesting = false;
//   String _status = "none"; // none, pending, completed, error
//   String? _docLink;
//   String? _documentId;

//   String userId = GetStorage().read('user_id');

//   @override
//   void initState() {
//     super.initState();
//     _checkDocumentStatus();
//   }

//   Future<void> _checkDocumentStatus() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse('${UsedConstants.baseUrl}/dab/document/getDocument/$userId'),
//       );

//       if (response.statusCode == 200) {
//         print("get doc 200");
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['docDetails'] != null &&
//             jsonResponse['docDetails'].length > 0) {
//           final document = jsonResponse['docDetails'][0];
//           setState(() {
//             _documentId = document['id'];
//             _status = document['status'];
//             _docLink = document['doc_link'];
//           });
//         } else {
//           setState(() {
//             _status = "none";
//           });
//         }
//       } else {
//         setState(() {
//           _status = "error";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _status = "error";
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _requestDocument() async {
//     setState(() {
//       _isRequesting = true;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('${UsedConstants.baseUrl}/dab/document/reqDocument/$userId'),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['data'] != null && jsonResponse['data'].length > 0) {
//           final document = jsonResponse['data'][0];
//           setState(() {
//             _documentId = document['id'];
//             _status = document['status'];
//             _docLink = document['doc_link'];
//           });
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to request document')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         _isRequesting = false;
//       });
//     }
//   }

//   Future<String?> downloadPngFromUrl(String url) async {
//     try {
//       // Check if the URL is valid
//       if (!url.startsWith('http')) {
//         return 'Invalid URL format';
//       }

//       // Request storage permission on Android
//       if (!kIsWeb && Platform.isAndroid) {
//         var status = await Permission.storage.request();
//         if (!status.isGranted) {
//           return 'Storage permission denied';
//         }
//       }

//       // Get the file name from the URL
//       String fileName = url.split('/').last;

//       // Get the download directory
//       Directory? directory;
//       if (Platform.isAndroid) {
//         directory = await getExternalStorageDirectory();
//       } else if (Platform.isIOS) {
//         directory = await getApplicationDocumentsDirectory();
//       } else {
//         directory = await getDownloadsDirectory();
//       }

//       if (directory == null) {
//         return 'Unable to access download directory';
//       }

//       // Create the file path
//       String filePath = '${directory.path}/$fileName';

//       // Download the file
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         // Write the file
//         File file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);
//         return filePath;
//       } else {
//         return 'Failed to download file: ${response.statusCode}';
//       }
//     } catch (e) {
//       return 'Error downloading file: $e';
//     }
//   }

//   void downloadImage() async {
//     String url = _docLink!;
//     String? result = await downloadPngFromUrl(url);

//     if (result != null &&
//         !result.startsWith('Error') &&
//         !result.startsWith('Failed')) {
//       print('File downloaded successfully to: $result');
//       Get.snackbar("Success", "File downloaded successfully");
//     } else {
//       print('Download failed: $result');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Document Request'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _checkDocumentStatus,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Card(
//                     color: Colors.white,
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Document Status',
//                           ),
//                           SizedBox(height: 16),
//                           _buildStatusInfo(),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16),

//                   // Document preview section - only shown when document is completed
//                   if (_status == "Completed" && _docLink != null)
//                     Expanded(
//                       child: Card(
//                         color: Colors.white,
//                         elevation: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 8.0, bottom: 8.0),
//                                 child: Text(
//                                   'Document Preview',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   child: InstaImageViewer(
//                                     child: Image.network(
//                                       _docLink!,
//                                       fit: BoxFit.contain,
//                                       loadingBuilder:
//                                           (context, child, loadingProgress) {
//                                         if (loadingProgress == null)
//                                           return child;
//                                         return Center(
//                                           child: CircularProgressIndicator(
//                                             value: loadingProgress
//                                                         .expectedTotalBytes !=
//                                                     null
//                                                 ? loadingProgress
//                                                         .cumulativeBytesLoaded /
//                                                     loadingProgress
//                                                         .expectedTotalBytes!
//                                                 : null,
//                                           ),
//                                         );
//                                       },
//                                       errorBuilder:
//                                           (context, error, stackTrace) {
//                                         return Center(
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Icon(Icons.error,
//                                                   color: Colors.red, size: 48),
//                                               SizedBox(height: 8),
//                                               Text('Failed to load document',
//                                                   style: TextStyle(
//                                                       color: Colors.red)),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                   SizedBox(height: 16),
//                   _buildActionButton(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildStatusInfo() {
//     switch (_status) {
//       case "none":
//         return Text(
//             'No document request found. Click the button below to request a document.');
//       case "pending":
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Your document request is being processed.'),
//             SizedBox(height: 8),
//             Text('Request ID: $_documentId'),
//             SizedBox(height: 8),
//             Text('Status: Pending', style: TextStyle(color: Colors.orange)),
//           ],
//         );
//       case "Completed":
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Your document is ready for download.'),
//             SizedBox(height: 8),
//             Text('Request ID: $_documentId'),
//             SizedBox(height: 8),
//             Text('Status: Completed', style: TextStyle(color: Colors.green)),
//           ],
//         );
//       case "error":
//         return Text(
//           'Error loading document status. Please try again later.',
//           style: TextStyle(color: Colors.red),
//         );
//       default:
//         return Text('Unknown status: $_status');
//     }
//   }

//   Widget _buildActionButton() {
//     if (_status == "none") {
//       return ElevatedButton(
//         onPressed: _isRequesting ? null : _requestDocument,
//         style: ElevatedButton.styleFrom(
//           padding: EdgeInsets.symmetric(vertical: 12),
//         ),
//         child: _isRequesting
//             ? Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Text('Requesting...'),
//                 ],
//               )
//             : Text('Request Income Certificate'),
//       );
//     } else if (_status == "pending") {
//       return ElevatedButton(
//         onPressed: _checkDocumentStatus,
//         style: ElevatedButton.styleFrom(
//           padding: EdgeInsets.symmetric(vertical: 12),
//         ),
//         child: Text('Check Status'),
//       );
//     } else if (_status == "Completed" && _docLink != null) {
//       return ElevatedButton(
//         onPressed: downloadImage,
//         style: ElevatedButton.styleFrom(
//           padding: EdgeInsets.symmetric(vertical: 12),
//         ),
//         child: Text('Download Document'),
//       );
//     } else {
//       return ElevatedButton(
//         onPressed: _checkDocumentStatus,
//         style: ElevatedButton.styleFrom(
//           padding: EdgeInsets.symmetric(vertical: 12),
//         ),
//         child: Text('Refresh'),
//       );
//     }
//   }
// }

import 'dart:io';

import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insta_image_viewer/insta_image_viewer.dart';
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
          const SnackBar(content: Text('Failed to request document')),
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
      Get.snackbar(
        "Success",
        "Document downloaded successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 3),
      );
    } else {
      print('Download failed: $result');
      Get.snackbar(
        "Failed",
        "Document download failed. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        icon: const Icon(Icons.error, color: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Request',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkDocumentStatus,
            tooltip: 'Refresh Status',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading document status...',
                      style: TextStyle(color: Colors.grey, fontSize: 16))
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade50, Colors.white],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Card
                    _buildStatusCard(),

                    const SizedBox(height: 16),

                    // Document preview section - only shown when document is completed
                    if (_status == "Completed" && _docLink != null)
                      Expanded(child: _buildDocumentPreview()),

                    const SizedBox(height: 16),

                    // Action Button
                    _buildActionButton(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatusCard() {
    Color cardColor;
    IconData statusIcon;

    switch (_status) {
      case "Completed":
        cardColor = Colors.green.shade50;
        statusIcon = Icons.check_circle;
        break;
      case "pending":
        cardColor = Colors.orange.shade50;
        statusIcon = Icons.pending;
        break;
      case "error":
        cardColor = Colors.red.shade50;
        statusIcon = Icons.error;
        break;
      default:
        cardColor = Colors.blue.shade50;
        statusIcon = Icons.info_outline;
    }

    return Card(
      color: cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  statusIcon,
                  color: _getStatusColor(),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Document Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentPreview() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.document_scanner, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Document Preview',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: InstaImageViewer(
                    child: Image.network(
                      _docLink!,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              const Text('Loading document...',
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 64),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load document',
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please try refreshing the page',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (_status == "Completed" && _docLink != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Tap on image to enlarge',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (_status) {
      case "Completed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "error":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusInfo() {
    switch (_status) {
      case "none":
        return const Text(
          'No document request found. Click the button below to request a document.',
          style: TextStyle(fontSize: 15),
        );
      case "pending":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your document request is being processed.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.request_page, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Request ID: $_documentId',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.pending, color: Colors.orange, size: 16),
                  const SizedBox(width: 6),
                  const Text(
                    'Status: Pending',
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        );
      case "Completed":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your document is ready for download.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.request_page, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Request ID: $_documentId',
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis, // Shows "..." for overflow
                    maxLines: 1, // Only one line allowed
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Status: Completed',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        );
      case "error":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Error loading document status. Please try again later.',
              style: TextStyle(color: Colors.red, fontSize: 15),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _checkDocumentStatus,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ],
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
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
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Requesting...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.request_page),
                  SizedBox(width: 8),
                  Text(
                    'Request Income Certificate',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      );
    } else if (_status == "pending") {
      return ElevatedButton(
        onPressed: _checkDocumentStatus,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh),
            SizedBox(width: 8),
            Text(
              'Check Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else if (_status == "Completed" && _docLink != null) {
      return ElevatedButton(
        onPressed: downloadImage,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download),
            SizedBox(width: 8),
            Text(
              'Download Document',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: _checkDocumentStatus,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh),
            SizedBox(width: 8),
            Text(
              'Refresh',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
  }
}
