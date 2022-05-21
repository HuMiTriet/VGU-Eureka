import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';

class EditImagePage extends StatefulWidget {
  EditImagePage({Key? key, required this.imageSource}) : super(key: key);

  final imageSource;

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  File? image;
  var imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('upload image')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
              width: 330,
              child: Text(
                "Upload a photo of yourself:",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                  width: 330,
                  child: GestureDetector(
                      onTap: () async {
                        log('out side upload image');
                        uploadImage();
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
              padding: EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final _firebaseStorage = FirebaseStorage.instance;
                        try {
                          var snapshot = await _firebaseStorage
                              .ref()
                              .child('images/16610')
                              .putFile(image!);
                          var downloadUrl = await snapshot.ref.getDownloadURL();
                          setState(() {
                            imageUrl = downloadUrl;
                          });
                        } on FirebaseException catch (e) {}
                        log('image url: ' + imageUrl);
                        FirebaseAuth.instance.currentUser?.updatePhotoURL(
                            imageUrl ??
                                'https://static.wikia.nocookie.net/gintama/images/1/1a/Childkagura.png/revision/latest/scale-to-width-down/704?cb=20150206061302');
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

  Future<File?> uploadImage() async {
    final _picker = ImagePicker();
    PickedFile image;

    XFile? _image = await _picker.pickImage(source: widget.imageSource);

    setState(() {
      this.image = File(_image?.path ?? '');
    });
  }
}
