---
title: "Tatouage d'images par apprentissage profond"
description: "Implémentation TensorFlow d'un article sur le tatouage d'images par CNN : deux réseaux entraînés face à dix attaques, réglés avec Optuna."
weight: 4
year: 2023
repo: "https://github.com/schalappe/watermark_resolution"
stack: ["TensorFlow", "Keras", "Optuna", "imgaug"]
---

## Problème

Un tatouage numérique cache la marque d'un propriétaire dans une image. Il doit rester invisible et résister aux retouches courantes : compression, flou, bruit, recadrage ou rotation. Un schéma aveugle doit aussi retrouver la marque sans l'image d'origine. J'ai implémenté l'article « Convolutional Neural Network-Based Digital Image Watermarking Adaptive to the Resolution of Image and Watermark » (Lee, Seo et Kim, Applied Sciences, 2020), en me concentrant sur les réglages d'entraînement.

## Approche

La méthode repose sur deux réseaux entraînés ensemble :

- un réseau d'insertion reçoit une image de 128×128 et une marque binaire de 8×8. Il passe l'image en YCbCr, agrandit la marque avec quatre blocs de convolutions transposées, la fusionne avec les caractéristiques de la luminance, puis reconstruit l'image RGB ;
- un réseau d'extraction lit la luminance d'une image éventuellement attaquée et prédit la marque.

Entre les deux, chaque lot subit une attaque tirée au hasard. La perte d'insertion équilibre fidélité de l'image (MSE) et récupération de la marque (MAE) ; la perte d'extraction ne mesure que la seconde. Les auteurs utilisaient le jeu BOSS ; j'ai pris deux jeux publics en niveaux de gris sur Hugging Face, 10 000 images pour l'entraînement et 6 000 pour le test.

## Ce que j'ai construit

- Des couches Keras sur mesure pour la conversion de couleurs, la séparation luminance/chrominance et le brouillage de la marque par la transformation du chat d'Arnold.
- Un `WatermarkModel` avec son propre `train_step` : un seul `GradientTape`, deux pertes et deux optimiseurs Adam.
- Dix attaques construites avec imgaug et TensorFlow : recadrage, dropout, rotation, poivre et sel, flou médian, moyen et gaussien, qualité JPEG, bruit gaussien, et aucune attaque.
- Les métriques PSNR et taux d'erreur binaire (BER).
- Une recherche Optuna en deux temps : d'abord les taux d'apprentissage, la taille de lot et le nombre d'époques, puis les poids des pertes. Les valeurs retenues sont dans `models/best_params.json`.

## Résultats

L'évaluation de `notebooks/0.1-result_learn.ipynb` donne un PSNR de 18,0 dB pour les images tatouées, soit une altération visible, et un BER autour de 50 % pour toutes les attaques. Ce BER est calculé sur la sortie brute, sans seuillage (voir plus bas) : il ne permet pas de dire si l'extracteur a appris la marque. La capacité de récupération reste à vérifier une fois la métrique corrigée et l'évaluation relancée.

Le projet fournit en revanche une chaîne complète et reproductible : données, augmentation, entraînement conjoint, recherche d'hyperparamètres et évaluation par attaque.

## Limites et pistes

Avant de relancer l'entraînement, il faut corriger l'évaluation. Le BER compare la sortie brute de l'extracteur à la marque binaire sans seuillage : la métrique ne reflète donc pas une prédiction arrondie. Le brouillage est aussi incomplet : `extract_stack` ignore le résultat de la transformation d'Arnold inverse.

Ensuite, je seuillerais la prédiction dans le BER, je vérifierais que l'extracteur retrouve la marque sans attaque, puis j'ajouterais les attaques progressivement et comparerais PSNR et BER aux valeurs publiées dans l'article.
