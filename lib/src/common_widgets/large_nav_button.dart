import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/routing/routing_arguments.dart';
import 'package:flutter/material.dart';

class LargeNavButton extends StatelessWidget {
  const LargeNavButton(
      {Key? key,
      required this.title,
      required this.route,
      this.icon,
      this.data,
      this.args})
      : super(key: key);

  final String title;
  final String route;
  final dynamic data;
  final dynamic args;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 2,
                  color: Color(0x3416202A),
                  offset: Offset(0, 1),
                )
              ],
              borderRadius: BorderRadius.circular(12),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 8, 5, 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (icon != null) ...[icon!],
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                    child: Text(title,
                        style: getMediumStyle(
                            color: ColorManager.darkgrey, fontSize: 18)),
                  ),
                  const Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(0.9, 0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF95A1AC),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          //final args = FilteredTripsArguments(data: data, title: title);
          Navigator.pushNamed(context, route, arguments: args);
        });
  }
}
