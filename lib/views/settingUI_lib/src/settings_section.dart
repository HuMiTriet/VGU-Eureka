// ignore_for_file: unnecessary_import

import 'package:etoet/views/settingUI_lib/src/abstract_section.dart';
import 'package:etoet/views/settingUI_lib/src/cupertino_settings_section.dart';
import 'package:etoet/views/settingUI_lib/src/settings_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  Widget androidSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (title != null)
        Padding(
          padding: titlePadding!,
          child: Text(
            title!,
            style: titleTextStyle ??
                TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
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
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tiles!.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return tiles![index];
        },
      ),
      if (showBottomDivider) const Divider(height: 1)
    ]);
  }

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
}
