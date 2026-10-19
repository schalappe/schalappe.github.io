---
title: "Tatouage d’images par apprentissage profond"
description: "Reproduction PyTorch d’un article sur le tatouage d’images par CNN : deux réseaux entraînés face aux attaques de l’article, comparés tableau par tableau aux résultats publiés."
weight: 4
year: 2026
repo: "https://github.com/schalappe/watermark_resolution"
stack: ["PyTorch", "Kornia", "uv"]
result: "PSNR de 40,1 dB et BER de 1,2 % sans attaque, contre 40,6 dB et 0,7 % dans l’article\u202F; rotation non apprise"
cover_alt: "Chaîne de tatouage : un réseau d’insertion cache une marque 8×8 dans une image 128×128, une attaque aléatoire la modifie, et un réseau d’extraction tente de retrouver la marque."
---

## Problème

Un tatouage numérique cache la marque d'un propriétaire dans une image. Il doit rester invisible et résister aux retouches courantes : compression, flou, bruit, recadrage ou rotation. Un schéma aveugle doit aussi retrouver la marque sans l'image d'origine. J'ai reproduit l'article [« Convolutional Neural Network-Based Digital Image Watermarking Adaptive to the Resolution of Image and Watermark »](https://www.mdpi.com/2076-3417/10/19/6854) (Lee, Seo et Kim, Applied Sciences, 2020) : même architecture, mêmes réglages d'entraînement, mêmes jeux de données et mêmes mesures, pour comparer chaque chiffre à celui publié.

## Approche

La méthode entraîne deux réseaux ensemble :

- Un réseau d'insertion reçoit la luminance d'une image 128×128 et une marque binaire 8×8. Il agrandit la marque par quatre blocs de convolutions transposées, la fusionne avec les caractéristiques de l'image et produit l'image tatouée.
- Un réseau d'extraction lit une image éventuellement attaquée et prédit la marque.

Entre les deux, chaque lot d'entraînement subit une attaque tirée au hasard dans la liste de l'article. Les deux réseaux sont entièrement convolutifs, avec un rapport fixe de 16 pour 1 entre image et marque : les poids entraînés en 128×128 fonctionnent aussi en 64, 256 et 512 pixels. L'entraînement utilise les données de l'article : 10 000 images BOSSbase réduites en 128×128, et les 49 images de test standard en 512×512 pour l'évaluation.

## Ce que j'ai construit

- Une réécriture en PyTorch de ma première version TensorFlow, avec les attaques sur GPU grâce à Kornia.
- Toutes les attaques de l'article : filtres gaussien, moyen et médian, sel et poivre, bruit gaussien, accentuation, JPEG, rotation, recadrage, cropout et dropout, aux intensités de l'article.
- Une boucle d'entraînement qui reprend où elle s'est arrêtée et enregistre pertes, PSNR et taux d'erreur binaire (BER) à chaque époque.
- Un script d'évaluation qui reconstruit les tableaux de l'article : BER par attaque, PSNR et BER par résolution d'image, et effet de la force d'insertion.
- Là où l'article ne dit rien (nombre de canaux, sens exact du recadrage et du cropout, weight decay), j'ai documenté mon choix dans le code concerné.

L'entraînement complet a suivi les réglages de l'article sur une RTX 3090 et s'est arrêté à l'époque 2 607 sur 4 000, une fois la perte, le PSNR et le BER stables depuis environ 1 500 époques.

## Résultats

Sur les 49 images d'évaluation, les images tatouées atteignent un PSNR de 40,1 dB (article : 40,6 dB), et la marque revient avec 1,2 % de bits faux sans attaque (article : 0,7 %).

| Attaque | BER mesuré | BER article |
|---|---|---|
| Filtre gaussien 9×9 | 8,3 % | 18,5 % |
| Filtre médian 5×5 | 8,9 % | 10,6 % |
| JPEG, qualité 50 | 3,5 % | 8,1 % |
| JPEG, qualité 10 | 28,5 % | 31,5 % |
| Bruit gaussien σ = 0,08 | 17,4 % | 12,0 % |
| Recadrage 0,5 | 17,4 % | 14,6 % |
| Dropout 0,5 | 6,6 % | 6,3 % |
| Rotation 45° | 50,2 % | 5,0 % |

Les filtres et le JPEG font mieux que l'article ; le bruit, le sel et poivre, le recadrage et le cropout font quelques points de moins. Une insertion plus forte échange la qualité contre la robustesse. D'une force de 0,5 à 2, le PSNR passe de 41,9 à 37,9 dB et le BER de 3,2 % à 0,5 %. Le [rapport complet](https://github.com/schalappe/watermark_resolution/blob/main/docs/report-paper.md) donne toutes les lignes.

## Limites

L'extracteur n'a jamais appris la rotation. Le BER reste autour de 50 %, soit le hasard, à tous les angles et toutes les résolutions, contre 1,8 à 5,0 % dans l'article. Je n'ai pas étudié la cause. Le PSNR augmente aussi beaucoup moins avec la résolution que dans l'article (+0,5 dB de 64 à 512 pixels, contre +2,4 dB). Les auteurs n'ont pas publié leurs autres marques, donc je n'ai pas pu reproduire les colonnes d'adaptabilité. Le projet s'arrête avec cet entraînement.
