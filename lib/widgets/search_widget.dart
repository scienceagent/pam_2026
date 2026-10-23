import 'package:flutter/material.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_icons.dart';
import 'package:test_pam/resources/app_strings.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Bara de căutare: lupă + câmp de text + buton de filtrare.
class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, required this.onSearch, required this.onTapFilter});

  final Function(String? text) onSearch; // callback cu parametru: primește textul scris
  final VoidCallback onTapFilter;

  @override
  Widget build(BuildContext context) {
    return Padding( // Padding: spațiu de 24px deasupra barei
      padding: const EdgeInsets.only(top: 24),
      child: Container( // Container: cutie cu înălțime, padding interior și decorație
        height: 52,
        padding: EdgeInsets.only(left: 16, right: 16), // spațiu în INTERIORUL containerului
        decoration: BoxDecoration( // BoxDecoration: culoare, chenar, colțuri rotunjite
          color: AppColors.lightGrey03,
          border: Border.all(color: AppColors.lightGrey02), // chenar pe toate laturile
          borderRadius: BorderRadius.circular(15), // colțuri rotunjite cu raza 15
        ),
        child: Row( // Row: elemente pe orizontală
          children: [
            AppIcons.searchIcon, // iconiță SVG lupă
            SizedBox(width: 15), // SizedBox: spațiu fix de 15px
            Expanded( // Expanded: câmpul de text ia tot spațiul rămas
              child: TextField( // TextField: câmp în care utilizatorul scrie text
                style: AppTextStyles.regular14.copyWith(color: AppColors.black01),
                cursorColor: AppColors.coralGreen01,
                decoration: InputDecoration( // InputDecoration: hint, chenar etc. ale câmpului
                  hintText: AppStrings.searchSomething, // textul gri afișat când câmpul e gol
                  hintStyle: AppTextStyles.regular14,
                  border: InputBorder.none, // fără linie/chenar implicit
                  isCollapsed: true, // elimină padding-ul implicit al câmpului
                ),
                onChanged: onSearch, // apelat la fiecare modificare a textului
              ),
            ),
            InkWell(onTap: onTapFilter, child: AppIcons.settingIcon), // InkWell: iconiță clicabilă
          ],
        ),
      ),
    );
  }
}
