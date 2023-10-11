import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apuntes/config/configs.dart';
import 'package:apuntes/entities/entities.dart';
import 'package:apuntes/provider/providers.dart';
import 'package:apuntes/widgets/widgets.dart';

class NoteItem extends ConsumerStatefulWidget {
  final Note note;

  const NoteItem({super.key, required this.note});

  @override
  NoteItemState createState() => NoteItemState();
}

class NoteItemState extends ConsumerState<NoteItem> {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return CustomContainer(
      color: color.surfaceVariant,
      borderVariant: BorderVariant.all,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.note.name,
                style: textStyle.titleMedium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(widget.note.note,
                    textAlign: TextAlign.justify,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis),
              ),
              if (widget.note.note.length > 50) ...[
                IconButton(
                    onPressed: () => toggleExpanded(),
                    icon: Icon(
                        isExpanded ? Icons.expand_more : Icons.expand_less))
              ]
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    ref.invalidate(noteFormProvider);
                    ref.invalidate(noteProvProvider);
                    ref.read(appRouterProvider).push('/note/${widget.note.id}');
                  },
                  child: const Text('EDITAR'))
            ],
          )
        ]),
      ),
    );
  }
}
