import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ConversationLoadingCard extends StatelessWidget {
  final Color? color;
  const ConversationLoadingCard({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              maxRadius: 30.0,
              backgroundColor: color == null
                  ? Theme.of(context).colorScheme.onBackground
                  : color,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20.0,
                  width: MediaQuery.of(context).size.width / 4,
                  child: SkeletonAnimation(
                    child: Container(
                      decoration: BoxDecoration(
                          color: color == null
                              ? Theme.of(context).colorScheme.onBackground
                              : color,
                          borderRadius: BorderRadius.circular(8.0)),
                      height: 300.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: SkeletonAnimation(
                    child: Container(
                      decoration: BoxDecoration(
                          color: color == null
                              ? Theme.of(context).colorScheme.onBackground
                              : color,
                          borderRadius: BorderRadius.circular(10)),
                      height: 300.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 8.0,
        )
      ],
    );
  }
}
