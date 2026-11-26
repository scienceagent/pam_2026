# PAM 2026 — Health (Flutter)

Aplicație Flutter realizată la disciplina **Programarea Aplicațiilor Mobile** (UTM, FCIM, 2026).
Reproduce ecranele din macheta Figma „Laboratoare 2026 - V2”: pagina principală a unei aplicații
medicale și pagina cu detaliile unei programări. Toate datele vin de la un **serviciu Web REST**
(HTTP GET, JSON), iar codul este organizat după **Clean Architecture**.

## Ecrane

- **Home** — salut, căutare și filtre, programarea curentă, servicii medicale, medicii din apropiere.
- **Detalii programare** — profilul medicului, plata, orele și datele care se pot alege.

Fiecare ecran are stările **Loading** (spinner), **Success**, **Empty** (nu există rezultate, cu
„Reset filters”) și **Error** (mesaj clar + buton **Retry**).

## Serviciul Web

| Cerere | Ce întoarce |
|---|---|
| `GET https://test-api-jlbn.onrender.com/lab2026/v2/feed` | datele ecranului Home: `user`, `notifications`, `search`, `appointment`, `healthServices`, `nearbyDoctors` |
| `GET https://test-api-jlbn.onrender.com/lab2026/v2/feed/details` | datele ecranului de detalii: `doctor`, `payment`, `details`, `workingHours`, `date`, `actions` |

> Serverul este pe Render (plan gratuit) și „adoarme” când nu e folosit: prima cerere poate dura
> 30–50 s. De aceea timeout-ul din aplicație este de 60 s.

## Structura proiectului

Aplicația Flutter este în `test_pam/`, iar straturile sunt pachete Dart separate, alături de ea:

```
pam_2026/
├── domain/      Dart pur, fără dependențe
│   └── lib/     entities/, repositories/ (contracte), use_cases/, errors/AppException
├── data/        legătura cu serverul (Dio + Retrofit + JSON)
│   └── lib/     services/ (Retrofit), models/ (JSON), mappers/ (Model → Entitate), repositories/ (implementări)
├── di/          dependency injection cu get_it
│   └── lib/     di_data.dart (injectData), di_domain.dart (injectDomain)
└── test_pam/    aplicația Flutter (Presentation, GetX)
    ├── lib/
    │   ├── main.dart        injectData() + injectDomain() + runApp
    │   ├── base/            BaseGetXController (Loading / Error)
    │   ├── pages/           home/, appointment_details/ (controller + pagină)
    │   ├── list_items/      rândurile listelor
    │   ├── widgets/         componente UI reutilizabile
    │   └── resources/       culori, iconițe, texte, stiluri
    ├── assets/              fonturi, iconițe SVG
    └── test/                teste cu un server fals
```

**Cine depinde de cine:** `domain` nu depinde de nimeni; `data` depinde de `domain`; `di` le leagă
pe amândouă; aplicația vede doar `domain` și `di`, deci UI-ul nu poate folosi direct Dio sau JSON.

## Fluxul datelor

```
Ecran → Controller → UseCase → Repository → HealthService (Retrofit) → Dio → GET la server
Server → JSON → Model (fromJson) → Entitate (toEntity) → Controller → Obx redesenează ecranul
```

1. `HomeController` pornește `load()`; pe ecran apare spinner-ul.
2. `GetHomeFeedUseCase` cere datele de la contractul `HealthRepository`.
3. `HealthRepositoryImpl` apelează `HealthService.getFeed()`, declarat cu `@GET('/lab2026/v2/feed')`.
4. Codul generat de Retrofit face cererea prin **Dio** și transformă JSON-ul în `HomeFeedModel`.
5. Mapperul `toEntity` face din model entitatea `HomeData`, care ajunge înapoi în controller.
6. Erorile (fără internet, timeout, eroare HTTP, JSON greșit) devin `AppException` cu un mesaj clar,
   afișat pe ecran împreună cu butonul Retry.

**Dio** este clientul HTTP (trimite cererea, timeout, log, erori). **Retrofit** generează automat,
din adnotările `@GET`, codul care folosește Dio.

## Rulare

Necesită Flutter SDK (Dart `^3.13.2`).

```bash
cd test_pam
flutter pub get
flutter run
```

## Teste

Testele nu au nevoie de internet: un Dio fals răspunde cu JSON-ul real salvat în `test/fixtures/`.

```bash
cd test_pam && flutter test      # 16 teste: controllere și UI
cd domain   && dart test         # 2 teste: FilterDoctorsUseCase
cd data     && dart test         # 4 teste: JSON → Model → Entitate
```

Regenerarea codului generat (`*.g.dart`) după modificarea modelelor sau a serviciului:

```bash
cd data
dart run build_runner build --delete-conflicting-outputs
```

## Tehnologii

- **UI:** Flutter, GetX (`get`), `flutter_svg`
- **DI:** `get_it`
- **Rețea și JSON:** `dio`, `retrofit`, `json_annotation`; generare cu `retrofit_generator`, `json_serializable`, `build_runner`

## Autor

Grigore Raevschi
