---
title: "Recherche d'images par le contenu"
description: "Comparaison de cinq extracteurs de caractéristiques et trois mesures de distance pour retrouver des vêtements similaires, évaluée par MAP et MRR."
weight: 1
year: 2023
repo: "https://github.com/schalappe/content-based-image-retrieval"
stack: ["TensorFlow", "OpenCV", "scikit-learn", "Polars", "seaborn"]
---

## Problème

La recherche d'images par le contenu retrouve des images similaires à partir de leurs pixels, sans mots-clés ni légendes. Elle repose sur deux choix : comment transformer une image en vecteur, et comment comparer deux vecteurs. Je voulais mesurer quelle combinaison donne les résultats les plus pertinents sur un vrai catalogue, et à quel coût en temps de requête.

## Approche

J'ai croisé cinq extracteurs de caractéristiques avec trois mesures de similarité, soit 15 combinaisons :

- des descripteurs locaux d'OpenCV : AKAZE et ORB ;
- des CNN pré-entraînés sur ImageNet, dont j'utilise l'avant-dernière couche comme vecteur : VGG16, NASNetLarge et EfficientNetB7 ;
- la similarité cosinus, la distance euclidienne et la distance de Manhattan.

Les données viennent du jeu Apparel Images de Kaggle, où chaque dossier indique une couleur et un style (par exemple « robe noire »). Après un découpage stratifié, 10 833 images forment la base et les 5 337 autres sont les requêtes. Pour chaque requête, le système renvoie les 5 images les plus proches. J'ai noté les résultats sur la couleur, le style, puis les deux, avec la précision moyenne (MAP), le rang réciproque moyen (MRR), la justesse au premier rang et le temps médian par requête.

## Ce que j'ai construit

- Des classes `Descriptor` qui gardent les 32 points clés les plus forts et complètent par des zéros pour obtenir un vecteur de taille fixe.
- Des classes `Compressor` qui encapsulent les trois modèles Keras avec leur taille d'entrée et leur prétraitement.
- Un `Finder` par distance, chronométré à chaque requête.
- Des scripts, pilotés par un `Makefile`, pour télécharger les données, extraire les caractéristiques en Parquet et lancer les 15 évaluations.
- Les fonctions de métriques, testées.

## Résultats

Les tableaux complets sont dans `reports/1.0-evaluation.pdf`. Sur la tâche la plus difficile, retrouver la couleur et le style :

- EfficientNetB7 avec la distance euclidienne arrive en tête : MAP de 0,73, MRR de 0,77, justesse au premier rang de 0,67.
- VGG16 avec la distance euclidienne suit de près, avec une MAP de 0,72.
- Le meilleur descripteur local, ORB avec la distance de Manhattan, atteint une MAP de 0,20.
- Sur le style seul, les trois CNN obtiennent une MAP comprise entre 0,93 et 0,96.

Les descripteurs sont plus rapides (environ 0,02 à 0,03 s par requête en médiane, contre 0,10 s pour VGG16 et 0,23 s pour EfficientNetB7), mais bien moins précis. AKAZE n'a extrait aucune caractéristique pour 24 images de la base.

## Limites et pistes

Les résultats en cosinus ne sont pas exploitables. Mon `CosinusFinder` trie les similarités par ordre croissant, comme des distances : il renvoie d'abord les images les moins similaires. Les scores proches de zéro viennent de ce bug, pas de la mesure. Corriger le tri et relancer l'évaluation est la première chose à faire.

Le temps de requête inclut l'extraction et un parcours exhaustif de la base. Un vrai système précalculerait les vecteurs et utiliserait un index de plus proches voisins approché. J'essaierais aussi d'affiner un modèle sur le catalogue plutôt que de garder des caractéristiques ImageNet figées.
