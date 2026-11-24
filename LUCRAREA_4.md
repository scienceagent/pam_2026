# Lucrarea de laborator nr. 4: servicii Web HTTP, JSON și Clean Architecture

**Disciplina:** Programarea aplicațiilor mobile (FCIM.PAM21.1), UTM
**Profesor:** Barbaros Vasile  **Student:** Grigore Raevschi
**Varianta API:** v2, `GET https://test-api-jlbn.onrender.com/lab2026/v2/feed` și `GET .../lab2026/v2/feed/details`

---

## Partea 1. Ce face aplicația

Aplicația „Health” are două ecrane: **Home** (salut, căutare și filtre, programarea curentă, servicii medicale, medicii din apropiere) și **Detalii programare** (profilul medicului, plata, orele și datele care se pot alege). Toate datele vin de la serviciul Web prin **HTTP GET**, în format **JSON**. Codul e împărțit în straturi după **Clean Architecture**: Presentation, Domain și Data, legate printr-un pachet de dependency injection (`di`).

---

## Partea 2. Straturile

| Strat | Folder | Ce conține | Ce știe |
|---|---|---|---|
| **Domain** | `domain/lib/` | `entities/` (`Doctor`, `HealthService`, `HomeData`, `Appointment`, `AppointmentDetails`, `SlotGroup`), `repositories/health_repository.dart` (contractul `HealthRepository`), `use_cases/` (`GetHomeFeedUseCase`, `GetAppointmentDetailsUseCase`, `FilterDoctorsUseCase`), `errors/app_exception.dart` | Dart pur. Nu știe de Flutter, Dio sau JSON. `domain/pubspec.yaml` nu are nicio dependență. |
| **Data** | `data/lib/` | `services/health_service.dart` (serviciul Web cu Retrofit: `@RestApi`, `@GET`; implementarea e generată în `.g.dart`), `models/` (formatul JSON al serverului), `mappers/*_extension.dart` (Model → Entitate, câte un fișier pe model), `repositories/health_repository_impl.dart` | Știe de Dio, Retrofit și JSON. Depinde de `domain`, ca să implementeze contractul lui. |
| **DI** | `di/lib/di_data.dart`, `di/lib/di_domain.dart` | `injectData()` și `injectDomain()` cu get_it | Singurul loc care vede și `data`, și `domain`, și le leagă. |
| **Presentation** | `lib/` | `base/` (`BaseGetXController`), `pages/home/` și `pages/appointment_details/` (controller GetX + pagină cu `Obx`), `list_items/`, `widgets/`, `resources/` | Flutter + GetX. Vede doar `domain` și `di` (vezi `pubspec.yaml`). |

Regula: dependențele merg spre interior. Presentation → Domain ← Data. Domain nu depinde de nimeni.

---

## Partea 3. Fluxul datelor: de la ecran la serviciul Web și înapoi (ecranul Home)

```
 UI          HealthHomePage  ──Get.put──▶ HomeController.onInit() ─▶ load()
                  ▲                              │ runRequest()  (isLoading = true -> spinner)
                  │ Obx redesenează              ▼
 Domain           │                     GetHomeFeedUseCase.call()
                  │                              ▼
                  │                     HealthRepository (abstract)
 ─ ─ ─ ─ ─ ─ ─ ─ ─│─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ▼ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
 Data             │                     HealthRepositoryImpl.getHomeFeed()  (_guard: erori -> AppException)
                  │                              ▼
                  │                     HealthService.getFeed()  (Retrofit)
                  │                              ▼
                  │                     @GET('/lab2026/v2/feed') ──HTTP GET───▶ Server (Render)
                  │                                                                   │ 200 + JSON
                  │                     HomeFeedModel.fromJson(...) (în .g.dart) ◀───┘
                  │                              ▼
                  │                     .toEntity (home_extension.dart) -> HomeData
                  │                              ▼  (urcă înapoi prin repository și use case)
 UI   items.value = [...]  ◀── _buildItems() ◀── onSuccess(data);  finally: isLoading = false
```

Pas cu pas:

