import 'package:flutter/material.dart';
import 'package:phone_boookapp/constants.dart';

class Header extends StatefulWidget {
  const Header({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.15,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
            ),
            height: widget.size.height *0.1,
            decoration: BoxDecoration(
              color: pColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Text(
                    'Twoja lista kontaktów',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: sTextColor, fontWeight: FontWeight.w300, letterSpacing: 2.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
