// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection';

import 'package:flutter/material.dart';

import '../../../data/gallery_options.dart';
import '../../../layout/adaptive.dart';
import '../../../models/app_state_model.dart';
import '../../../ui/accounts/settings/settings_list_item.dart';

enum _ExpandableSetting {
  theme,
}

class SettingsPage extends StatefulWidget {

  AppStateModel appStateModel = AppStateModel();

  SettingsPage({
    Key key,
    //@required this.openSettingsAnimation,
    //@required this.staggerSettingsItemsAnimation,
    //@required this.isSettingsOpenNotifier,
  }) : super(key: key);

  //final Animation<double> openSettingsAnimation;
  //final Animation<double> staggerSettingsItemsAnimation;
  //final ValueNotifier<bool> isSettingsOpenNotifier;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _ExpandableSetting expandedSettingId;
  Map<String, String> _localeNativeNames;

  void onTapSetting(_ExpandableSetting settingId) {
    setState(() {
      if (expandedSettingId == settingId) {
        expandedSettingId = null;
      } else {
        expandedSettingId = settingId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final options = GalleryOptions.of(context);
    final isDesktop = isDisplayDesktop(context);

    final settingsListItems = [
      SettingsListItem<ThemeMode>(
        title: widget.appStateModel.blocks.localeText.system,
        selectedOption: options.themeMode,
        options: LinkedHashMap.of({
          ThemeMode.system: DisplayOption(
            widget.appStateModel.blocks.localeText.system,
          ),
          ThemeMode.dark: DisplayOption(
            widget.appStateModel.blocks.localeText.dart,
          ),
          ThemeMode.light: DisplayOption(
            widget.appStateModel.blocks.localeText.light,
          ),
        }),
        onOptionChanged: (newThemeMode) => GalleryOptions.update(
          context,
          options.copyWith(themeMode: newThemeMode),
        ),
        onTapSetting: () => onTapSetting(_ExpandableSetting.theme),
        isExpanded: expandedSettingId == _ExpandableSetting.theme,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appStateModel.blocks.localeText.settings),
      ),
      body: MediaQuery.removePadding(
        removeTop: isDesktop,
        context: context,
        child: ListView(
          children: [
            SettingsListItem<ThemeMode>(
              title: widget.appStateModel.blocks.localeText.theme,
              selectedOption: options.themeMode,
              options: LinkedHashMap.of({
                ThemeMode.system: DisplayOption(
                  widget.appStateModel.blocks.localeText.system,
                ),
                ThemeMode.dark: DisplayOption(
                  widget.appStateModel.blocks.localeText.dart,
                ),
                ThemeMode.light: DisplayOption(
                  widget.appStateModel.blocks.localeText.light,
                ),
              }),
              onOptionChanged: (newThemeMode) => GalleryOptions.update(
                context,
                options.copyWith(themeMode: newThemeMode),
              ),
              onTapSetting: () => onTapSetting(_ExpandableSetting.theme),
              isExpanded: expandedSettingId == _ExpandableSetting.theme,
            ),
          ],
        ),
      ),
    );/*Material(
      color: colorScheme.secondaryVariant,
      child: _AnimatedSettingsPage(
        //animation: widget.openSettingsAnimation,
        child: Padding(
          padding: isDesktop
              ? EdgeInsets.zero
              : EdgeInsets.only(
                  bottom: galleryHeaderHeight,
                ),
          // Remove ListView top padding as it is already accounted for.
          child: MediaQuery.removePadding(
            removeTop: isDesktop,
            context: context,
            child: ListView(
              children: [
                *//*if (isDesktop) SizedBox(height: firstHeaderDesktopTopPadding),
                Focus(
                  focusNode: InheritedBackdropFocusNodes.of(context)
                      .frontLayerFocusNode,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: ExcludeSemantics(
                      child: Header(
                        color: Theme.of(context).colorScheme.onSurface,
                        text: AppLocalizations.of(context).settingsTitle,
                      ),
                    ),
                  ),
                ),
                if (isDesktop)
                  ...settingsListItems*//*
                ...[
                  _AnimateSettingsListItems(
                    //animation: widget.staggerSettingsItemsAnimation,
                    children: settingsListItems,
                  ),
                  SizedBox(height: 16),
                  Divider(
                      thickness: 2, height: 0, color: colorScheme.background),
                  SizedBox(height: 12),
                  //SettingsAbout(),
                  //SettingsFeedback(),
                  SizedBox(height: 12),
                  Divider(
                      thickness: 2, height: 0, color: colorScheme.background),
                  SettingsAttribution(),
                ],
              ],
            ),
          ),
        ),
      ),
    );*/
  }
}


/*class SettingsAttribution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final verticalPadding = isDesktop ? 0.0 : 28.0;
    return MergeSemantics(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: isDesktop ? 24 : 32,
          end: isDesktop ? 0 : 32,
          top: verticalPadding,
          bottom: verticalPadding,
        ),
        child: Text(
          AppLocalizations.of(context).settingsAttribution,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
          textAlign: isDesktop ? TextAlign.end : TextAlign.start,
        ),
      ),
    );
  }
}*/

class _SettingsLink extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback onTap;

  _SettingsLink({this.title, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = isDisplayDesktop(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 24 : 32,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: colorScheme.onSecondary.withOpacity(0.5),
              size: 24,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 16,
                  top: 12,
                  bottom: 12,
                ),
                child: Text(
                  title,
                  style: textTheme.subtitle.apply(
                    color: colorScheme.onSecondary,
                  ),
                  textAlign: isDesktop ? TextAlign.end : TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animate the settings page to slide in from above.
class _AnimatedSettingsPage extends StatelessWidget {
  const _AnimatedSettingsPage({
    Key key,
    @required this.animation,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    if (isDesktop) {
      return child;
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromLTRB(0, -constraints.maxHeight, 0, 0),
                end: RelativeRect.fromLTRB(0, 0, 0, 0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.linear,
                ),
              ),
              child: child,
            ),
          ],
        );
      });
    }
  }
}

/// Animate the settings list items to stagger in from above.
class _AnimateSettingsListItems extends StatelessWidget {
  const _AnimateSettingsListItems({
    Key key,
    this.animation,
    this.children,
    this.topPadding,
    this.bottomPadding,
  }) : super(key: key);

  final Animation<double> animation;
  final List<Widget> children;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final startDividingPadding = 4.0;
    final topPaddingTween = Tween<double>(
      begin: 0,
      end: children.length * startDividingPadding,
    );
    final dividerTween = Tween<double>(
      begin: startDividingPadding,
      end: 0,
    );

    return Padding(
      padding: EdgeInsets.only(top: topPaddingTween.animate(animation).value),
      child: Column(
        children: [
          for (Widget child in children)
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: dividerTween.animate(animation).value,
                  ),
                  child: child,
                );
              },
              child: child,
            ),
        ],
      ),
    );
  }
}
