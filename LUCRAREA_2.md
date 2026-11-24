# Lucrarea de laborator nr. 2: date din JSON, serializare și GetX

**Ce s-a făcut:** în lucrarea 1 toate datele (medici, servicii, programare, texte, imagini) erau scrise direct în cod. În lucrarea 2, după structura din repo-ul profesorului:

1. datele se citesc **asincron** dintr-un fișier **JSON** (`assets/data/lab_v2.json`);
2. JSON-ul se transformă în obiecte prin **serializare manuală** (`fromJson` / `toJson` scrise de mână) și **automată** (`json_serializable` + `build_runner`, cu fișiere `.g.dart` generate);
3. starea ecranelor e gestionată cu **GetX** (`GetxController`, variabile `.obs`, `Obx`, `Get.put` / `Get.find`), nu cu `setState`;
4. fiecare ecran stă în `lib/screens/<ecran>/`, împreună cu controller-ul lui;
5. sunt tratate stările **încărcare / date / listă goală / eroare**;
6. s-au adăugat **căutare, filtrare, sortare, favorite** și deschiderea detaliilor pentru medicul apăsat;
7. imaginile vin din **URL-uri** din JSON, nu din `assets/images`;
8. s-au scris **teste** pentru controllere, serializare și UI.

---

## Partea 1. Noțiuni de bază

| Noțiune | Definiție |
|---|---|
| **JSON** | Format text pentru date: obiecte `{ "cheie": valoare }` și liste `[ ... ]`. |
| **`jsonDecode`** | Text JSON → `Map<String, dynamic>` / `List` (din `dart:convert`). |
| **`jsonEncode`** | Obiect → text JSON. Apelează automat `toJson()` al obiectului. |
| **`Map<String, dynamic>`** | Dicționar: cheia e text, valoarea poate fi de orice tip (`dynamic`). |
| **Serializare** | Transformarea obiect ↔ JSON. `fromJson` = Map → obiect, `toJson` = obiect → Map. |
| **Serializare manuală** | `fromJson` / `toJson` scrise de mână (la noi: `HealthService`, `HomeData`, `AppointmentDetails`, `SlotGroup`). |
| **Serializare automată** | `@JsonSerializable()` pe clasă. Pachetul **json_serializable** generează codul în `*.g.dart` la comanda `dart run build_runner build` (la noi: `Doctor`, `Appointment`). |
| **`part 'x.g.dart'`** | Leagă fișierul generat de fișierul modelului. Funcțiile generate se numesc `_$XFromJson` / `_$XToJson`. |
| **`@JsonKey(...)`** | Setări pe câmp: `name:` (alt nume de cheie în JSON), `defaultValue:` (valoare dacă lipsește), `readValue:` (citire personalizată). |
| **`Future<T>`** | O valoare de tip `T` care va fi disponibilă **mai târziu**. Se termină cu o valoare sau cu o eroare. |
| **`async` / `await`** | `async` = funcția întoarce un Future. `await` = așteaptă Future-ul fără să blocheze UI-ul. |
| **`try / catch / finally`** | `catch` prinde excepția (→ mesaj de eroare). `finally` rulează mereu (→ oprește încărcarea). |
| **GetX** | Pachetul `get`: gestionarea stării, a dependențelor și navigare, cu puțin cod. |
| **`GetxController`** | Clasa care ține starea și logica unui ecran. Are metodele de ciclu de viață `onInit()` și `onClose()`. |
| **`onInit()`** | Apelat automat o singură dată, imediat după `Get.put`. Aici pornim încărcarea datelor. |
| **`.obs` / `Rx`** | Variabilă **observabilă**: `true.obs` → `RxBool`, `RxList<T>`, `Rxn<T>` (poate fi null). Citire/scriere prin `.value`. La fiecare schimbare anunță widget-urile care o ascultă. |
| **`Obx(() => ...)`** | Widget care reconstruiește conținutul când se schimbă un observabil citit în interiorul lui. |
| **`Get.put(C())`** | Creează și înregistrează controller-ul (injectare de dependențe). |
| **`Get.find<C>()`** | Ia controller-ul deja înregistrat, din orice loc. |
| **`Get.delete<C>()`** | Șterge controller-ul când nu mai e necesar. |
| **`GetMaterialApp`** | `MaterialApp` cu suport GetX. Necesar pentru `Get.to` / `Get.back`. |
| **`Get.to(() => Pagina())` / `Get.back()`** | Navigare GetX: deschide o pagină / revine la cea anterioară, fără `context`. |

