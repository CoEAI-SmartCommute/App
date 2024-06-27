import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class SaveLocForm extends StatefulWidget {
  const SaveLocForm({super.key});

  @override
  State<SaveLocForm> createState() => _SaveLocFormState();
}

class _SaveLocFormState extends State<SaveLocForm> {
  GroupButtonController groupButtonController = GroupButtonController();

  @override
  void initState() {
    groupButtonController.selectIndex(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(

      child: Column(
        children: [
          const Text('Fill your complete address'),
          const Text('Save address as'),
          const SizedBox(
            height: 10,
          ),
          GroupButton(
            isRadio: true,
            controller: groupButtonController,
            buttons: const ["Home", "Work", "Other"],
          ),
          
        ],
      ),
    );
  }
}
