import 'package:flutter/material.dart';
import 'package:pokemon_app/app/domain/models/ability/ability.dart';

class AbilityContent extends StatefulWidget {
  const AbilityContent({super.key, required this.ability});

  final Ability ability;

  @override
  State<AbilityContent> createState() => _AbilityContentState();
}

class _AbilityContentState extends State<AbilityContent> {
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
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
          message: widget.ability.description,
          child: Text(
            widget.ability.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.5,
              color: Colors.white,
            ),
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
