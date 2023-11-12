import 'package:flutter/material.dart';

class IndividualWidget extends StatefulWidget {
  final List<int> isPresentList;
  final List<String> name;
  final List<int> rollno;

  const IndividualWidget({
    super.key,
    required this.name,
    required this.rollno,
    required this.isPresentList,
  });

  @override
  // ignore: library_private_types_in_public_api
  _IndividualWidgetState createState() => _IndividualWidgetState();
}

class _IndividualWidgetState extends State<IndividualWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.name.length,
      itemBuilder: (context, index) {
        return Card(
          child: Container(
            padding: const EdgeInsets.only(left: 9),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${widget.rollno[index]}'),
              ),
              title: Center(
                child: Text(widget.name[index]),
              ),
              trailing: ToggleIconButton(
                value: widget.isPresentList[index],
                onValueChanged: (newValue) {
                  // Update the isPresentList when the value changes
                  setState(() {
                    widget.isPresentList[index] = newValue;
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class ToggleIconButton extends StatelessWidget {
  final int value;
  final Function(int) onValueChanged;

  const ToggleIconButton({
    super.key,
    required this.value,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return value == 1
        ? IconButton(
            onPressed: () {
              onValueChanged(0); // Update the value to 0
            },
            icon: const Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          )
        : IconButton(
            onPressed: () {
              onValueChanged(1); // Update the value to 1
            },
            icon: const Icon(
              Icons.crop_square_outlined,
              color: Colors.red,
            ),
          );
  }
}