---

## Partea 2. Arhitectura

```
assets/data/lab_v2.json                          (1) datele
        │  rootBundle.loadString + jsonDecode     async
        ▼
resources/app_data.dart  AppData.read()          (2) Future<Map<String, dynamic>>
        │
        ▼
models/  fromJson (manual + generat în .g.dart)  (3) obiecte Dart
        │
        ▼
screens/<ecran>/<ecran>_controller.dart          (4) GetxController: logica + variabile .obs
        │  isLoading / errorMessage / items / details
        ▼
screens/<ecran>/<ecran>_page.dart  Obx(...)      (5) UI-ul afișează valorile observabile
```

Fluxul la pornire:
```
main() -> TestPamWidget (GetMaterialApp) -> HealthHomePage
  initState: Get.put(HomeController())
    GetX apelează onInit() -> load()
      isLoading = true                 -> Obx arată LoadingView (spinner)
      await AppData.read()             -> 800 ms + citire + jsonDecode
      HomeData.fromJson(...)           -> modelele
      _buildItems() -> items.value     -> Obx arată lista (sau rândul Empty)
      la excepție: errorMessage = ...  -> ErrorView cu Retry -> load() din nou
      finally: isLoading = false
```

---

## Partea 3. Structura proiectului (ca la profesor)

```
lib/
├── main.dart                        runApp(TestPamWidget)
├── test_pam_widget.dart             GetMaterialApp
├── screens/
│   ├── home/
│   │   ├── health_home_page.dart    pagina principală (Obx)
│   │   └── home_controller.dart     HomeController (GetxController)
│   └── appointment_details/
│       ├── appointment_details_page.dart
│       └── appointment_details_controller.dart
├── models/                          Doctor (+ .g.dart), HealthService, HomeData/Appointment (+ .g.dart), AppointmentDetails
├── list_items/                      ListItem + câte un item pe secțiune
├── widgets/                         widget-ul fiecărei secțiuni
└── resources/                       culori, iconițe, texte, stiluri, app_data (citirea JSON)
assets/
├── data/lab_v2.json
├── fonts/
└── icons/
```

| Element | Profesor (`dvasea1/pam_2026`) | Proiectul nostru |
|---|---|---|
| Ecran + controller în `screens/<ecran>/` | `screens/home/food_delvery_home_page.dart` + `home_controller.dart` | `screens/home/health_home_page.dart` + `home_controller.dart` |
| Controller | `HomeController extends GetxController`, `onInit()` | la fel |
| Stare | `RxList<ListItem> items`, `.obs`, `Rxn` | la fel: `RxList<ListItem> items`, `RxBool isLoading`, `Rxn<String> errorMessage` |
| Rândurile ecranului construite în controller | `getItems()` → `items.value = [...]` | `_buildItems()` → `items.value = [...]` |
| UI | `Get.put` în `initState`, `Get.find`, `Obx` | la fel |
| Aplicație | `GetMaterialApp` | la fel |
| Serializare manuală | `Product.fromJson` / `toJson` | `HealthService` (+ `HomeData`, `AppointmentDetails`) |
| Serializare automată | `User` cu `@JsonSerializable`, `@JsonKey`, `user.g.dart` | `Doctor`, `Appointment` cu `doctor.g.dart`, `home_data.g.dart` |
| Dependențe | `get: 4.7.3`, `json_annotation`, `json_serializable`, `build_runner` (dev) | la fel |

---

## Partea 4. Fișiere și clase: ce e nou, ce s-a modificat, ce s-a șters