1. **Pornirea.** `main()` (`lib/main.dart`) apelează `injectData()` și `injectDomain()`, apoi `runApp(TestPamWidget())`. Ecranul `HealthHomePage` face în `initState` `Get.put(HomeController())`.
2. **Controller-ul.** GetX apelează automat `HomeController.onInit()`, care pornește `load()`. Același `load()` e apelat și de butonul **Retry**.
3. **Starea Loading.** `load()` apelează `runRequest(getHomeFeedUseCase.call, ...)` din `BaseGetXController` (`lib/base/base_get_x_controller.dart`). Acesta pune `isLoading = true` și `errorMessage = null`, deci `Obx` arată `LoadingView` (spinner).
4. **Use case-ul.** `GetHomeFeedUseCase.call()` (`domain/lib/use_cases/get_home_feed_use_case.dart`) cere datele de la `healthRepository.getHomeFeed()`. Use case-ul știe doar de interfața `HealthRepository`, nu de implementare.
5. **Repository-ul.** get_it a dat în locul interfeței obiectul `HealthRepositoryImpl` (`data/lib/repositories/health_repository_impl.dart`). `getHomeFeed()` rulează totul în `_guard(...)`, care prinde erorile tehnice.
6. **Serviciul Web (Retrofit).** `HealthService.getFeed()` (`data/lib/services/health_service.dart`) e declarat cu `@GET('/lab2026/v2/feed')`, iar adresa de bază e în `@RestApi(baseUrl: ...)`. Clasa `_HealthService` generată de `build_runner` face cererea cu Dio și apelează `HomeFeedModel.fromJson`. Timeout-urile (60 s) și log-ul cererilor sunt setate pe Dio în `di/lib/di_data.dart`.
7. **Serverul** răspunde cu codul 200 și un text JSON. Dio îl decodează singur într-un `Map<String, dynamic>` (`ResponseType.json`).
8. **Deserializare.** `HomeFeedModel.fromJson(response.data!)` face din `Map` modelul de date (`data/lib/models/home_feed_model.dart`).
9. **Mapare.** În repository, `.toEntity` (extensia `HomeExtension` din `data/lib/mappers/home_extension.dart`) transformă modelul în entitatea `HomeData` din Domain.
10. **Înapoi în controller.** `HomeData` urcă prin use case la `runRequest`, care apelează `onSuccess`: controller-ul salvează `_data` și apelează `_buildItems()`. Lista de medici trece prin `FilterDoctorsUseCase` (căutare, filtre, sortare), apoi se construiesc rândurile `HeaderListItem`, `SearchListItem`, `AppointmentListItem`, `SectionListItem`, `HealthServicesListItem`, `DoctorListItem` (sau `EmptyListItem`).
11. **Redesenare.** `items.value = [...]` și, în `finally`, `isLoading = false`. `Obx` din `HealthHomePage` vede schimbarea și desenează lista.

Ecranul de detalii merge la fel: `AppointmentDetailsController.load()` → `GetAppointmentDetailsUseCase` → `getAppointmentDetails()` → `getFeedDetails()` → `GET /lab2026/v2/feed/details` → `AppointmentDetailsModel.fromJson` → `AppointmentDetails`. Use case-ul pune medicul apăsat în listă în locul celui trimis de server.

---

## Partea 4. Serializarea JSON

Modelele din `data/lib/models/` folosesc ambele variante.

**Manuală** (`HealthServiceModel`, `HomeFeedModel`, `AppointmentDetailsModel`): scriu eu `fromJson` și `toJson`. `HomeFeedModel` și `AppointmentDetailsModel` „aplatizează” obiectele imbricate (`notifications.hasUnread`, `search.hint`, `actions.bookAppointment`).

```dart
// data/lib/models/health_service_model.dart
factory HealthServiceModel.fromJson(Map<String, dynamic> json) => HealthServiceModel(
  id: json['id'] as String,
  name: json['name'] as String,
  iconUrl: json['iconUrl'] as String,
);
```

**Automată, cu json_serializable** (`DoctorModel`, `AppointmentModel`, `UserModel`, `SlotModel`, `SlotGroupModel`, `DoctorActionsModel`, `PaymentModel`, `DetailsModel`, `BookActionModel`): pun `@JsonSerializable()`, iar codul se generează în `*.g.dart`. Astfel fiecare obiect din JSON are tipul lui, fără `Map`-uri brute rămase în model.

```dart
// data/lib/models/doctor_model.dart
@JsonSerializable()
class DoctorModel {
  @JsonKey(name: 'avatarUrl')   // în JSON cheia e "avatarUrl", în model câmpul e imageUrl
  final String imageUrl;
  ...
  factory DoctorModel.fromJson(Map<String, dynamic> json) => _$DoctorModelFromJson(json);
}
```

Fișierele `doctor_model.g.dart`, `home_feed_model.g.dart` și `appointment_details_model.g.dart` se regenerează cu:

```bash
cd data
dart run build_runner build --delete-conflicting-outputs
```

Lanțul complet: text JSON → (Dio) `Map<String, dynamic>` → (`fromJson`) Model → (`toEntity`) Entitate. `toJson` face drumul invers și e verificat în `data/test/models_test.dart`.

