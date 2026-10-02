---
# Gabarit d'ADR (Architecture Decision Record) du lab. Copier dans docs/adr/NNNN-<slug>.md (décisions du workbook)
# ou dans journal/ (ADR d'exercice). Une décision par fichier, jamais modifiée après acceptation : une nouvelle décision la remplace.
titre: "NNNN — <Décision en une phrase à l'indicatif>"
numero: "NNNN"
date: "AAAA-MM-JJ"
statut: "<proposé | accepté | remplacé par NNNN | retiré>"
decideurs: ["<qui tranche>"]
chapitre: "<fiches/<domaine>/<fiche>.md ou scenarios/<NN>/README.md qui a produit cet ADR, sinon —>"
---

# NNNN — <Décision en une phrase>

## Contexte

<Cinq lignes au plus : la situation, la contrainte qui force à décider, ce qui existe déjà sur le lab. Chiffres si possible.>

## Options considérées

| Option | Pour | Contre | Coût (temps, vCPU / Go, licence) |
|---|---|---|---|
| A — <nom> | <…> | <…> | <…> |
| B — <nom> | <…> | <…> | <…> |

## Décision

<L'option retenue et la raison principale, en deux phrases. Ce qui est explicitement hors périmètre.>

## Objectifs mesurables

- <verbe + résultat observable + seuil + échéance, ex. « un nouvel environnement est créé en moins de 15 min d'ici la fin du bloc »>
- <…>
- <…>

## Conséquences

- Positives : <…>
- Négatives / dette acceptée : <…>
- À revoir le : <date ou événement déclencheur>

## Grille de relecture (à cocher avant « accepté »)

- [ ] le contexte tient en cinq lignes et cite une contrainte réelle
- [ ] au moins deux options comparées avec leur coût
- [ ] la décision est une phrase, pas un paragraphe
- [ ] trois objectifs mesurables avec seuil et échéance
- [ ] le périmètre refusé est écrit
