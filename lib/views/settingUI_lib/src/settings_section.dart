import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:etoet/views/settingUI_lib/src/abstract_section.dart';
import 'package:etoet/views/settingUI_lib/src/cupertino_settings_section.dart';
import 'package:etoet/views/settingUI_lib/src/settings_tile.dart';

import 'defines.dart';

// ignore: must_be_immutable
class SettingsSection extends AbstractSection {
  final List<AbstractTile>? tiles;
  final TextStyle? titleTextStyle;
  final int? maxLines;
  final Widget? subtitle;
  final EdgeInsetsGeometry subtitlePadding;
  final TargetPlatform? platform;

  SettingsSection({
    Key? key,
    String? title,
    Widget? titleWidget,
    EdgeInsetsGeometry titlePadding = defaultTitlePadding,
    this.maxLines,
    this.subtitle,
    this.subtitlePadding = defaultTitlePadding,
    this.tiles,
    this.titleTextStyle,
    this.platform,
  })  : assert(maxLines == null || maxLines > 0),
        super(
          key: key,
          title: title,
          titleWidget: titleWidget,
          titlePadding: titlePadding,
        );

  @override
  Widget build(BuildContext context) {
    final platform = this.platform ?? Theme.of(context).platform;

    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return iosSection();

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return androidSection(context);

      default:
        return iosSection();
    }
  }

  Widget iosSection() {
    return CupertinoSettingsSection(
      tiles!,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || titleWidget != null)
            titleWidget ??
                Text(
                  title!,
                  style: titleTextStyle,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
          if (subtitle != null)
            Padding(
              padding: subtitlePadding,
              child: subtitle,
            ),
        ],
      ),
      headerPadding: titlePadding!,
    );
  }

  Widget androidSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (title != null)
        Padding(
          padding: titlePadding!,
          child: Text(
            title!,
            style: titleTextStyle ??
                TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (subtitle != null)
        Padding(
          padding: subtitlePadding,
          child: subtitle,
        ),
      ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tiles!.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          return tiles![index];
        },
      ),
      if (showBottomDivider) Divider(height: 1)
    ]);
  }
}
