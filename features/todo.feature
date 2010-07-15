Feature: Wishes and Bug Reports by our Users

Background: noting down all that is reported at our round table

Scenario: Only automatically check items and options for hand over that have a time period starting today
	Given pending - reported by Pius on 22.June 2010

Scenario: When opening a contract for hand over user the first available time period
	Given pending - reported by Pius on 22.June 2010

Scenario: Highlight selected mode in UI (Hand over, Acknowledge etc.)
	Given pending - reported by Pius on 22.June 2010

Scenario: Verträge -> User -> Werteverzeichnis ausdrucken -> Seriennummer reinnehmen
	Given pending - reported by Claudio on 22.June 2010

Scenario: Optionen -> sollten Wert haben
	Given pending - reported by Claudio on 22.June 2010

Scenario: Genelec -> Paket -> Anzeige -> Greybox in Greybox
	Given pending - reported by Claudio on 22.June 2010

Scenario: externen Benutzer erstellen (hat weder Badge noch Passwort) (Pwd sollte nicht sichtbar sein, da wir nicht DB auth machen)
	Given pending - reported by Claudio on 22.June 2010

Scenario: Wenn Datum in der Zukunft, dann sollte Datum schon in der Handover Greybox angepasst sein und nicht erst im PDF
	Given pending - reported by all(C+P) on 22.June 2010

Scenario: Wenn Item nicht verfügbar irgendwann dazwischen (zwischen anfang und end-datum), dann sollte dies markiert werden in der Handover Greybox
	Given pending - reported by all(C+P) on 22.June 2010

Scenario: Produce an audible beep when items are scanned, either a good beep or a bad beep depending on whether the scanned item could be added succsessfully
  Given pending - reported by Claudio on 24.June 2010 via e-mail

Scenario: Display order history and add (if not already present): Who placed the reservation? Who Acknowledged the reservation?
  Given pending - reported by Tilo on 29.June 2010

Scenario: Add to item history: Who added this item to the inventory?
  Given pending - reported by Tilo on 29.June 2010

Scenario: Bei Paket Liste sollen Status, Stufe, Ort und 'an Lager' angezeigt werden
  Given pending - reported by Claudio on 6.July 2010

Scenario: Wenn Status, Stufe, Ort und 'an Lager' eines Pakets ändern, dann müssen die entsprechenden Eigenschaften aller Gegenstände ändern
  Given pending - reported by Claudio,Mike on 6.July 2010

Scenario: i.e. wenn Location ID, Inventory Pool eines Pakets ändern, dann müssen die entsprechenden Eigenschaften aller Gegenstände ändern
  Given pending - reported by Claudio,Mike on 6.July 2010

Scenario: wenn Gegenstand einem Paket hinzugefügt wird, dann nimmt es seine Eigenschaftern Location und Inventory Pool an
  Given pending - reported by Claudio,Mike on 6.July 2010

Scenario: wenn Gegenstand zu einem anderen Paket wechselt, dann nimmt es die Eigenschaftern Location und Inventory Pool des neuen Pakets an
  Given pending - reported by Claudio,Mike on 6.July 2010

Scenario: bei Gegenständen, welche Teil eines Pakets sind, statt Status "is Teil eines Pakets" anzeigen
  Given pending - reported by Claudio,Mike on 6.July 2010


Scenario: Verschiedene Modelle sollten im Frontend vergleichbar sein.
  Given pending - reported by Marcello via Claudio on 6.July 2010

Scenario: Wenn eine neue Gruppe hinzugefügt wird, dann muss sie in der Liste der Gruppen erscheinen
  Given pending - reported by tpo on 6.July 2010

Scenario: Add fields for "mobile phone number" and "alternative e-mail address" to user model
  Given pending - reported by Claudio on 14.July 2010

Scenario: Make it impossible for users to place reservations unless either phone number or mobile number as well as address and alternative e-mail fields are filled in
  Given pending - reported by Claudio on 14.July 2010

# The following scenarios are extracted from Trac tickets that we
# created at earlier round tables.

Scenario: Allow saving sets of property keys under a name instead of just grouping properties namelessly.
  Given pending - reported by Claudio on 22.10.2009

Scenario: Send reminder e-mails also to alternative e-mail addresses, if the user has entered one. Need to add the "alternative e-mail" field for users anyway, see other todo.
  Given pending - reported by Claudio on 4.1.2010

Scenario: Allow level 3 managers to change the model of an existing item.
  Given pending - reported by Mike on 27.8.2009

Scenario: Make more columns sortable in the backend list views. Ask Claudio which ones.
  Given pending - reported by Claudio before the dawn of time

Scenario: Implement a maximum allowable lending time for models so that they can not be reserved for a longer time frame by users, and that inventory managers simply get a warning when they make longer reservations.
  Given pending - reported by Claudio an aeon ago

Scenario: Track missing parts of packages on package return.
  Given pending - reported by Claudio (?) long ago

Scenario: Allow duplicating an old order in the frontend as well as the backend, so that the models and quantities you ordered previously can be ordered again.
  Given pending - reported by Claudio long ago

Scenario: Backend: Highlight reservations whose start date is the same as another reservations' end date.
  Given pending - reported by Claudio when dinosaurs still reigned

Scenario: Display a warning when handing over items that are incomplete.
  Given pending - reported by Claudio during the last ice age

Scenario: Allow attaching any kind of binary file to a model, not just images.
  Given pending - reported by Mike ages ago, repeated 14.07.2010

Scenario: Maintenance periods for items. Ask rca for details, also see Trac ticket 72 (it's closed now because it's mentioned in this file instead)
  Given pending - reported by Claudio when lizards were still fish

