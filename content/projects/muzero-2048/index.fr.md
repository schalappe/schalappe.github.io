---
title: "Stochastic MuZero pour 2048"
description: "Un agent d’apprentissage par renforcement pour 2048, qui planifie avec un modèle appris et une recherche arborescente sur le hasard, en JAX."
weight: 2
year: 2026
repo: "https://github.com/schalappe/simulate_2048"
stack: ["JAX", "Flax", "Optax", "mctx", "NumPy", "RunPod"]
result: "Tuile 2048 atteinte dans 2 parties sur 16 après 6,8 h sur un GPU (environ 4 $) ; score moyen de 13 446 contre 2 616 sans entraînement"
demo_caption: "Enregistrement d’un agent antérieur, de 2023, avant la réécriture MuZero. Le modèle de 2026 n’a pas été conservé après son entraînement."
---

## Problème

2048 paraît simple, mais chaque coup mêle décision et hasard : le joueur fait glisser les tuiles, puis un 2 ou un 4 apparaît sur une case vide. Un agent qui planifie doit tenir compte des deux. Le jeu m'a servi de terrain d'essai rapide pour la planification en environnement incertain, par étapes : agents DQN et acteur-critique en 2022, recherche arborescente Monte-Carlo maison avec nœuds de hasard en 2024, puis réécriture en Stochastic MuZero avec JAX en 2026.

## Approche

La version actuelle suit l'article [« Planning in Stochastic Environments with a Learned Model »](https://openreview.net/forum?id=X6D9bAHhBQ1) (Antonoglou et al., ICLR 2022), jusqu'à ses réglages pour 2048 (annexe C). Pendant la recherche, l'agent ne consulte jamais les règles du jeu. Il apprend six fonctions :

- représentation : du plateau à un état caché ;
- prédiction : de l'état caché à une politique et une valeur ;
- dynamique d'après-état : de l'état et de l'action à l'état après le glissement, avant la nouvelle tuile ;
- prédiction d'après-état : de l'après-état à une valeur et une distribution sur 32 codes de hasard ;
- dynamique : de l'après-état et du code de hasard à l'état suivant et à la récompense ;
- encodeur : de deux observations successives au code de hasard discret de la transition réelle, appris sans étiquette.

Chaque tuile est codée sur 31 bits, valeurs et récompenses sont prédites comme des distributions sur 601 classes, et les cibles de valeur sont des retours TD(λ) calculés sur les vraies récompenses. La recherche utilise `mctx.stochastic_muzero_policy` (DeepMind) en masquant les coups illégaux. L'entraînement déroule le modèle sur 5 pas, sur des séquences tirées d'un tampon de rejeu priorisé.

## Ce que j'ai construit

- Un moteur 2048 en NumPy et une version vectorisée en JAX qui sépare chaque coup en un glissement déterministe et l'apparition aléatoire d'une tuile.
- Les six réseaux en Flax, sous forme de MLP résiduels, et le pont entre ces réseaux et `mctx`.
- L'auto-jeu compilé en un seul programme JAX sur le GPU : des centaines de parties, la recherche et le choix des coups tournent dans un même `lax.scan`.
- Un tampon de rejeu priorisé qui stocke chaque plateau sur 16 octets au lieu de l'observation complète (sinon, le tampon de l'article occuperait environ 50 Go).
- Des entraînements qui reprennent après un arrêt : un dossier d'exécution garde les points de sauvegarde, l'état de l'optimiseur, le tampon de rejeu et les métriques, et un pod GPU redémarré repart là où il s'était arrêté.
- Des configurations de `tiny` (test rapide sur CPU) aux réglages de l'article, une configuration `budget` qui s'arrête à une tuile cible ou à une limite de temps, et un script RunPod qui conserve le budget de temps entre les redémarrages et arrête le pod à la fin.
- 86 tests unitaires, exécutés sur CPU et sur une NVIDIA A40.

Une première version de la boucle d'entraînement tournait sans pouvoir apprendre ce qu'elle prétendait : le code de hasard était constant, les cibles de valeur venaient des propres valeurs de la recherche, et les parties s'arrêtaient à 200 coups. J'ai réécrit les pertes et les cibles pour suivre l'article avant de dépenser la moindre heure de GPU.

## Résultats

La configuration `budget` entraîne un modèle plus petit que celui de l'article (128 unités, 4 blocs résiduels, 50 simulations par coup, profondeur de recherche limitée à 10). Sur une A40, l'entraînement s'est arrêté sur la tuile cible au pas 75 000, après 6,8 heures, pour environ 4 $ de GPU. Chaque évaluation joue 16 parties sans exploration.

| Évaluation | Score moyen | Meilleure tuile | Parties à 2048 | Longueur moyenne |
|---|---|---|---|---|
| Réseau non entraîné + recherche | 2 616 | 512 | 0/16 | 221 |
| Pas 20 000 | 5 712 | 512 | 0/16 | 416 |
| Pas 40 000 | 7 714 | 1024 | 0/16 | 520 |
| Pas 65 000 | 10 624 | 1024 | 0/16 | 675 |
| Pas 75 000 | 13 446 | 2048 | 2/16 | 804 |

La référence non entraînée compte : la recherche seule joue déjà mieux que le hasard, donc le gain se mesure en comparant le modèle entraîné à cette référence, avec la même recherche. Le profilage montre que l'auto-jeu occupe environ 95 % de la boucle, et ralentit de 2,5 à 3 fois à mesure que l'entraînement affine la distribution du hasard et approfondit l'arbre de recherche.

## Limites et pistes

Cet entraînement prouve que le modèle apprend à atteindre 2048, pas qu'il égale l'article. L'article entraîne 20 millions de pas sur des TPU ; au rythme mesuré de 0,44 pas par seconde pour le modèle complet sur une A40, il faudrait environ 526 jours et 7 450 $. Deux parties sur seize forment un petit échantillon, et le modèle entraîné a été supprimé avec le pod : on ne peut plus l'évaluer. Le prochain entraînement devra garder ses points de sauvegarde et s'évaluer sur plus de parties.