### 4.1. Fișiere NOI

| Fișier | Clase | Rol |
|---|---|---|
| `assets/data/lab_v2.json` | – | Toate datele: `homeScreen` (utilizator, programare, servicii, medici) și `appointmentDetails` (medic, plată, descriere, ore, date). |
| `lib/resources/app_data.dart` | `AppData` | `read()`: întârziere de 800 ms + `rootBundle.loadString` + `jsonDecode` → `Future<Map>`. Funcția de citire și întârzierea se pot înlocui în teste. |
| `lib/screens/home/home_controller.dart` | `DoctorSort` (enum), `HomeController` | Observabile: `items`, `isLoading`, `errorMessage`. Filtre: `query`, `specialty`, `favoritesOnly`, `sort`. Metode: `onInit()`, `load()` (async), `search()`, `applyFilters()`, `resetFilters()`, `toggleFavorite()`, `_buildItems()`. |
| `lib/screens/home/health_home_page.dart` | `HealthHomePage` | `Get.put` în `initState`, `Obx` → spinner / eroare / listă. Mutat din `lib/`. |
| `lib/screens/appointment_details/appointment_details_controller.dart` | `AppointmentDetailsController` | Observabile: `isLoading`, `errorMessage`, `details`. Metode: `load()` (async), `selectHour()`, `selectDate()`. Înlocuiește `setState` din lucrarea 1. |
| `lib/screens/appointment_details/appointment_details_page.dart` | `AppointmentDetailsPage` | `open(doctor:)` = `Get.to(...)`. `Get.put` în `initState`, `Get.delete` în `dispose`, `Obx`, `Get.back()`. Mutat din `lib/`. |
| `lib/models/doctor.g.dart`, `lib/models/home_data.g.dart` | – | **Generate automat** de `build_runner`: `_$DoctorFromJson`, `_$DoctorToJson`, `_$AppointmentFromJson`, `_$AppointmentToJson`. Nu se modifică de mână. |
| `lib/models/home_data.dart` | `Appointment` (automat), `HomeData` (manual) | Datele ecranului principal. `Appointment` a fost mutat aici din vechiul `appointment.dart`. |
| `lib/models/appointment_details.dart` | `SlotGroup`, `AppointmentDetails` (manual) | Datele paginii de detalii. `SlotGroup.select(index)` = copie cu alt chip selectat. |
| `lib/list_items/empty_list_item.dart` | `EmptyListItem` | Rândul afișat când nu există medici (cu sau fără butonul Reset). |
| `lib/widgets/state_views.dart` | `LoadingView`, `ErrorView`, `EmptyView` | Afișarea pentru încărcare, eroare cu Retry, listă goală. |
| `lib/widgets/app_network_image.dart` | `AppNetworkImage` | Imagine din URL (`Image.network` / `SvgPicture.network`) cu fundal gri cât se încarcă sau la eroare. |
| `lib/widgets/filter_sheet.dart` | `showFilterSheet`, `_FilterSheet`, `_Chip` | Fereastra de filtre. Selecția e locală până la **Apply**, care apelează `HomeController.applyFilters`. |
| `test/controllers_test.dart` | – | 9 teste: controllere + serializare manuală și automată. |

### 4.2. Fișiere MODIFICATE

