// import 'dart:io';
// // import 'package:dabbawala/Customer/CustomerLogin/pages/Navigation/controller/custNavbar.dart';
// import 'package:dabbawala/features/HomePage/controller/posts_get_controller.dart';
// import 'package:dabbawala/utils/constants/used_constants.dart';
// import 'package:dabbawala/features/dab_nav_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class CreatePostPage extends StatefulWidget {
//   const CreatePostPage({Key? key}) : super(key: key);

//   @override
//   _CreatePostPageState createState() => _CreatePostPageState();
// }

// class _CreatePostPageState extends State<CreatePostPage> {
//   final TextEditingController _captionController = TextEditingController();
//   File? _selectedImage;
//   bool _isLoading = false;

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? pickedImage = await picker.pickImage(source: source);

//       if (pickedImage != null) {
//         setState(() {
//           _selectedImage = File(pickedImage.path);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error selecting image: $e')),
//       );
//     }
//   }

//   void _showImageSourceOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Take a Photo'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _submitPost() async {
//     if (_selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an image')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Create a URI
//       String url = '${UsedConstants.baseUrl}/posts';

//       // Prepare the request headers
//       Map<String, String> headers = {
//         'Authorization': 'Bearer ${GetStorage().read('access_token')}',
//       };

//       // Prepare the multipart request
//       var request = http.MultipartRequest('POST', Uri.parse(url));

//       // Add headers to the request
//       request.headers.addAll(headers);

//       // Add caption and status to the body
//       request.fields['caption'] = _captionController.text;
//       request.fields['status'] = 'public';

//       // Add the image file to the request
//       var imageFile = await http.MultipartFile.fromPath(
//         'image', // The key for the image in the backend (may be different)
//         _selectedImage!.path,
//       );
//       request.files.add(imageFile);

//       // Send the request
//       var response = await request.send();

//       // Check if the request was successful
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         _captionController.clear();
//         _selectedImage = null;
//         // PostsController postsController = Get.find<PostsController>();
//         // postsController.fetchPosts();
//         final NavController navController = Get.find<NavController>();
//         navController.changeTab(0);
//       } else {
//         // Failure - handle the error
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   'Failed to create post. Status code: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error creating post: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _captionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Post'),
//         actions: [
//           _isLoading
//               ? const Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2,
//                   ),
//                 )
//               : TextButton(
//                   onPressed: _submitPost,
//                   child: Text(
//                     'Post',
//                     style: GoogleFonts.roboto(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             GestureDetector(
//               onTap: _showImageSourceOptions,
//               child: Container(
//                 height: 300,
//                 color: Colors.grey[200],
//                 child: _selectedImage != null
//                     ? Image.file(
//                         _selectedImage!,
//                         fit: BoxFit.cover,
//                       )
//                     : Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.add_photo_alternate,
//                               size: 80,
//                               color: Colors.grey,
//                             ),
//                             SizedBox(height: 12),
//                             Text(
//                               'Tap to select photo',
//                               style: GoogleFonts.roboto(
//                                 color: Colors.grey,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 controller: _captionController,
//                 decoration: const InputDecoration(
//                   hintText: 'Write a caption...',
//                   border: InputBorder.none,
//                 ),
//                 maxLines: 5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// UI update
import 'dart:io';
// import 'package:dabbawala/Customer/CustomerLogin/pages/Navigation/controller/custNavbar.dart';
import 'package:dabbawala/features/HomePage/controller/posts_get_controller.dart';
import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:dabbawala/features/dab_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _captionController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: source);

      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitPost() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create a URI
      String url = '${UsedConstants.baseUrl}/posts';

      // Prepare the request headers
      Map<String, String> headers = {
        'Authorization': 'Bearer ${GetStorage().read('access_token')}',
      };

      // Prepare the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers to the request
      request.headers.addAll(headers);

      // Add caption and status to the body
      request.fields['caption'] = _captionController.text;
      request.fields['status'] = 'public';

      // Add the image file to the request
      var imageFile = await http.MultipartFile.fromPath(
        'image', // The key for the image in the backend (may be different)
        _selectedImage!.path,
      );
      request.files.add(imageFile);

      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        _captionController.clear();
        _selectedImage = null;
        // PostsController postsController = Get.find<PostsController>();
        // postsController.fetchPosts();
        final NavController navController = Get.find<NavController>();
        navController.changeTab(0);
      } else {
        // Failure - handle the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to create post. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating post: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
        actions: [
          _isLoading
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: _submitPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(
                      'Post',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _showImageSourceOptions,
                child: Container(
                  height: 350,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add_photo_alternate_rounded,
                                size: 60,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Tap to add a photo',
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Choose from gallery or take a new one',
                              style: GoogleFonts.poppins(
                                color: Colors.black38,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Caption',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _captionController,
                      decoration: InputDecoration(
                        hintText: 'Write something about your post...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.black26,
                          fontSize: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: EdgeInsets.all(16),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      maxLines: 6,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