---

## Partea 5. Operații asincrone, stări și erori

- Toate cererile întorc `Future`. `async` / `await` așteaptă răspunsul fără să blocheze interfața.
- `BaseGetXController.runRequest` ține stările comune pentru ambele ecrane: `isLoading` (`RxBool`) și `errorMessage` (`Rxn<String>`).

| Stare | Când | Ce se vede |
|---|---|---|
| **Loading** | `isLoading == true` | `LoadingView` (spinner) |
| **Success** | datele au venit | lista din `items` / conținutul detaliilor |
| **Empty** | nu e niciun medic de afișat | `EmptyView`: „No doctors match your search” + **Reset filters** (dacă sunt filtre active) sau „No doctors nearby yet” |
| **Error** | `errorMessage != null` | `ErrorView`: mesajul + butonul **Retry** (`controller.load`) |

**Traducerea erorilor** (în `HealthRepositoryImpl._guard` și `_messageFor`):

| Eroare tehnică (Data) | Mesaj în `AppException` (Domain) |
|---|---|
| `DioExceptionType.connectionError` | „No internet connection.” |
| `connectionTimeout` / `receiveTimeout` / `sendTimeout` | „The server is taking too long to respond. Please try again.” |
| `badResponse` (de ex. 404, 500) | „Server error (500).” |
| alt `DioException` | „Could not load data. Please try again.” |
| `TypeError` / `FormatException` (JSON de altă formă) | „The server sent unexpected data.” |

Drumul erorii: `DioException` → `AppException` (în Data) → `catch` în `runRequest` → `errorMessage.value = e.message` → `Obx` arată `ErrorView` → **Retry** apelează din nou `load()`. Orice altă excepție neprevăzută ajunge tot în `errorMessage` („Something went wrong. Please try again.”), iar detaliile tehnice se scriu doar în consolă. Pe emulator am oprit internetul: a apărut „No internet connection.”, iar după repornire Retry a încărcat datele.

---

## Partea 6. Componente UI reutilizabile

| Componentă | Fișier | Unde se folosește |
|---|---|---|
| `LoadingView`, `ErrorView`, `EmptyView` | `lib/widgets/state_views.dart` | ambele ecrane (Loading, Error + Retry) și lista de medici (Empty) |
| `AppNetworkImage` | `lib/widgets/app_network_image.dart` | imagini din URL (foto sau SVG) cu fundal gri la încărcare și la eroare; folosit în 5 widget-uri |
| `ChipsSectionWidget` | `lib/widgets/chips_section_widget.dart` | de două ori: „Working Hours” și „Date” |
| `SectionListWidget` | `lib/widgets/section_list_widget.dart` | titlurile „Health Services” și „Nearby Doctor” |
| `DoctorListWidget`, `HeaderListWidget`, `SearchWidget`, `AppointmentWidget`, `HealthServicesWidget`, `DoctorProfileWidget`, `DetailsWidget` | `lib/widgets/` | câte un widget pentru fiecare tip de rând (`ListItem` din `lib/list_items/`) |
| `BaseGetXController` | `lib/base/base_get_x_controller.dart` | baza pentru `HomeController` și `AppointmentDetailsController` |
| `AppColors`, `AppTextStyles`, `AppStrings`, `AppIcons` | `lib/resources/` | culori, stiluri, texte și iconițe comune |

---

## Partea 7. Dependency injection cu get_it

`main()` apelează două funcții care înregistrează obiectele în `GetIt.instance`, de jos în sus:

1. `injectData({Dio? dio})` din `di/lib/di_data.dart`: `HealthService` (Retrofit, peste un Dio cu timeout de 60 s și `LogInterceptor`, sau peste Dio-ul primit ca parametru în teste), apoi `HealthRepository` → `HealthRepositoryImpl`;
2. `injectDomain()` din `di/lib/di_domain.dart`: `GetHomeFeedUseCase`, `GetAppointmentDetailsUseCase`, `FilterDoctorsUseCase`.

Toate sunt `registerSingleton`: obiectul se creează o dată, la pornire, și apoi e același. Controllerele le iau prin `getIt<GetHomeFeedUseCase>()` (câmpul `getIt` din `BaseGetXController`).

**De ce aplicația nu depinde de `data`:** în `pubspec.yaml` al aplicației sunt doar `domain` și `di`. Controllerele cunosc doar use case-urile și interfața `HealthRepository`. Implementarea concretă o alege `di`. Dacă mâine schimb Dio cu alt client HTTP sau pun o bază de date locală, modific doar `data` și `di`, iar UI-ul rămâne la fel. `dio` apare în aplicație doar la `dev_dependencies`, pentru teste.

