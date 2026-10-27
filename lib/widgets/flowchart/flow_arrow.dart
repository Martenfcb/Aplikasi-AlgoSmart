import 'package:flutter/material.dart';

class FlowArrow extends StatelessWidget {
  final double height;

  final Color color;

  final String? leftLabel;

  final String? rightLabel;

  final bool showBranch;

  const FlowArrow({
    super.key,
    this.height = 45,
    this.color = Colors.blue,
    this.leftLabel,
    this.rightLabel,
    this.showBranch = false,
  });

  @override
  Widget build(BuildContext context) {

    if (showBranch) {
      return _buildBranchArrow();
    }

    return SizedBox(
      width: 40,
      height: height,

      child: Column(
        children: [

          Expanded(
            child: Container(
              width: 3,
              color: color,
            ),
          ),

          Icon(
            Icons.keyboard_arrow_down,
            color: color,
            size: 28,
          ),

        ],
      ),
    );
  }

  //-----------------------------------------
  // PANAH PERCABANGAN
  //-----------------------------------------

  Widget _buildBranchArrow() {

    return SizedBox(
      width: 240,
      height: 90,

      child: Stack(
        children: [

          Positioned(
            top: 0,
            left: 118,
            child: Container(
              width: 3,
              height: 25,
              color: color,
            ),
          ),

          Positioned(
            top: 25,
            left: 45,
            right: 45,
            child: Container(
              height: 3,
              color: color,
            ),
          ),

          Positioned(
            top: 25,
            left: 45,
            child: Container(
              width: 3,
              height: 35,
              color: color,
            ),
          ),

          Positioned(
            top: 25,
            right: 45,
            child: Container(
              width: 3,
              height: 35,
              color: color,
            ),
          ),

          Positioned(
            top: 58,
            left: 37,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: color,
            ),
          ),

          Positioned(
            top: 58,
            right: 37,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: color,
            ),
          ),

          if (leftLabel != null)
            Positioned(
              left: 10,
              top: 32,
              child: Text(
                leftLabel!,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          if (rightLabel != null)
            Positioned(
              right: 10,
              top: 32,
              child: Text(
                rightLabel!,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

        ],
      ),
    );
  }
}