| Fișier | Ce s-a schimbat |
|---|---|
| `pubspec.yaml` | Adăugate `get: 4.7.3`, `json_annotation`, `json_serializable`, `build_runner` (dev). La `assets:`, `assets/images/` a fost înlocuit cu `assets/data/`. |
| `lib/test_pam_widget.dart` | `MaterialApp` → `GetMaterialApp`. |
| `lib/models/doctor.dart` | Serializare **automată**: `@JsonSerializable()`, `part 'doctor.g.dart'`, `@JsonKey(name: 'avatarUrl')`, `@JsonKey(name: 'distance', defaultValue: '')`, `readValue` pentru `specialty`/`clinic`, `toJson()`. `imagePath` → `imageUrl`. Adăugate `id`, `isFavorite`, `copyWith`, `distanceMeters`. |
| `lib/models/health_service.dart` | Serializare **manuală**: `fromJson` + `toJson`. `imagePath` → `imageUrl`. Adăugat `id`. |
| `lib/list_items/header_list_item.dart` | `firstName` → `greeting`, `subtitle`, `avatarUrl` (din JSON). |
| `lib/list_items/search_list_item.dart` | Adăugate `hint` (din JSON) și `hasActiveFilters`. |
| `lib/list_items/appointment_list_item.dart` | Importă `Appointment` din `home_data.dart`. |
| `lib/list_items/doctor_profile_list_item.dart` | `doctor` + `payment` → `details` (`AppointmentDetails`). |
| `lib/list_items/chips_list_item.dart` | `selectedIndex` e `final` și obligatoriu (vine din controller). |
| `lib/widgets/header_list_widget.dart` | Avatar `AppNetworkImage`. Textele vin din JSON. |
| `lib/widgets/search_widget.dart` | Primește `item` (hint) și `controller`. `Badge` pe iconița de filtre când există filtre active. |
| `lib/widgets/appointment_widget.dart` | Titlul vine din JSON. Poza e `AppNetworkImage`. |
| `lib/widgets/doctor_list_widget.dart` | Rândul e clicabil (→ detalii). Poza e `AppNetworkImage`. Inima e plină dacă medicul e favorit. Adresa lungă se scurtează cu „...”. |
| `lib/widgets/doctor_profile_widget.dart` | Date din `AppointmentDetails`. Butoanele apar doar dacă sunt active în JSON. |
| `lib/widgets/health_services_widget.dart` | Iconița SVG din URL. |
| `lib/widgets/chips_section_widget.dart` | Suportă mai multe chip-uri decât în Figma. |
| `lib/resources/app_strings.dart` | Șterse textele care vin acum din JSON. Adăugate textele noi (Retry, Empty, filtre, `bookedAt`). |
| `test/widget_test.dart` | Pornește aplicația cu date de test. Verifică încărcarea, datele din JSON, Empty + Reset, detaliile, chip-urile, `Get.back` și ștergerea controller-ului. `Get.reset()` între teste. |

### 4.3. Fișiere ȘTERSE sau MUTATE

| Fișier | De ce |
|---|---|
| `lib/health_home_page.dart` | Mutat în `lib/screens/home/`. |
| `lib/appointment_details_page.dart` | Mutat în `lib/screens/appointment_details/`. |
| `lib/models/appointment.dart` | `Appointment` a fost mutat în `home_data.dart`. |
| `lib/resources/app_images.dart` | Imaginile vin din JSON ca URL-uri. |
| `assets/images/*` (10 imagini) | Înlocuite de imaginile din rețea. |

### 4.4. Teste (`flutter test`: 12 teste, toate trec)

`test/controllers_test.dart`:
1. `HomeController` încarcă JSON-ul (`isLoading` false, fără eroare, 2 medici);
2. căutarea după nume, specialitate și adresă; fără rezultat → rândul Empty;
3. favorite + filtrul „doar favorite”;
4. filtrul de specialitate, sortarea și resetarea;
5. JSON fără medici → Empty fără filtre active;
6. JSON invalid → `errorMessage` setat;
7. `AppointmentDetailsController`: păstrează medicul apăsat și schimbă selecția;
8. serializare **automată**: `Doctor` și `Appointment` → `jsonEncode` → `fromJson` dau aceleași date;
9. serializare **manuală**: `HealthService` → `toJson` → `fromJson`.

`test/widget_test.dart`:
1. ecranul principal arată datele din JSON (după spinner);
2. căutarea fără rezultat arată Empty, iar Reset aduce medicii înapoi;
3. programarea deschide detaliile și chip-urile se pot selecta; `Get.back()` închide pagina și șterge controller-ul; un medic din listă se deschide cu datele lui.

