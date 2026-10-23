# PAM 2026 — Aplicație Flutter (Health)

Laborator la disciplina **Programarea Aplicațiilor Mobile** (2026). Aplicația reproduce în Flutter
ecranele din macheta Figma „Laboratoare 2026 - V2”: pagina principală a unei aplicații medicale și
pagina cu detaliile unei programări.

## Ecrane

- **Home** (`lib/health_home_page.dart`) — antet, căutare, servicii medicale, programarea curentă,
  categorii (chips) și lista de medici.
- **Detalii programare** (`lib/appointment_details_page.dart`) — profilul medicului și detaliile
  programării; se deschide cu `Navigator.push` și se închide cu `Navigator.pop`.

## Structura proiectului

```
lib/
├── main.dart                  # punctul de intrare
├── test_pam_widget.dart       # MaterialApp
├── health_home_page.dart      # ecranul principal
├── appointment_details_page.dart
├── models/                    # Appointment, Doctor, HealthService
├── list_items/                # elementele listei (câte unul pe secțiune)
├── widgets/                   # widget-urile care desenează fiecare secțiune
└── resources/                 # culori, iconițe, imagini, texte, stiluri de text
assets/
├── fonts/                     # Outfit, Open Sans
├── icons/                     # SVG
└── images/
```

Ecranele sunt construite dintr-o listă de `ListItem`-uri; fiecare tip de element are widget-ul său
în `widgets/`.

## Rulare

Necesită Flutter SDK (Dart `^3.13.2`).

```bash
flutter pub get
flutter run
```

Teste: `flutter test`

## Dependențe

- [`flutter_svg`](https://pub.dev/packages/flutter_svg) — afișarea iconițelor SVG
- `cupertino_icons`

## Autor

Grigore Raevschi
