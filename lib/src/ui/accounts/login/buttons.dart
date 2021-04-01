import 'package:flutter/material.dart';

class WhiteButton extends _BaseButton {
  final bool flat;
  final IconData iconData;
  final bool bold;

  WhiteButton({
    @required VoidCallback onPressed,
    String text,
    Widget child,
    this.flat = false,
    this.bold = true,
    this.iconData,
  }) : super(
          onPressed: onPressed,
          showProgress: false,
          text: text,
          child: child,
          iconData: iconData,
          borderRadius: BorderRadius.circular(0),
          textStyle: new TextStyle(
              fontSize: 14.0,
              color: Colors.black87.withOpacity(0.8),
              fontWeight: bold ? FontWeight.bold : FontWeight.normal),
          color: Colors.white,
          borderSide: flat
              ? BorderSide.none
              : const BorderSide(color: Colors.grey, width: 0.5),
        );
}

class AccentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;

  AccentButton({
    @required this.onPressed,
    @required this.text,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      onPressed: onPressed,
      showProgress: showProgress,
      color: Theme.of(context).buttonColor,
      borderSide: BorderSide.none,
      borderRadius: const BorderRadius.all(Radius.circular(0.0)),
      textStyle: TextStyle(
          fontSize: 14.0,
          color: Theme.of(context).colorScheme.onSecondary,
          fontWeight: FontWeight.bold),
      text: text.toUpperCase(),
    );
  }
}

class AccountButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;
  final BorderRadius borderRadius;

  AccountButton({
    @required this.onPressed,
    @required this.text,
    this.showProgress = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      onPressed: onPressed,
      showProgress: showProgress,
      color: Theme.of(context).buttonColor,
      borderSide: BorderSide.none,
      borderRadius: borderRadius,
      textStyle: TextStyle(
          fontSize: 14.0,
          color: Theme.of(context).colorScheme.onSecondary,
          fontWeight: FontWeight.bold),
      text: text.toUpperCase(),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;

  AddToCartButton({
    @required this.onPressed,
    @required this.text,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      onPressed: onPressed,
      showProgress: showProgress,
      color: Theme.of(context).buttonColor,
      borderSide: BorderSide.none,
      borderRadius: const BorderRadius.all(Radius.circular(0.0)),
      textStyle: TextStyle(
          fontSize: 14.0,
          color: Theme.of(context).colorScheme.onSecondary,
          fontWeight: FontWeight.bold),
      text: text.toUpperCase(),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;

  PrimaryButton({
    @required this.onPressed,
    @required this.text,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      onPressed: onPressed,
      showProgress: showProgress,
      color: Theme.of(context).primaryColor,
      borderSide: BorderSide.none,
      borderRadius: const BorderRadius.all(Radius.circular(0.0)),
      textStyle: TextStyle(
          fontSize: 14.0,
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold),
      text: text,
    );
  }
}

class BlackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;
  final IconData iconData;

  BlackButton(
      {@required this.onPressed,
      @required this.text,
      this.showProgress = false,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      onPressed: onPressed,
      showProgress: showProgress,
      color: Theme.of(context).colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      borderSide: BorderSide.none,
      borderRadius: const BorderRadius.all(Radius.circular(0.0)),
      textStyle: TextStyle(
          fontSize: 14.0,
          color: Theme.of(context).colorScheme.brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          fontWeight: FontWeight.bold),
      text: text,
      iconData: iconData,
    );
  }
}

class _BaseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;
  final TextStyle textStyle;
  final Color color;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final IconData iconData;
  final Widget child;

  _BaseButton({
    @required this.onPressed,
    @required this.showProgress,
    @required this.text,
    @required this.textStyle,
    @required this.color,
    @required this.borderSide,
    @required this.borderRadius,
    this.iconData,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    //const borderRadius = const BorderRadius.all(Radius.circular(5.0));
    var textWidget;
    if (text != null) {
      textWidget = new Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle,
      );
    }
    return new Container(
        //width: 300,
        height: 50.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
        child: new Container(
          width: double.infinity,
          height: double.infinity,
          child: new RaisedButton(
              onPressed: showProgress ? null : onPressed,
              shape: new RoundedRectangleBorder(
                  borderRadius: borderRadius, side: borderSide),
              child: showProgress
                  ? new Container(
                      width: 20.0,
                      height: 20.0,
                      child: new Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: textStyle.color),
                          child: new CircularProgressIndicator(
                            strokeWidth: 2.0,
                          )),
                    )
                  : iconData == null
                      ? child == null ? textWidget : child
                      : new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              iconData,
                              color: textStyle.color.withOpacity(0.5),
                            ),
                            const SizedBox(width: 2.0),
                            textWidget,
                          ],
                        )),
        ));
  }
}