---

## Partea 8. Testarea și comenzile

Testele nu depind de internet. `test/helpers/fake_server.dart` pornește `injectData(dio: ...)` și `injectDomain()` cu un Dio care are un `HttpClientAdapter` fals. Acesta răspunde cu `test/fixtures/feed.json` și `feed_details.json`, care sunt răspunsuri reale salvate de la server. Poate simula și lipsa internetului, timeout-ul, HTTP 500 și un JSON greșit. Restul lanțului (Retrofit Service → Repository → UseCase → Controller → UI) rulează exact ca în aplicație.

| Unde | Comandă | Teste |
|---|---|---|
| aplicația | `flutter test` | 16 (12 în `controllers_test.dart`, 4 în `widget_test.dart`) |
| `domain/` | `dart test` | 2 (`FilterDoctorsUseCase`) |
| `data/` | `dart test` | 4 (JSON → Model → Entitate, serializare manuală și automată) |

```bash
flutter pub get
flutter run                      # rulează pe emulator/telefon, cu serverul real
flutter analyze                  # fără probleme
flutter test                     # testele aplicației
cd domain; dart test; cd ..
cd data;   dart test; cd ..
```

Notă: serverul e pe Render (plan gratuit) și poate „dormi”. Prima cerere poate dura 30-50 s, de aceea timeout-ul e de 60 s.

---

## Partea 9. Întrebări posibile și răspunsuri scurte

| Întrebare | Răspuns |
|---|---|
| De ce Domain nu știe de Dio? | Domain conține regulile aplicației, nu detaliile tehnice. Dacă schimb sursa datelor (alt client HTTP, cache local), Domain rămâne la fel. Așa îl pot testa fără rețea. |
| Ce face un use case? | O singură acțiune a aplicației, de exemplu „ia datele ecranului principal”. Se apelează ca o funcție, prin `call()`: `getHomeFeedUseCase()`. Poate conține o regulă de business, ca `GetAppointmentDetailsUseCase`, care pune medicul ales. |
| Ce se întâmplă dacă serverul nu răspunde? | După 60 s Dio aruncă un `DioException` de tip timeout. `HealthRepositoryImpl` îl transformă în `AppException` cu mesajul „The server is taking too long...”. Controller-ul îl pune în `errorMessage`, apare `ErrorView` cu Retry. |
| De ce mapper și nu `fromJson` direct în entitate? | Modelul copiază formatul serverului (chei ca `avatarUrl`, obiecte imbricate). Entitatea are forma de care are nevoie aplicația. Mapper-ul le separă: dacă serverul schimbă JSON-ul, modific modelul și mapper-ul, nu și Domain sau UI. |
| Unde ai pune un POST? | `HealthService`: metodă cu `@POST('/...')` și `@Body() Model body`, apoi `build_runner`; `HealthRepository` + `HealthRepositoryImpl`: metoda nouă; un use case nou (de ex. `BookAppointmentUseCase`); înregistrare în `injectDomain`; controller-ul îl apelează prin `runRequest`. Serverul variantei v2 are doar GET (POST întoarce 404), de aceea butonul Book arată doar un mesaj. |
| Care e diferența dintre `HealthRepository` și `HealthRepositoryImpl`? | Primul e contractul (clasă abstractă în Domain, spune CE date). Al doilea e implementarea (în Data, spune DE UNDE: de la serviciul Web). |
| Ce face get_it? | E un registru de obiecte. `injectData` și `injectDomain` le înregistrează o dată, iar controllerele le cer după tip. Așa clasele nu își creează singure dependențele. |
| De ce aplicația nu are `data` în `pubspec.yaml`? | Ca UI-ul să nu poată folosi direct Dio sau modelele JSON. Legătura o face doar `di`. |
| Manual sau json_serializable, când care? | json_serializable pentru modele simple (mai puțin cod, fără greșeli la chei). Manual când JSON-ul are obiecte imbricate pe care vreau să le aplatizez (`HomeFeedModel` ia `notifications.hasUnread` și `search.hint`). |
| Cum testezi fără internet? | Dio primește un adaptor fals (`fake_server.dart`) care întoarce JSON-ul real salvat în `test/fixtures/`. Restul codului e cel real. |
| Ce rol are `BaseGetXController`? | Ține codul comun al controllerelor: accesul la get_it și `runRequest`, care face Loading → Success sau Error. Așa nu repet `try/catch/finally` în fiecare ecran. |
