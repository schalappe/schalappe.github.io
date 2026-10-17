---
title: "Agents de résolution de labyrinthes sur MiniGrid"
description: "PPO avec exploration par curiosité et Rainbow DQN, entraînés à partir d'images pour traverser des labyrinthes de difficulté croissante."
weight: 2
year: 2025
repo: "https://github.com/schalappe/reinforce_minigrid"
stack: ["TensorFlow", "Keras", "TensorFlow Probability", "MiniGrid", "Gymnasium", "Pydantic"]
demo_caption: "Enregistrement de la première version du projet (2023), sur l'environnement MiniGrid KeyCorridor."
---

## Problème

Un agent est placé dans une grille de pièces reliées par des portes et doit atteindre une balle verte. Il ne voit qu'une petite fenêtre devant lui, sous forme d'image, et la récompense n'arrive qu'à la toute fin. Avec des récompenses rares et une vue partielle, un agent classique peut errer longtemps sans rien apprendre. Je voulais voir quelle combinaison d'algorithme, d'exploration et de façonnage de la récompense le mène au but. Une première version acteur-critique date de 2023 ; j'ai reconstruit le projet en 2025.

## Approche

J'ai construit quatre environnements MiniGrid sur mesure qui forment un curriculum :

- `BaseMaze` : 2×2 pièces, portes ouvertes ;
- `EasyMaze` : 2×2 pièces, portes fermées ;
- `MediumMaze` : 3×3 pièces, portes fermées ;
- `HardMaze` : 3×3 pièces avec 4 objets distracteurs.

L'entraînement passe au niveau suivant quand la récompense moyenne dépasse un seuil, ou après un nombre de pas fixé. Les observations sont des images RGB de 56×56 représentant la vue partielle de l'agent. La récompense façonnée donne +10 pour l'objectif, un petit bonus quand l'agent se rapproche et quand il découvre une nouvelle pièce ou case, et des pénalités pour chaque collision avec un mur et pour chaque pas.

## Ce que j'ai construit

J'ai écrit deux agents qui partagent une interface `BaseAgent` et une fabrique :

- PPO avec un CNN résiduel de type IMPALA, GAE sur 8 environnements parallèles, Random Network Distillation (RND) comme bonus de curiosité, et une exploration hybride : ε-greedy décroissant, comptages UCB sur les actions et coefficient d'entropie qui s'ajuste vers une cible.
- Rainbow DQN avec ses six composantes : têtes duel, double Q-learning, rejeu priorisé, retours sur 3 pas, couches bruitées et distribution catégorielle de la valeur sur 51 atomes.

J'ai aussi ajouté une configuration YAML validée par Pydantic et modifiable en ligne de commande, un notebook Kaggle pour l'entraînement sur GPU, un script qui génère un GIF d'un agent entraîné, et un contrôle au clavier pour parcourir les labyrinthes à la main.

## Résultats

Le dépôt ne conserve aucune trace d'entraînement : ni courbes d'apprentissage, ni taux de réussite, ni modèles sauvegardés. Le script de visualisation peut tout de même charger un point de sauvegarde et produire un GIF d'un épisode d'évaluation. En l'état, le dépôt ne me permet pas d'annoncer un taux de réussite sur le labyrinthe difficile.

## Limites et pistes

Rainbow DQN ne s'entraîne que sur `BaseMaze` : seul PPO suit le curriculum. Les tests ne couvrent que le tampon de rejeu priorisé. Le façonnage de la récompense est réglé à la main, si bien qu'un bon score reflète en partie mes bonus plutôt que la seule réussite de la tâche.

Ensuite, je suivrais le taux de réussite et la longueur des épisodes par niveau, je publierais les courbes des deux agents, je ferais passer DQN par le même curriculum et je comparerais récompense façonnée et récompense rare pour mesurer l'apport du façonnage.
