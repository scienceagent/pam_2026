import 'package:flutter/material.dart';
import 'package:test_pam/list_items/chips_list_item.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Secțiune cu titlu + listă orizontală de chip-uri selectabile ("Working Hours", "Date").
class ChipsSectionWidget extends StatelessWidget {
  const ChipsSectionWidget({
    super.key,
    required this.item,
    required this.topSpacing,
    required this.chipWidths,
    required this.chipLeftPaddings,
    required this.onSelect,
    required this.onTapAction,
  });

  final ChipsListItem item;
  final double topSpacing;
  final List<double> chipWidths;
  final List<double> chipLeftPaddings;
  final Function(int index) onSelect; // anunță pagina ce chip s-a ales; pagina face setState
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Padding( // Padding: spațiu deasupra secțiunii
      padding: EdgeInsets.only(top: topSpacing),
      child: Column( // Column: titlul deasupra, chip-urile dedesubt
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 26.7, right: 23.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // titlu stânga, "See All" dreapta
              children: [
                Text(item.title, style: AppTextStyles.sectionSemiBold22),
                if (item.rightActionTitle != null) // collection-if
                  InkWell( // InkWell: "See All" clicabil
                    onTap: onTapAction,
                    child: Text(item.rightActionTitle!, style: AppTextStyles.actionRegular16),
                  ),
              ],
            ),
          ),
          SizedBox(height: 26), // SizedBox fără copil: spațiu vertical de 26px
          SizedBox( // SizedBox cu copil: fixează înălțimea listei orizontale la 56 (altfel ListView nu știe cât de înalt e)
            height: 56,
            child: ListView.separated( // ListView.separated: listă derulabilă cu separator între elemente
              scrollDirection: Axis.horizontal, // derulare pe orizontală
              padding: EdgeInsets.symmetric(horizontal: 26.7), // același padding stânga și dreapta
              itemCount: item.chips.length,
              separatorBuilder: (context, index) => SizedBox(width: 15), // separator: spațiu de 15px între chip-uri
              itemBuilder: (context, index) { // construiește chip-ul de pe poziția index
                final isSelected = index == item.selectedIndex;
                return InkWell( // InkWell: chip-ul e clicabil
                  onTap: () => onSelect(index),
                  borderRadius: BorderRadius.circular(10),
                  child: Container( // Container: lățime, padding, fundal colorat și colțuri rotunde
                    alignment: Alignment.centerLeft, // textul centrat vertical, lipit la stânga
                    width: chipWidths[index],
                    padding: EdgeInsets.only(left: chipLeftPaddings[index]),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryTeal : AppColors.chipBackground, // operator ternar: teal dacă e selectat
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.chips[index],
                      style: AppTextStyles.chipRegular20.copyWith(
                        color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
