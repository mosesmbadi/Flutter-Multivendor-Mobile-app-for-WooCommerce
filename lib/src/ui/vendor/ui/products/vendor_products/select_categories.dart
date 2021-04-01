import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../../functions.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/category_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';

class SelectCategories extends StatefulWidget {
  final VendorProduct product;

  SelectCategories({Key key, this.product}) : super(key: key);

  @override
  _SelectCategoriesState createState() => _SelectCategoriesState();
}

class _SelectCategoriesState extends State<SelectCategories> {
  List<Category> mainCategories;
  List<Category> subCategories;
  Category selectedCategory;
  int mainCategoryId = 0;
  int selectedCategoryIndex = 0;
  AppStateModel _appStateModel = AppStateModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appStateModel.blocks.localeText.categories),
      ),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (model.blocks?.categories != null) {
            return CategoryList(
                categories: model.blocks.categories, product: widget.product);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  List<Category> categories;
  final VendorProduct product;
  CategoryList({Key key, this.categories, this.product})
      : super(key: key);
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Category> mainCategories;
  Category selectedCategory;

  @override
  void initState() {
    super.initState();
    mainCategories = widget.categories.where((cat) => cat.parent == 0).toList();
    if (mainCategories.length != 0) selectedCategory = mainCategories[0];
  }

  void onCategoryClick(Category category) {
      ProductCategory productCategory= new ProductCategory();
      productCategory.id = category.id;
      productCategory.name = category.name;
      if(!widget.product.categories.any((value) => value.id == category.id)) {
        setState(() {
          widget.product.categories.add(productCategory);
        });
      }
      else if(widget.product.categories.any((value) => value.id == category.id)) {
        setState(() {
          widget.product.categories.removeWhere((value) => value.id == category.id);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: mainCategories.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return _buildTiles(mainCategories[index]);
        });
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
        leading: Checkbox(
          value: widget.product.categories.any((item) => item.id == category.id),
          onChanged: (bool value) {
            if(value) {
              ProductCategory productCategory= new ProductCategory();
              productCategory.id = category.id;
              productCategory.name = category.name;
              if(!widget.product.categories.any((value) => value.id == category.id)) {
                setState(() {
                  widget.product.categories.add(productCategory);
                });
              }
            } else {
              if(widget.product.categories.any((value) => value.id == category.id)) {
                setState(() {
                  widget.product.categories.removeWhere((value) => value.id == category.id);
                });
              }
            }
          },
        ),
        title: Text(
          parseHtmlString(category.name),
          style: menuItemStyle(),
        ),
        children: subCategories.map(_buildTiles).toList(),
      );
    }
  }

  Widget _buildTile(Category category) {
    return Column(
      children: <Widget>[
        ListTile(
          //trailing: Icon(Icons.keyboard_arrow_right),
          dense: true,
          onTap: () {
            onCategoryClick(category);
          },
          leading: Checkbox(
            value: widget.product.categories.any((item) => item.id == category.id),
            onChanged: (bool value) {
              if(value) {
                ProductCategory productCategory= new ProductCategory();
                productCategory.id = category.id;
                productCategory.name = category.name;
                if(!widget.product.categories.any((value) => value.id == category.id)) {
                  setState(() {
                    widget.product.categories.add(productCategory);
                  });
                }
              } else {
                if(widget.product.categories.any((value) => value.id == category.id)) {
                  setState(() {
                    widget.product.categories.removeWhere((value) => value.id == category.id);
                  });
                }
              }
            },
          ),
          title: Padding(
            padding: category.parent != 0
                ? EdgeInsets.symmetric(horizontal: 16.0)
                : EdgeInsets.all(0.0),
            child: Text(
              parseHtmlString(category.name),
              style: menuItemStyle(),
            ),
          ),
        ),
        Divider(height: 0),
      ],
    );
  }

  TextStyle menuItemStyle() {
    return Theme.of(context).textTheme.bodyText1;
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
      width: 20,
      height: 20,
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

    return Container(
      decoration: BoxDecoration(
        color: _isExpanded
            ? _backgroundColor.value ?? Colors.brown.withOpacity(0.1)
            : Colors.transparent,
        border: Border(
            // top: BorderSide(color: borderSideColor),
            // bottom: BorderSide(color: borderSideColor),
            ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: _iconColor.value,
            textColor: _headerColor.value,
            child: ListTile(
              dense: true,
              onTap: _handleTap,
              leading: widget.leading,
              title: widget.title,
              subtitle: widget.subtitle,
              trailing: _isExpanded
                  ? RotationTransition(
                      turns: _iconTurns,
                      child: const Icon(Icons.remove),
                    )
                  : RotationTransition(
                      turns: _iconTurns,
                      child: const Icon(Icons.add),
                    ),
            ),
          ),
          Divider(height: 0),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
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
      child: closed ? null : Column(children: widget.children),
    );
  }
}