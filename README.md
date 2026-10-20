# KI zum Lernen — Kurz-Workshops für Studierende aller Semester

Begleitseite zu vier 30-Minuten-Workshops am Campus Gummersbach, WiSe 2026/27
(mittwochs 21.10., 28.10., 04.11., 11.11., 12:30–13:00 Uhr, Hörsaal 0402; Inputs: R. Bartnik und U. van Heesch, Tutor: B. Moser).

Pages: <https://th-koln-bartnik.github.io/ki-zum-lernen/>

## Bauen und veröffentlichen

```bash
quarto preview                     # Live-Vorschau
quarto render                      # Studierendenfassung nach docs/
quarto render --profile dozent     # Dozentenfassung nach ../ki-zum-lernen-dozent/ (außerhalb des Repos)
```

GitHub Pages serviert aus `/docs` auf `main`. Nach jedem `quarto render` committen und pushen.

## Struktur

- `index.qmd` — Startseite mit Terminen und Werkzeugen
- `parts/` — eine Seite pro Workshop. Aufbau: Theorie-Input (`## Theorie-Input — … {#sec-theorie}`: ein Absatz von 120–150 Wörtern mit zwei bis vier Studien aus `references.bib`, eine Grafik als Include in `includes/`, ein Merksatz als `::: merksatz`), danach Block 1 und Block 2 mit je einer Anwendungsübung
- `prompts/` — jeder Prompt genau einmal als `_name.qmd`; eingebunden per
  `{{< include ../prompts/_name.qmd >}}` auf der Workshop-Seite **und** in der Prompt-Bibliothek
- `appendix/` — Prompt-Bibliothek, Wissensbasis, Troubleshooting
- `material/` — Übungsdateien zum Download (Stoffkatalog, Muster-.ics)
- `_variables.yml` — zentrale Platzhalter (Toolname, Raum, Zeit, Semesterdaten), Aufruf `{{< var thki >}}`
- `_quarto-dozent.yml` — Profil für die Dozentenfassung; Blöcke mit
  `::: {.content-visible when-profile="dozent"}` erscheinen nur dort

## Lizenz

Texte: CC BY-NC-SA 4.0. Das 4D-Framework folgt Dakan & Feller (2025), CC BY-NC-ND 4.0.
