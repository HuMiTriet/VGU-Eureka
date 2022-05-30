import 'dart:developer';
import 'dart:io';

import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditImagePage extends StatefulWidget {
  final ImageSource imageSource;

  final AuthUser user;
  const EditImagePage({Key? key, required this.imageSource, required this.user})
      : super(key: key);

  @override
  EditImagePageState createState() => EditImagePageState();
}

class EditImagePageState extends State<EditImagePage> {
  final _updateFailSnackBar = const SnackBar(
    content: Text('Update Image Failed.'),
  );

  final _updateSuccessSnackBar = const SnackBar(
    content: Text('Image Updated.'),
  );

  File? image;
   var imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('upload image')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
              width: 330,
              child: Text(
                'Upload a photo of yourself:',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                  width: 330,
                  child: GestureDetector(
                      onTap: () async {
                        pickImage();
                      },
                      child: image != null
                          ? Image.file(
                              image!,
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.fitHeight,
                            )
                          : Container(
                              decoration: BoxDecoration(color: Colors.red[200]),
                              width: 200,
                              height: 200,
                              child: Icon(
                                Icons.image,
                                color: Colors.grey[800],
                              ),
                            )))),
          Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (image == null) return;

                        final firebaseStorage = FirebaseStorage.instance;

                        try {

                          var snapshot = await firebaseStorage
                              .ref()
                              .child('images/${widget.user.uid}')
                              .putFile(image!);
                          log(widget.user.uid);

                          var downloadUrl = await snapshot.ref.getDownloadURL();
                          setState(() {
                            imageUrl = downloadUrl;
                          });
                        } on FirebaseException catch (e) {
                          log('${e.message}');
                        }

                        if (imageUrl != null) {
                          log('image url: ' + imageUrl);
                          AuthService.firebase().updatePhotoURL(imageUrl);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(_updateSuccessSnackBar);
                        } else {
                          log('fail to update image');
                          ScaffoldMessenger.of(context)
                              .showSnackBar(_updateFailSnackBar);
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  Future<File?> pickImage() async {
    final _picker = ImagePicker();
    PickedFile image;

    var _image = await _picker.pickImage(source: widget.imageSource);

    setState(() {
      this.image = File(_image!.path);
    });
  }
}
