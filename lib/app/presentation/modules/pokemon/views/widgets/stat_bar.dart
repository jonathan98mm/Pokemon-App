import 'package:flutter/material.dart';
import 'package:pokemon_app/app/domain/models/stat/stat.dart';

class StatBar extends StatelessWidget {
  const StatBar({super.key, required this.stat});

  final Stat stat;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            stat.name,
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (_, constraints) => Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 15,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Container(
                    height: 15,
                    width: constraints.maxWidth * barMultiplier(stat.value),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent[100],
                      border: Border(
                        left: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        bottom: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Text(
                    stat.value.toString(),
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double barMultiplier(int value) {
    return ((value * 100) / 255) / 100;
  }
}
