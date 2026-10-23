import 'package:flutter/material.dart';
import 'package:test_pam/list_items/details_list_item.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Secțiunea "Details": titlu + text descriere.
class DetailsWidget extends StatelessWidget {
  const DetailsWidget({super.key, required this.item});

  final DetailsListItem item;

  @override
  Widget build(BuildContext context) {
    return Padding( // Padding: margini stânga/dreapta și spațiu sus
      padding: const EdgeInsets.only(left: 26, right: 21, top: 44),
      child: Column( // Column: titlu deasupra, descriere dedesubt
        crossAxisAlignment: CrossAxisAlignment.start, // aliniat la stânga
        children: [
          Text(item.title, style: AppTextStyles.sectionSemiBold22),
          SizedBox(height: 17), // SizedBox: spațiu vertical de 17px
          Text(item.description, style: AppTextStyles.descriptionRegular13), // textul trece singur pe mai multe rânduri
        ],
      ),
    );
  }
}
