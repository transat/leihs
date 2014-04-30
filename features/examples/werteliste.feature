# language: de

Funktionalität: Werteliste

  Um eine konforme Werteliste aushändigen zu können
  möchte ich als Verleiher
  das mir das System für eine Auswahl eine Werteliste zur verfügung stellen kann

  Grundlage:
    Angenommen ich bin Pius

  @javascript
  Szenario: Was ich auf der Werteliste sehen möchte
    Angenommen man öffnet eine Werteliste
    Dann möchte ich die folgenden Bereiche in der Werteliste sehen:
    | Bereich          |
    | Datum            |
    | Titel            |
    | Ausleihender     |
    | Verleier         |
    | Liste            |

  @javascript
  Szenario: Der Inhalt der Werte-Liste
    Angenommen man öffnet eine Werteliste
    Dann beinhaltet die Werte-Liste folgende Spalten:
    | Spaltenname     |
    | Laufende Nummer |
    | Inventarcode    |
    | Modellname      |
    | End Datum       |
    | Anzahl          |
    | Wert            |
    Und die Modelle in der Werteliste sind alphabetisch sortiert

  @javascript
  Szenario: Werteliste auf Bestellübersicht ausdrucken
    Angenommen es existiert eine Bestellung mit mindestens zwei Modellen, wo die Bestellmenge mindestens drei pro Modell ist
    Wenn ich eine Bestellung öffne
    Und ich mehrere Linien von der Bestellung auswähle
    Und das Werteverzeichniss öffne
    Dann sehe ich das Werteverzeichniss für die ausgewählten Linien
    Und die nicht zugewiesenen Linien sind zusammengefasst
    Und für die nicht zugewiesenen Linien ist der Preis der höchste Preis eines Gegenstandes eines Models innerhalb des Geräteparks

  @javascript
  Szenario: Werteliste auf der Aushändigungsansicht ausdrucken
    Angenommen es existiert eine Aushändigung mit mindestens zwei Modellen und einer Option, wo die Bestellmenge mindestens drei pro Modell ist
    Und es ist pro Modell genau einer Linie ein Gegenstand zugewiesen
    Wenn ich die Aushändigung öffne
    Und ich mehrere Linien von der Aushändigung auswähle
    Und das Werteverzeichniss öffne
    Dann sehe ich das Werteverzeichniss für die ausgewählten Linien
    Und für die nicht zugewiesenen Linien ist der Preis der höchste Preis eines Gegenstandes eines Models innerhalb des Geräteparks
    Und für die zugewiesenen Linien ist der Preis der des Gegenstandes
    Und die nicht zugewiesenen Linien sind zusammengefasst
    Und der Preis einer Option ist der innerhalb des Geräteparks

  @javascript
  Szenario: Totale Werte
    Angenommen man öffnet eine Werteliste
    Dann gibt es eine Zeile für die totalen Werte
     Und diese summierte die Spalten:
     | Spaltenname |
     | Anzahl      |
     | Wert        |

  @javascript
  Szenario: Totale Werte
    Angenommen man öffnet eine Werteliste
    Dann gibt es eine Zeile für die totalen Werte
     Und diese summierte die Spalten:
     | Spaltenname |
     | Anzahl      |
     | Wert        |
