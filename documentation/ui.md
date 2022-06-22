
# Commonly used widgets 
## Basic widgets
- [Text](https://api.flutter.dev/flutter/widgets/Text-class.html)

     + The Text widget lets you create a run of styled text within your application.
- [Row](https://api.flutter.dev/flutter/widgets/Row-class.html), [Column](https://api.flutter.dev/flutter/widgets/Column-class.html)

     + These flex widgets let you create flexible layouts in both the horizontal (Row) and vertical (Column) directions. The design of these objects is based on the web’s flexbox layout model.

- [Container](https://api.flutter.dev/flutter/widgets/Container-class.html)

    + The Container widget lets you create a rectangular visual element. A container can be decorated with a BoxDecoration, such as a background, a border, or a shadow. A Container can also have margins, padding, and constraints applied to its size. In addition, a Container can be transformed in three dimensional space using a matrix.

- [Padding](https://api.flutter.dev/flutter/widgets/Padding-class.html)

    + A widget that insets its child by the given padding.
    When passing layout constraints to its child, padding shrinks the constraints by the given padding, causing the child to layout at a smaller size. Padding then sizes itself to its child's size, inflated by the padding, effectively creating empty space around the child.

- [Image](https://api.flutter.dev/flutter/widgets/Image-class.html)
   
   + A widget that display the images.

   + The following image formats are supported: JPEG, PNG, GIF, Animated GIF, WebP, Animated WebP, BMP, and WBMP.


## [Interative widgets](https://docs.flutter.dev/development/ui/interactive):
- [Checkbox](https://api.flutter.dev/flutter/material/Checkbox-class.html)
- [TextButton](https://api.flutter.dev/flutter/material/TextButton-class.html)
- [FloatingActionButton](https://api.flutter.dev/flutter/material/FloatingActionButton-class.html)
- [IconButton](https://api.flutter.dev/flutter/material/IconButton-class.html)
- [ElevatedButton](https://api.flutter.dev/flutter/material/ElevatedButton-class.html)
- [Switch](https://api.flutter.dev/flutter/material/Switch-class.html)
- [TextField](https://api.flutter.dev/flutter/material/TextField-class.html)
- [showModalBottomSheet](https://api.flutter.dev/flutter/material/showModalBottomSheet.html)
- [AlertDialog](https://api.flutter.dev/flutter/material/AlertDialog-class.html)

# Build layouts:
## [Layout a widgets](https://docs.flutter.dev/development/ui/layout#lay-out-a-widget)

## [Lay out multiple widgets vertically and horizontally:](https://docs.flutter.dev/development/ui/layout#lay-out-multiple-widgets-vertically-and-horizontally)
Our app use a [Row](https://api.flutter.dev/flutter/widgets/Row-class.html) widget to arrange widgets horizontally, and a [Column](https://api.flutter.dev/flutter/widgets/Column-class.html) widget to arrange widgets vertically.

- [Aligning widgets](https://docs.flutter.dev/development/ui/layout#aligning-widgets):

   + Our app control how a row or column aligns its children using the [mainAxisAlignment](https://api.flutter.dev/flutter/rendering/MainAxisAlignment.html) and [crossAxisAlignment](https://api.flutter.dev/flutter/rendering/CrossAxisAlignment.html) properties. For a row, the main axis runs horizontally and the cross axis runs vertically. For a column, the main axis runs vertically and the cross axis runs horizontally.

- [Sizing widgets](https://docs.flutter.dev/development/ui/layout#sizing-widgets):

    + Widgets can be sized to fit within a row or column by using the [Expanded](https://api.flutter.dev/flutter/widgets/Expanded-class.html) widget

- [Packing widgets](https://docs.flutter.dev/development/ui/layout#packing-widgets):
    + By default, a row or column occupies as much space along its main axis as possible

- [Nesting rows and columns](https://docs.flutter.dev/development/ui/layout#nesting-rows-and-columns)
    + The layout framework allows our app to nest rows and columns inside of rows and columns as deeply as we want