### 4.5. Comenzi

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # regenerează *.g.dart după ce schimbi un model adnotat
flutter run
flutter test
```

---

## Partea 5. Ce spune studentul la predare

> Bună ziua. Prezint lucrarea de laborator nr. 2. Am pornit de la aplicația din lucrarea 1, cu ecranul principal și pagina cu detaliile programării. Acolo toate datele erau scrise direct în cod, iar imaginile erau locale, în `assets/images`.
>
> **Scopul lucrării 2** a fost să separ datele de interfață. Datele se citesc acum asincron dintr-un fișier JSON, sunt transformate în obiecte prin serializare, iar starea ecranelor o gestionez cu **GetX**. Am păstrat structura de la curs: fiecare ecran e în folderul `screens`, împreună cu controller-ul lui.
>
> **Datele.** Am creat fișierul `assets/data/lab_v2.json` și l-am declarat în `pubspec.yaml` la `assets`. Are două chei: `homeScreen` și `appointmentDetails`. Imaginile sunt link-uri, așa că am șters pozele locale. Pentru afișare am făcut widget-ul `AppNetworkImage`, care arată un fundal gri cât timp imaginea se încarcă.
>
> **Citirea asincronă.** În `AppData.read()` citesc fișierul cu `rootBundle.loadString` și îl transform cu `jsonDecode` într-un `Map`. Funcția întoarce un **Future**, adică o valoare care va fi disponibilă mai târziu. Am marcat-o cu **async**, iar cu **await** aștept rezultatul fără să blochez interfața. Am pus și o întârziere de 800 de milisecunde, ca să se vadă încărcarea, la fel ca la un server real.
>
> **Serializarea.** Am folosit ambele variante prezentate la curs. Varianta **manuală**: în `HealthService` am scris de mână `fromJson`, care face din `Map` un obiect, și `toJson`, care face din obiect un `Map`. La fel sunt scrise `HomeData` și `AppointmentDetails`, care citesc din obiecte imbricate. Varianta **automată**: pe `Doctor` și `Appointment` am pus adnotarea `@JsonSerializable()`, iar cu `@JsonKey` am indicat alt nume de cheie, de exemplu `avatarUrl` pentru câmpul `imageUrl`, și valori implicite. Am rulat `dart run build_runner build`, iar pachetul `json_serializable` a generat fișierele `doctor.g.dart` și `home_data.g.dart`, cu funcțiile `_$DoctorFromJson` și `_$DoctorToJson`. Ele sunt legate de model prin `part`.
>
> **GetX, controller-ul.** Pentru fiecare ecran am un controller care extinde `GetxController`: `HomeController` și `AppointmentDetailsController`. El ține starea și logica ecranului. Starea e formată din variabile **observabile**, create cu `.obs` sau `Rx`: `isLoading`, `errorMessage` și lista `items` cu rândurile ecranului. Când le schimb `.value`, interfața se actualizează singură.
>
> **Cum funcționează încărcarea.** Pagina face `Get.put(HomeController())` în `initState`. GetX creează controller-ul și apelează automat `onInit()`, iar acolo pornesc `load()`. Metoda `load` pune `isLoading` pe `true`, deci apare spinner-ul. Apoi face `await` pe `AppData.read()`, transformă datele cu `fromJson` și construiește lista de rânduri în `items`, la fel ca `getItems()` de la curs. Dacă apare o excepție, de exemplu JSON-ul e invalid, o prind în `catch` și pun mesajul în `errorMessage`. În `finally` opresc încărcarea. Ecranul de eroare are un buton **Retry**, care apelează din nou `load`.
>
> **Interfața.** În pagină iau controller-ul cu `Get.find` și folosesc **`Obx`**. `Obx` ascultă observabilele citite în interior și reconstruiește ecranul când se schimbă. Dacă `isLoading` e `true` arăt spinner-ul, dacă am eroare arăt `ErrorView`, altfel lista. Interfața nu conține logică, doar apelează metodele controller-ului.
>
> **Funcții noi.** Pe ecranul principal am căutare după nume, specialitate și adresă, și o fereastră de filtre: sortare după nume sau distanță, filtru de specialitate și „doar favorite”. Dacă nu sunt rezultate, apare un mesaj cu butonul **Reset filters**. Lista se recalculează mereu din datele originale, deci căutarea nu pierde medicii.
>
> **Pagina de detalii.** O deschid cu **`Get.to`** și o închid cu **`Get.back`**. Pagina își creează controller-ul cu `Get.put` și îl șterge cu `Get.delete` când se închide. În lucrarea 1 selecția orei și a datei se făcea cu `setState`. Acum controller-ul ține detaliile într-un observabil, iar la tap pe un chip pune o copie nouă cu alt index selectat. Butonul **Book an Appointment** arată un mesaj cu data și ora alese.
>
> **Testele.** Am scris 12 teste: pentru controllere (încărcare, căutare, filtre, favorite, sortare, eroare, detalii), pentru serializarea manuală și cea automată, și teste de interfață care pornesc aplicația. Toate trec cu `flutter test`.
>
> **Demonstrație.**
> 1. La pornire se vede spinner-ul, apoi datele din JSON.
> 2. Scriu un nume inexistent în căutare și apare mesajul „No doctors match your search”. Apăs **Reset filters** și medicii revin.
> 3. Deschid filtrele, aleg „Nearest” și o specialitate. Pe iconița de filtre apare un punct.
> 4. Apăs pe inimă și medicul devine favorit. Activez „Favorites only” și rămâne doar el.
> 5. Apăs pe un medic și se deschide pagina lui. Aleg ora și data, apoi apăs **Book**.
> 6. Pentru eroare, schimb temporar calea fișierului în `AppData`: apare mesajul cu **Retry**.
>
> Asta a fost lucrarea. Vă mulțumesc.

---

## Partea 6. Întrebări posibile și răspunsuri scurte

| Întrebare | Răspuns |
|---|---|
| Ce este un Future? | O valoare care va fi disponibilă mai târziu. Se termină cu un rezultat sau cu o eroare. |
| Ce face `await`? | Așteaptă Future-ul și scoate valoarea, fără să blocheze UI-ul. |
| Diferența manual / automat la serializare? | Manual: scriu eu `fromJson` / `toJson`. Automat: pun `@JsonSerializable`, iar `build_runner` generează codul în `.g.dart`. Automat e mai puțin cod și mai puține greșeli de tastare la chei. |
| Ce face `@JsonKey(name: ...)`? | Leagă un câmp de o cheie JSON cu alt nume (de exemplu `imageUrl` ↔ `avatarUrl`). |
| De ce `part 'doctor.g.dart'`? | Fișierul generat face parte din aceeași bibliotecă și poate accesa funcțiile private `_$DoctorFromJson`. |
| Ce este `.obs`? | Face o variabilă observabilă (`RxBool`, `RxList`...). La schimbarea `.value` se actualizează `Obx`. |
| Ce face `Obx`? | Reconstruiește widget-ul când se schimbă un observabil citit în el. |
| `Get.put` vs `Get.find`? | `put` creează și înregistrează controller-ul. `find` îl ia pe cel deja înregistrat. |
| Când se apelează `onInit`? | Automat, o singură dată, după `Get.put`. Aici pornim încărcarea. |
| De ce `Get.delete` la detalii? | Fiecare deschidere a paginii are alt medic. La închidere ștergem controller-ul, ca data viitoare să se creeze unul nou. |
| Unde e logica? | În controllere. Widget-urile afișează și apelează metode. |
| Ce se întâmplă dacă JSON-ul e greșit? | Se aruncă o excepție. `catch` din controller pune `errorMessage`, apare ecranul de eroare cu Retry. |
| De ce `copyWith`? | Modelele sunt imuabile. Creez un obiect nou (favorit, chip selectat) și îl pun în observabil, ca `Obx` să vadă schimbarea. |
| De ce `GetMaterialApp`? | Ca să meargă navigarea GetX (`Get.to`, `Get.back`). |
