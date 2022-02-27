import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_streaming_app/model/element.dart';
import 'package:movie_streaming_app/utils/functions.dart';

class RenderTreeScraper {
  final List<SmartlookElement> smartlookElements = [];
  bool hasScafold = false;
  String scrapeData(BuildContext context) {
    final List<SmartlookElement> elements = _scrapeElements(context);
    return "$elements";
  }

  List<SmartlookElement> _scrapeElements(BuildContext context) {
    assert(context != null);

    context.visitChildElements(visitor);
    return smartlookElements;
  }

  void visitor(Element element) async {
    //normally I wouldnt keep here debugging comments
    // but I wanted you to see the things I used
    // print("------------");
    // print(element.runtimeType);
    // print(element.widget.runtimeType);
    // if (element.widget.key.toString().contains("image key")) {
    ///asigned key to widget i wanted to test
    // }

    ///checking if the element is visible on screen
    ///element.renderObject?.debugSemantics?.isInvisible does nothing

    //hit test might be one of the options to check visibility
    //element.renderObject.semanticBounds.overlaps(other) might be used too
    if (element.renderObject.attached) {
      // for this task i can use scaffold to know which screen is active,
      // otherwise more elegant solution would suit better
      //also this solution is not fast it would be better to find active screen
      if (element.widget is Scaffold) {
        if (hasScafold == true) {
          smartlookElements.clear();
        }
        hasScafold = true;
        addSmartlookElement(
            element: element,
            color: (element.widget as Scaffold).backgroundColor,
            smartlookElements: smartlookElements);
      }
      //takes care of Container and Image inside
      else if (element.widget is DecoratedBox) {
        final BoxDecoration decoration =
            (element.widget as DecoratedBox).decoration;
        //here should be some checking if image overlaps the container whole
        if (decoration.image != null) {
          final color =
              await Functions.getAverageColorFromImage(decoration.image.image);
          addSmartlookElement(
              element: element,
              color: color,
              smartlookElements: smartlookElements);
        }
        if (decoration.color != null) {
          addSmartlookElement(
              element: element,
              color: decoration.color,
              smartlookElements: smartlookElements);
        }
      } else if (element.widget is Image) {
        // I think image color property should be also taken into account, did not have time to test it
        final color = await Functions.getAverageColorFromImage(
            (element.widget as Image).image);
        addSmartlookElement(
            element: element,
            color: color,
            smartlookElements: smartlookElements);
      } else if (element.widget is Text) {
        addSmartlookElement(
            element: element,
            color: (element.widget as Text).style?.color,
            smartlookElements: smartlookElements);
      } else if (element.widget is Icon) {
        addSmartlookElement(
            element: element,
            color: (element.widget as Icon).color,
            smartlookElements: smartlookElements);
      } else if (element.widget is RichText) {
        if ((element.widget as RichText).text is TextSpan) {
          final children =
              ((element.widget as RichText).text as TextSpan)?.children;
          if (children?.length != null) {
            for (final TextSpan textSpan in children) {
              //could not specify the position more, would have to calculate sizes and length of letters,
              // maybe i missed out some functionality to do so
              addSmartlookElement(
                  element: element,
                  color: textSpan.style?.color,
                  smartlookElements: smartlookElements);
            }
          }
        }
      }
      element.visitChildren(visitor);
    }
  }

  void addSmartlookElement(
      {Element element,
      Color color,
      List<SmartlookElement> smartlookElements}) {
    final renderBox = element.renderObject as RenderBox;
    smartlookElements.add(SmartlookElement(
        height: element.size.height,
        width: element.size.width,
        top: renderBox.localToGlobal(Offset.zero).dy,
        left: renderBox.localToGlobal(Offset.zero).dx,
        color: color));
  }
}
