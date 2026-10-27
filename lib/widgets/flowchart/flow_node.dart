import 'package:flutter/material.dart';

import '../../models/flow_node_model.dart';

class FlowNode extends StatelessWidget {
  final FlowNodeModel node;

  const FlowNode({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    switch (node.type) {
      case FlowNodeType.start:
      case FlowNodeType.end:
        return _buildStartEnd();

      case FlowNodeType.process:
        return _buildProcess();

      case FlowNodeType.input:
      case FlowNodeType.output:
        return _buildInputOutput();

      case FlowNodeType.decision:
        return _buildDecision();
    }
  }

  //------------------------------------------
  // START / END
  //------------------------------------------

  Widget _buildStartEnd() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 170,
      height: 70,
      decoration: BoxDecoration(
        color: node.active
            ? node.color
            : node.color.withOpacity(.15),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: node.color,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          node.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: node.active
                ? Colors.white
                : node.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  //------------------------------------------
  // PROCESS
  //------------------------------------------

  Widget _buildProcess() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 190,
      height: 75,
      decoration: BoxDecoration(
        color: node.active
            ? node.color
            : node.color.withOpacity(.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: node.color,
          width: 2,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            node.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: node.active
                  ? Colors.white
                  : node.color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  //------------------------------------------
  // INPUT / OUTPUT
  //------------------------------------------

  Widget _buildInputOutput() {
    return Transform(
      transform: Matrix4.skewX(-0.2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 190,
        height: 75,
        decoration: BoxDecoration(
          color: node.active
              ? node.color
              : node.color.withOpacity(.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: node.color,
            width: 2,
          ),
        ),
        child: Transform(
          transform: Matrix4.skewX(0.2),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                node.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: node.active
                      ? Colors.white
                      : node.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //------------------------------------------
  // DECISION
  //------------------------------------------

  Widget _buildDecision() {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [

          Transform.rotate(
            angle: 0.785398,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: node.active
                    ? node.color
                    : node.color.withOpacity(.12),
                border: Border.all(
                  color: node.color,
                  width: 2,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Text(
              node.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: node.active
                    ? Colors.white
                    : node.color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),

        ],
      ),
    );
  }
}