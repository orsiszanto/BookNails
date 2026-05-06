// filepath: docs/AI_PROMPT_LOG.md

## AI tudatosság (15 pont)

Ez a szekció összefoglalja a projektben végzett jelentős AI-interakciókat, a döntési pontokat és azokat az eseteket, amikor az AI javaslatát módosítani vagy elutasítani kellett. A cél az, hogy látszódjon: a generált ötleteket nem vakon követtük, hanem ellenőriztük, finomítottuk és a projekt követelményeihez igazítottuk.

### 1) Prompt napló – jelentős AI-interakciók

| # | Prompt / cél | AI válasz rövid összefoglaló | Projektbeli eredmény |
|---|---|---|---|
| 1 | Routing és navigáció megtervezése a fő képernyők között | Javasolt GoRouter-alapú route struktúrát, külön login/registration/home/services/booking útvonalakkal. | A navigáció stabil alapot kapott, külön route-okkal és név szerinti hívásokkal. |
| 2 | Regisztrációs képernyő létrehozása | Elkészítette a regisztrációs UI mezőit, a jelszó megerősítést és a login oldalra visszalépő linket. | Létrejött a `RegistrationScreen`, ami illeszkedik a belépési folyamatba. |
| 3 | Home screen tartalmának bővítése | Ötletet adott hero szekcióra, információs kártyákra és egy szolgáltatások gombra. | A home oldal informatívabb lett, és közvetlen belépési pontot kapott a szolgáltatáslistához. |
| 4 | Szolgáltatáslista grid elrendezésének kialakítása | Vertikális kártyastruktúrát és 2 oszlopos gridet javasolt, figyelve a kis képernyőkre is. | Elkészült a `ServiceGridCard` és a grid layout, amely jobban használja ki a helyet. |
| 5 | Overflow hibák megszüntetése a grid kártyákban | Padding-, betűméret- és `childAspectRatio`-módosításokat ajánlott az overflow kezelésére. | A szolgáltatáskártyák stabilabban jelennek meg kisebb kijelzőkön is. |
| 6 | Keresés és rendezés hozzáadása a szolgáltatáslistához | Keresőmező és név/ár szerinti rendezés beépítését javasolta. | A lista használhatóbb lett, a felhasználó gyorsabban talál szolgáltatást. |
| 7 | Akadálymentességi javítások | `semanticsLabel`, jobb heading-struktúra és kontraszt-ellenőrzés beépítését javasolta. | Az UI olvashatóbb és képernyőolvasóval is használhatóbb lett. |
| 8 | Firestore adatmodell dokumentálása | Kérte a kollekciók és kapcsolatok világos leírását a dokumentációban. | A `DATAMODEL.md` pontosabban tükrözi a users/services/categories/appointments struktúrát. |
| 9 | Hibaoldal és route error handling | Javasolt egy `ErrorScreen` és egy `errorBuilder` beállítást az ismeretlen útvonalakhoz. | Az invalid URL-ek kezelése rendezett lett, és a felhasználó vissza tud térni a főoldalra. |
| 10 | Pontszámítás és megfelelés értékelése | Összegző értékelést adott az implementációról és a dokumentációról. | Segített azonosítani, hol vannak még hiányok a követelményekhez képest. |

### 2) Döntéshozatal – elfogadás / módosítás / elutasítás

| Döntés | Mi történt? | Indoklás | Hatás |
|---|---|---|---|
| Elfogadás | A GoRouter-alapú route struktúra megmaradt. | Átlátható, névvel hívható és jól bővíthető megoldás volt. | Stabilabb navigáció és tisztább oldaláramlás jött létre. |
| Módosítás | A szolgáltatáskártyák eredeti layoutját finomítani kellett. | Az első verzió túl szoros volt, kisebb kijelzőn overflow veszélyt hordozott. | Kisebb betűméret, jobb padding és megfelelőbb aspect ratio került be. |
| Elfogadás | A keresés és rendezés funkció bekerült a listaoldalra. | Ezek valódi felhasználói értéket adnak, és jól illeszkednek a mock adatokhoz. | Javult a használhatóság, nőtt az oldal interaktivitása. |
| Módosítás | Az AI által javasolt UI szövegek és címek több helyen át lettek írva. | A projekt hangneméhez és a magyar nyelvű felülethez kellett igazítani őket. | Egységesebb, természetesebb felhasználói szövegek születtek. |
| Elfogadás | Az akadálymentesítési javítások bekerültek. | Kevés kóddal sokat javítottak a minőségen és az értékelhetőségen. | Erősödött az elérhetőség, és dokumentálható lett a tudatos fejlesztés. |

### 3) Kritikai szemlélet – AI tévedések és javításuk

| Eset | Mi volt a hiba? | Hogyan javítottuk? |
|---|---|---|
| 1 | Az AI kezdetben túl nagy kártyaméretet / túl optimista layoutot javasolt a szolgáltatás gridhez. | A layoutot visszafogtuk: kisebb padding, megfelelő `childAspectRatio`, kisebb betűk és min-size beállítások kerültek be. |
| 2 | Az AI által generált szövegek és címkék néhány helyen nem voltak teljesen egységesek vagy elég természetesek magyarul. | Nyelvileg és UX szempontból átszerkesztettük őket, hogy a felület következetesebb legyen. |

### 4) Kritikus gondolkodás – mit ellenőriztünk le?

- A generált route-neveket és navigációs hívásokat összevetettük a tényleges képernyőkkel.
- A grid layoutot képernyőszélességre érzékenyen finomítottuk, hogy ne csak elméletben működjön.
- A dokumentációt a tényleges fájlstruktúrához igazítottuk (`DATAMODEL.md`, `ErrorScreen`, `go_router`).
- Az accessibility módosításoknál nem csak a kódot, hanem a felhasználói élményt is figyelembe vettük.

