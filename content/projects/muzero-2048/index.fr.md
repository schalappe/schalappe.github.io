---
title: "Stochastic MuZero pour 2048"
description: "Un agent d'apprentissage par renforcement pour 2048, qui planifie avec un modèle appris et une recherche arborescente sur le hasard, en JAX."
weight: 3
year: 2026
repo: "https://github.com/schalappe/simulate_2048"
stack: ["JAX", "Flax", "Optax", "mctx", "NumPy"]
demo_caption: "Enregistrement d'un agent antérieur, de 2023, avant la réécriture MuZero."
---

## Problème

2048 paraît simple, mais chaque coup mêle décision et hasard : le joueur fait glisser les tuiles, puis un 2 ou un 4 apparaît sur une case vide. Un agent qui planifie doit tenir compte des deux. Le jeu m'a servi de terrain d'essai rapide pour la planification en environnement incertain, par étapes : agents DQN et acteur-critique en 2022, recherche arborescente Monte-Carlo maison avec nœuds de hasard en 2024, puis réécriture en Stochastic MuZero avec JAX en 2026.

## Approche

La version actuelle suit l'article « Planning in Stochastic Environments with a Learned Model » (Antonoglou et al., ICLR 2022). Pendant la recherche, l'agent ne consulte jamais les règles du jeu. Il apprend six fonctions :

- représentation : du plateau à un état caché ;
- prédiction : de l'état caché à une politique et une valeur ;
- dynamique d'après-état : de l'état et de l'action à l'état après le glissement, avant la nouvelle tuile ;
- prédiction d'après-état : de l'après-état à une valeur Q et une distribution sur 32 codes de hasard ;
- dynamique : de l'après-état et du code de hasard à l'état suivant et à la récompense ;
- encodeur : de l'observation à un code de hasard discret.

La recherche effectue 100 simulations par coup avec `mctx.stochastic_muzero_policy` (DeepMind). L'entraînement déroule le modèle sur 5 pas, sur des trajectoires tirées d'un tampon de rejeu priorisé, avec des cibles de valeur sur n pas.

## Ce que j'ai construit

- Un moteur 2048 en NumPy et une version vectorisée en JAX qui sépare chaque coup en un glissement déterministe (`latent_state`) et l'apparition aléatoire d'une tuile (`after_state`).
- Les six réseaux en Flax, sous forme de MLP résiduels.
- Le pont entre ces réseaux et `mctx`.
- L'auto-jeu en parallèle, un tampon de rejeu priorisé avec préchargement, des pertes compilées avec JIT et des points de sauvegarde Orbax.
- Des configurations de `tiny` aux réglages de l'article, un notebook Kaggle pour GPU ou TPU, et un script d'évaluation.
- Environ 70 tests unitaires sur la logique du plateau, l'environnement et le jeu en JAX.

## Résultats

Le dépôt ne publie pas encore d'agent entraîné ni de score. Le script d'évaluation calcule la récompense moyenne, la tuile maximale et la répartition des tuiles, mais aucune exécution n'y est enregistrée. Aujourd'hui, les tests couvrent le moteur de jeu, et le dépôt contient la chaîne d'entraînement complète, de l'auto-jeu aux sauvegardes.

## Limites et pistes

Dans la perte, la cible du code de hasard est provisoire : elle désigne toujours le code 0 au lieu d'encoder l'observation suivante. Tant que je ne l'ai pas corrigée, le modèle n'apprend pas la partie aléatoire du jeu. L'option `--checkpoint` de l'évaluation n'est pas implémentée : elle évalue un réseau non entraîné.

Ensuite, je brancherai l'encodeur dans la perte et je chargerai les sauvegardes dans l'évaluation. Puis je lancerai un long entraînement sur Kaggle et publierai les courbes d'apprentissage et la répartition des tuiles.
