import 'package:flutter/material.dart';

/// DynamicButton
///
/// style = "Stadium",  /// Stadium // Rectangle // Circle // Beveled
class DynamicButton extends StatelessWidget {
  // final bool colorTextAuto;
  final bool?
      selected; // null not visible, false disable color, true enable color
  final bool enabled;
  final String style;

  /// Stadium // Rectangle // Circle // Beveled
  final String? title;
  final String? styleTitle;

  /// uuid Style
  final String? tooltip;
  final Widget? icon;
  final Widget? end;

  final Color? textColor;
  final Color? iconColor;
  final TextStyle? textStyle;
  final Color? backColor;
  final Color? hoverColor;
  final Color? pressColor;
  final Color? outlineColor; // border
  final Color? shadowColor; // elevated
  final double elevation; // horizontal
  final double paddingH; // horizontal
  final double paddingV; // vertical
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;

  const DynamicButton({
    Key? key,
    // this.colorTextAuto = false,
    this.selected = false,
    this.enabled = true,
    this.style = "Stadium",

    /// Stadium // Rectangle // Circle // Beveled
    this.title = "",
    this.styleTitle = "",
    this.tooltip, // null
    this.icon, // = null,
    this.end, // = null,
    this.textColor,
    this.iconColor,
    this.textStyle,
    this.backColor,
    this.hoverColor,
    this.pressColor,
    this.outlineColor,
    this.shadowColor,
    this.elevation = 2.0,
    this.paddingH = 10.0,
    this.paddingV = 10.0, // Border Size
    this.onTap,
    this.onLongTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tooltip != null
        ? Tooltip(message: tooltip, child: buttonDynamic(context))
        : buttonDynamic(context);
  }

  /// Button Custom
  Widget buttonDynamic(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;

    return ElevatedButton(
      onPressed: enabled == false
          ? null
          : () {
              if (enabled) {
                if (onTap != null) {
                  onTap!();
                }
              } //else{null;}
            },
      onLongPress: enabled == false
          ? null
          : () {
              if (enabled) {
                if (onLongTap != null) {
                  onLongTap!();
                }
              } //else{null;}
            },
      onHover: (bool newVal) {},
      style: style == "Rectangle"
          ? ButtonStyle(
              ///----------------------------------------------------------------------------
              elevation: MaterialStateProperty.all<double>(elevation),

              ///https://api.flutter.dev/flutter/material/ButtonStyle-class.html
              //backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return pressColor ?? colorScheme.primary;
                  } else if (states.contains(MaterialState.hovered)) {
                    return hoverColor ?? colorScheme.onPrimaryContainer;
                  } else {
                    return pressColor != null && selected == true
                        ? pressColor
                        : backColor != null
                            ? backColor! //.withOpacity(0.9)
                            : selected == true
                                ? colorScheme.primary
                                : colorScheme.primaryContainer;
                  }
                },
              ),
              // Elevation
              shadowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  //if (states.contains(MaterialState.pressed)){colorScheme.shadow;} else
                  if (states.contains(MaterialState.hovered)) {
                    return null;
                  } else {
                    return shadowColor ??
                        colorScheme.shadow; // Colors.transparent;
                  }
                },
              ),
              // Border
              side: MaterialStateProperty.resolveWith<BorderSide?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return null;
                  } else {
                    return BorderSide(
                        width: 1.5, color: outlineColor ?? colorScheme.outline);
                  }
                },
              ),
              // Color Icon
              foregroundColor: MaterialStatePropertyAll<Color?>(
                  iconColor ?? colorScheme.onPrimary),

              /// Color icon
              // Color Text
              textStyle: MaterialStateProperty.all<TextStyle>(textStyle != null
                  ? textStyle!
                      .copyWith(color: textColor ?? colorScheme.onPrimary)
                  : textTheme.bodyMedium!.copyWith(
                      color: textColor ?? colorScheme.onPrimary,
                    )),

              ///----------------------------------------------------------------------------
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                      horizontal: paddingH, vertical: paddingV)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                //side: const BorderSide(color: Colors.green)
              )),

              ///----------------------------------------------------------------------------
            )
          : style == "Circle"
              ? ButtonStyle(
                  ///----------------------------------------------------------------------------
                  elevation: MaterialStateProperty.all<double>(elevation),

                  ///https://api.flutter.dev/flutter/material/ButtonStyle-class.html
                  //backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return pressColor ?? colorScheme.primary;
                      } else if (states.contains(MaterialState.hovered)) {
                        return hoverColor ?? colorScheme.onPrimaryContainer;
                      } else {
                        return pressColor != null && selected == true
                            ? pressColor
                            : backColor != null
                                ? backColor! //.withOpacity(0.9)
                                : selected == true
                                    ? colorScheme.primary
                                    : colorScheme.primaryContainer;
                      }
                    },
                  ),
                  // Elevation
                  shadowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      //if (states.contains(MaterialState.pressed)){colorScheme.shadow;} else
                      if (states.contains(MaterialState.hovered)) {
                        return null;
                      } else {
                        return shadowColor ??
                            colorScheme.shadow; // Colors.transparent;
                      }
                    },
                  ),
                  // Border
                  side: MaterialStateProperty.resolveWith<BorderSide?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return null;
                      } else {
                        return BorderSide(
                            width: 1.5,
                            color: outlineColor ?? colorScheme.outline);
                      }
                    },
                  ),
                  // Color Icon
                  foregroundColor: MaterialStatePropertyAll<Color?>(
                      iconColor ?? colorScheme.onPrimary),

                  /// Color icon
                  // Color Text
                  textStyle: MaterialStateProperty.all<TextStyle>(textStyle !=
                          null
                      ? textStyle!
                          .copyWith(color: textColor ?? colorScheme.onPrimary)
                      : textTheme.bodyMedium!.copyWith(
                          color: textColor ?? colorScheme.onPrimary,
                        )),

                  ///----------------------------------------------------------------------------
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(paddingH)),
                  shape: MaterialStateProperty.all<CircleBorder>(
                    const CircleBorder(),
                  ),

                  ///----------------------------------------------------------------------------
                )
              : style == "Beveled"
                  ? ButtonStyle(
                      ///----------------------------------------------------------------------------
                      elevation: MaterialStateProperty.all<double>(elevation),

                      ///https://api.flutter.dev/flutter/material/ButtonStyle-class.html
                      //backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return pressColor ?? colorScheme.primary;
                          } else if (states.contains(MaterialState.hovered)) {
                            return hoverColor ?? colorScheme.onPrimaryContainer;
                          } else {
                            return pressColor != null && selected == true
                                ? pressColor
                                : backColor != null
                                    ? backColor! //.withOpacity(0.9)
                                    : selected == true
                                        ? colorScheme.primary
                                        : colorScheme.primaryContainer;
                          }
                        },
                      ),
                      // Elevation
                      shadowColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          //if (states.contains(MaterialState.pressed)){colorScheme.shadow;} else
                          if (states.contains(MaterialState.hovered)) {
                            return null;
                          } else {
                            return shadowColor ??
                                colorScheme.shadow; // Colors.transparent;
                          }
                        },
                      ),
                      // Border
                      side: MaterialStateProperty.resolveWith<BorderSide?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return null;
                          } else {
                            return BorderSide(
                                width: 1.5,
                                color: outlineColor ?? colorScheme.outline);
                          }
                        },
                      ),
                      // Color Icon
                      foregroundColor: MaterialStatePropertyAll<Color?>(
                          iconColor ?? colorScheme.onPrimary),

                      /// Color icon
                      // Color Text
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          textStyle != null
                              ? textStyle!.copyWith(
                                  color: textColor ?? colorScheme.onPrimary)
                              : textTheme.bodyMedium!.copyWith(
                                  color: textColor ?? colorScheme.onPrimary,
                                )),

                      ///----------------------------------------------------------------------------
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: paddingH, vertical: paddingV)),
                      shape: MaterialStateProperty.all<BeveledRectangleBorder>(
                        BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      ///----------------------------------------------------------------------------
                    )
                  :

                  /// style == "Stadium" ?
                  ButtonStyle(
                      ///----------------------------------------------------------------------------
                      elevation: MaterialStateProperty.all<double>(elevation),

                      ///https://api.flutter.dev/flutter/material/ButtonStyle-class.html
                      //backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return pressColor ?? colorScheme.primary;
                          } else if (states.contains(MaterialState.hovered)) {
                            return hoverColor ?? colorScheme.onPrimaryContainer;
                          } else {
                            return pressColor != null && selected == true
                                ? pressColor
                                : backColor != null
                                    ? backColor! //.withOpacity(0.9)
                                    : selected == true
                                        ? colorScheme.primary
                                        : colorScheme.primaryContainer;
                          }
                        },
                      ),
                      // Elevation
                      shadowColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          //if (states.contains(MaterialState.pressed)){colorScheme.shadow;} else
                          if (states.contains(MaterialState.hovered)) {
                            return null;
                          } else {
                            return shadowColor ??
                                colorScheme.shadow; // Colors.transparent;
                          }
                        },
                      ),
                      // Border
                      side: MaterialStateProperty.resolveWith<BorderSide?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return null;
                          } else {
                            return BorderSide(
                                width: 1.5,
                                color: outlineColor ?? colorScheme.outline);
                          }
                        },
                      ),
                      // Color Icon
                      foregroundColor: MaterialStatePropertyAll<Color?>(
                          iconColor ?? colorScheme.onPrimary),

                      /// Color icon
                      // Color Text
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          textStyle != null
                              ? textStyle!.copyWith(
                                  color: textColor ?? colorScheme.onPrimary)
                              : textTheme.bodyMedium!.copyWith(
                                  color: textColor ?? colorScheme.onPrimary,
                                )),

                      ///----------------------------------------------------------------------------
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: paddingH, vertical: paddingV)),
                      shape: MaterialStateProperty.all<StadiumBorder>(
                        const StadiumBorder(),
                      ),

                      ///----------------------------------------------------------------------------
                    ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon ?? const SizedBox.shrink(),
          if (icon != null && title != "") const SizedBox(width: 5),
          if (title != "")
            Flexible(
              child: Text(
                title!,
                style: textStyle != null
                    ? textStyle!
                        .copyWith(color: textColor ?? colorScheme.onBackground)
                    : textTheme.bodyMedium!
                        .copyWith(color: textColor ?? colorScheme.onBackground),
              ),
            ),
          //if(title != "")Flexible(child: CustomsTextAnimated(
          //  title: title,
          //  uuidTitle: styleTitle,
          //),),

          if (end != null) const SizedBox(width: 5),

          if (end != null)
            Flexible(
              child: end!,
            ),
        ],
      ),
    );
  }
}
