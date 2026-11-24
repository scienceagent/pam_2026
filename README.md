# PAM 2026 — Aplicație Flutter (Health)

Laborator la disciplina **Programarea Aplicațiilor Mobile** (2026). Aplicația reproduce în Flutter
ecranele din macheta Figma „Laboratoare 2026 - V2”: pagina principală a unei aplicații medicale și
pagina cu detaliile unei programări. Datele vin de la serviciul Web REST
`https://test-api-jlbn.onrender.com/lab2026/v2/feed` și `.../feed/details` (GET, JSON).

## Ecrane

- **Home** (`lib/pages/home/`) — antet, căutare și filtre, programarea curentă, servicii
  medicale, lista de medici; stări Loading / Error + Retry / Empty.
- **Detalii programare** (`lib/pages/appointment_details/`) — profilul medicului, ore și
  date selectabile; se deschide cu `Get.to` și se închide cu `Get.back`.

## Structura proiectului (Clean Architecture)

```
domain/   Dart pur: entities/, repositories/ (contracte), use_cases/, errors/AppException
data/     Retrofit + JSON: services/ (+ .g.dart), models/ (+ .g.dart), mappers/ (*_extension.dart), repositories/ (implementări)
di/       get_it: di_data.dart (injectData) + di_domain.dart (injectDomain) leagă data și domain
lib/      Presentation (Flutter + GetX)
├── main.dart                  injectData() + injectDomain() + runApp
├── test_pam_widget.dart       GetMaterialApp
├── base/                      BaseGetXController (Loading / Error)
├── pages/
│   ├── home/                  HomeController + HealthHomePage
│   └── appointment_details/   AppointmentDetailsController + AppointmentDetailsPage
├── list_items/                rândurile listelor
├── widgets/                   componente UI reutilizabile
└── resources/                 culori, iconițe, texte, stiluri
assets/   fonts/, icons/ (SVG)
test/     teste cu un server fals (helpers/fake_server.dart, fixtures/*.json)
```

Aplicația depinde doar de `domain` și `di`, nu și de `data`.

## Rulare

Necesită Flutter SDK (Dart `^3.13.2`).

```bash
flutter pub get
flutter run
```

Teste:

```bash
flutter test                          # aplicația (din rădăcina proiectului)
cd domain; dart test; cd ..           # Domain
cd data; dart test; cd ..             # Data
cd data; dart run build_runner build --delete-conflicting-outputs; cd ..   # regenerează *.g.dart
```

## Dependențe

- `get` (GetX), `get_it` (DI), `flutter_svg`
- `data`: `dio`, `json_annotation`; dev: `json_serializable`, `build_runner`

## Autor

Grigore Raevschi
