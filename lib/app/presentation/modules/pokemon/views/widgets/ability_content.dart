import 'package:flutter/material.dart';
import 'package:pokemon_app/app/domain/models/ability/ability.dart';

class AbilityContent extends StatelessWidget {
  const AbilityContent({super.key, required this.ability});

  final Ability ability;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Tooltip(
          triggerMode: TooltipTriggerMode.manual,
          key: tooltipkey,
          preferBelow: false,
          enableTapToDismiss: true,
          showDuration: Duration(seconds: 2),
          message: ability.description,
          child: Text(
            ability.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.5),
          ),
        ),
        const SizedBox(width: 5),
        IconButton(
          padding: EdgeInsets.zero,
          highlightColor: Colors.transparent,
          onPressed: () => tooltipkey.currentState?.ensureTooltipVisible(),
          icon: CircleAvatar(
            radius: 13,
            backgroundColor: Colors.white,
            child: Icon(Icons.question_mark, color: Colors.black, size: 13),
          ),
        ),
      ],
    );
  }
}
