import 'package:flutter/material.dart';

import '../widgets/Skeleton.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton(
          width: 230,
          height: 20,
        ),
        SizedBox(
          height: 40,
        ),
        Skeleton(
          width: 120,
          height: 16,
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Skeleton(
                width: double.infinity,
                height: 70,
              ),
            );
          },
        )
      ],
    );
  }
}
