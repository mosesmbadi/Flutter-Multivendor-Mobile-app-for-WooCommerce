import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../src/models/app_state_model.dart';
import '../../functions.dart';
import '../../models/category_model.dart';
import '../products/products.dart';

class ExpandableCategoryList extends StatefulWidget {
  List<Category> categories;
  ExpandableCategoryList({Key key, this.categories})
      : super(key: key);
  @override
  _ExpandableCategoryListState createState() => _ExpandableCategoryListState();
}

class _ExpandableCategoryListState extends State<ExpandableCategoryList> {
  List<Category> mainCategories;
  Category selectedCategory;

  void onCategoryClick(Category category) {
    setState(() {
      selectedCategory = category;
    });
    _onTap(category);
  }

  _onTap(Category category) {
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductsWidget(filter: filter, name: category.name)));
  }

  @override
  Widget build(BuildContext context) {
    mainCategories = widget.categories.where((cat) => cat.parent == 0).toList();
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return _buildTiles(mainCategories[index]);
      },
        childCount: mainCategories.length,
      ),
    );
  }

  Widget _buildTiles(Category category) {
    int index = widget.categories.indexOf(category);
    List<Category> subCategories = [];
    if (index != -1) {
      subCategories = widget.categories
          .where((item) => item.parent == widget.categories[index].id)
          .toList();
    }
    if (subCategories.isEmpty) {
      return _buildTile(category);
    } else {
      return ExpansionTile2(
        key: PageStorageKey<Category>(category),
        leading: leadingIcon(category),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.yellow.withOpacity(0.1) : Colors.yellow.withOpacity(0.3),
        title: Text(
          parseHtmlString(category.name),
          style: menuItemStyle(),
        ),
        subtitle: category.description != '' ? Text(parseHtmlString(category.description), maxLines: 2, style: Theme.of(context).textTheme.caption,) : null,
        children: subCategories.map(_buildCard).toList(),
      );
    }
  }

  Widget _buildCard(Category category) {
    return Container(
      height: 130,
      width: 115,
      decoration: BoxDecoration(
        border: Border.all(
          width: .2,
          color: Colors.black12
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          cardImage(category),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(parseHtmlString(category.name), maxLines: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(Category category) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(16,16,16,16),
            child: Row(
              children: [
                leadingIcon(category),
                Container(
                  width: MediaQuery.of(context).size.width - 150,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        parseHtmlString(category.name),
                        style: menuItemStyle(),
                      ),
                      category.description != '' ? Text(
                        parseHtmlString(category.description),
                        style: Theme.of(context).textTheme.caption,
                        maxLines: 2,
                      ) : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(
            thickness: 10,
            color: Colors.grey.withOpacity(.2),
          )
        ],
      ),
    );
  }

  TextStyle menuItemStyle() {
    return TextStyle(
      fontWeight: FontWeight.w800,
      fontFamily: 'Lexend_Deca',
      letterSpacing: 0.5,
      fontSize: 16,
    );
  }

  _divider(BuildContext context) {
    return Divider(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.black12
          : Colors.black,
      thickness: 0.5,
      height: 1,
      //indent: 60,
    );
  }

  Container leadingIcon(Category category) {
    return Container(
      width: 80,
      height: 80,
      child: CachedNetworkImage(
        imageUrl: category.image != null ? category.image : '',
        imageBuilder: (context, imageProvider) => Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          //shape: StadiumBorder(),
          child: Ink.image(
            child: InkWell(
              onTap: () {
                onCategoryClick(category);
              },
            ),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (context, url) => Card(
          margin: EdgeInsets.all(0.0),
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          shape: StadiumBorder(),
        ),
        errorWidget: (context, url, error) => Card(
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          color: Colors.white,
          shape: StadiumBorder(),
        ),
      ),
    );
  }

  Widget cardImage(Category category) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 80,
      height: 80,
      child: CachedNetworkImage(
        imageUrl: category.image != null ? category.image : '',
        imageBuilder: (context, imageProvider) => Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          //shape: StadiumBorder(),
          child: Ink.image(
            child: InkWell(
              onTap: () {
                onCategoryClick(category);
              },
            ),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (context, url) => Card(
          margin: EdgeInsets.all(0.0),
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          shape: StadiumBorder(),
        ),
        errorWidget: (context, url, error) => Card(
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          color: Colors.white,
          shape: StadiumBorder(),
        ),
      ),
    );
  }
}

const Duration _kExpand = Duration(milliseconds: 200);

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [ExpansionTile2] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of
///    <https://material.io/guidelines/components/lists-controls.html>.
class ExpansionTile2 extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const ExpansionTile2({
    Key key,
    this.leading,
    @required this.title,
    this.subtitle,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget subtitle;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  @override
  _ExpansionTile2State createState() => _ExpansionTile2State();
}

class _ExpansionTile2State extends State<ExpansionTile2>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: _isExpanded
                ? _backgroundColor.value ?? Colors.yellow.withOpacity(.2)
                : Colors.transparent,
            border: Border(
                // top: BorderSide(color: borderSideColor),
                // bottom: BorderSide(color: borderSideColor),
                ),
          ),
          child: Column(
            children: <Widget>[
              ListTileTheme.merge(
                iconColor: _iconColor.value,
                textColor: _headerColor.value,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0,0,0,0),
                  //height: 100,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16,16,16,16),
                      child: InkWell(
                        onTap: _handleTap,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 32,
                          child: Row(
                            children: [
                              widget.leading,
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width - 140,
                                      padding: EdgeInsets.only(left: 16, right: 16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          widget.title,
                                          if(widget.subtitle != null)
                                          Column(
                                            children: [
                                              SizedBox(height: 4,),
                                              widget.subtitle,
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    _isExpanded
                                        ? Container(
                                      height: 60,
                                      child: RotationTransition(
                                        turns: _iconTurns,
                                        child: const Icon(Icons.keyboard_arrow_down),
                                      ),
                                    )
                                        : Container(
                                      height: 60,
                                      child: RotationTransition(
                                        turns: _iconTurns,
                                        child: const Icon(Icons.keyboard_arrow_down),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                ),
              ),
              ClipRect(
                child: Align(
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 10,
          color: Colors.grey.withOpacity(.2),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween..end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subtitle1.color
      ..end = theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColorTween..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed
          ? null
          : Container(
          margin: EdgeInsets.only(top: 16, bottom: 16),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Wrap(alignment: WrapAlignment.start, children: widget.children)
      ),
    );
  }
}
