# language: de

Funktionalität: Brotkrumennavigation

  Um mich schnell durch die Applikation bewegen zu können
  möchte ich als Ausleiher
  die möglichkeit haben schnell von A nach Z zu kommen

  Grundlage:
    Angenommen ich bin Normin

  @personas
  Szenario: Brotkrumennavigation
    Angenommen man befindet sich auf der Seite der Hauptkategorien
    Dann sehe ich die Brotkrumennavigation

  @personas
  Szenario: Home-Button der Brotkrumennavigation
    Angenommen man befindet sich auf der Seite der Hauptkategorien
    Und ich sehe die Brotkrumennavigation
    Dann beinhaltet diese immer an erster Stelle das Übersichtsbutton
    Und dieser führt mich immer zur Seite der Hauptkategorien

  @personas
  Szenario: Hauptkategorie auswählen
    Angenommen man befindet sich auf der Seite der Hauptkategorien
    Wenn ich eine Hauptkategorie wähle
    Dann öffnet diese Kategorie
    Und die Kategorie ist das zweite und letzte Element der Brotkrumennavigation

  @javascript @personas
  Szenario: Unterkategorie auswählen
    Angenommen man befindet sich auf der Seite der Hauptkategorien
    Wenn ich eine Unterkategorie wähle
    Dann öffnet diese Kategorie
    Und die Kategorie ist das zweite und letzte Element der Brotkrumennavigation

  @personas
  Szenario: Weg bis zum Modell anzeigen
    Angenommen man befindet sich auf der Seite der Hauptkategorien
    Wenn ich eine Hauptkategorie wähle
    Dann öffnet diese Kategorie
    Und die Kategorie ist das zweite und letzte Element der Brotkrumennavigation
    Wenn ich ein Modell öffne
    Dann sehe ich den ganzen Weg den ich zum Modell beschritten habe
    Und kein Element der Brotkrumennavigation ist aktiv

  @personas
  Szenario: Explorative-Suche Kategorie der ersten Stufe auswählen
    Angenommen man sich auf der Modellliste befindet
    Wenn ich eine Kategorie der ersten stufe aus der Explorativen Suche wähle
    Dann öffnet diese Kategorie
    Und die Kategorie ist das zweite und letzte Element der Brotkrumennavigation

  @personas
  Szenario: Explorative-Suche Kategorie der zweiten Stufe auswählen
    Angenommen man sich auf der Modellliste befindet
    Wenn ich eine Kategorie der zweiten stufe aus der Explorativen Suche wähle
    Dann öffnet diese Kategorie
    Und die Kategorie ist das zweite und letzte Element der Brotkrumennavigation
