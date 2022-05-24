import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/views/profile/Widgets/edit_image_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

EditImageDialog(BuildContext context, AuthUser user) {
  // Create SimpleDialog
  var dialog = SimpleDialog(
    title: const Text('Upload Image'),
    children: <Widget>[
      SimpleDialogOption(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditImagePage(imageSource: ImageSource.camera, user: user),
              ),
            );
            // Navigator.pop(context);
          },
          child: Text('Camera')),
      SimpleDialogOption(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditImagePage(imageSource: ImageSource.gallery, user: user),
            ),
          );
          // Navigator.pop(context);
        },
        child: Text('Gallery'),
      ),
    ],
  );

  // Call showDialog function to show dialog.
  Future<void> futureValue = showDialog(
      context: context,
      builder: (context) {
        return dialog;
      });
}
