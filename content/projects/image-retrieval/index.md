---
title: "Content-based image retrieval"
description: "A benchmark of eight feature extractors and three distance measures for finding similar clothing images, measured with MAP and MRR."
weight: 1
year: 2023
repo: "https://github.com/schalappe/content-based-image-retrieval"
stack: ["PyTorch", "timm", "OpenCV", "scikit-learn", "Polars"]
result: "Best MAP 0.67 on colour and style, with SigLIP 2 at 25 ms per query"
cover_alt: "Retrieval pipeline: catalogue and query images go through the same feature extractor, a distance measure ranks the catalogue, and the five nearest images are returned."
results_alt: "Table of MAP on colour and style for the 24 combinations: SigLIP 2 reaches 0.67, ConvNeXt-Tiny and VGG16 about 0.61, EfficientNetB7, NASNetLarge and DINOv2 0.45 to 0.55, AKAZE and ORB 0.11 to 0.17. Query time ranges from 5 ms (ORB) to 207 ms (EfficientNetB7)."
results_caption: "Open the table full size by tapping it; on a phone it also scrolls sideways."
---

## Problem

Content-based image retrieval finds similar images from their pixels, not from tags or captions. A system like this depends on two choices: how an image is turned into a vector, and how two vectors are compared. I wanted to measure which combination returns the most relevant results on a real catalogue, and what each choice costs in query time.

## Approach

I compared eight feature extractors against three distance measures, so 24 combinations in total:

- Local descriptors from OpenCV, AKAZE and ORB. I turned them into a bag of visual words by learning a vocabulary of 512 words on the catalogue, so each image becomes a fixed-length histogram.
- Pretrained networks loaded with timm, each with its own preprocessing: three CNNs from ImageNet (VGG16, NASNetLarge, EfficientNetB7), a recent compact CNN (ConvNeXt-Tiny), a self-supervised vision transformer (DINOv2) and an image-text model (SigLIP 2).
- Cosine, Euclidean and Manhattan distances. The search is exact and scans the whole catalogue, so no approximate index skews the results.

The dataset is the [Kaggle Apparel Images dataset](https://www.kaggle.com/datasets/trolukovich/apparel-images-dataset): 11,385 images in 24 categories, where each folder name gives a colour and a clothing style (for example "black dress"). A seeded, stratified split keeps 7,627 images as the searchable catalogue and 3,758 as queries. For each query, the system returns the 5 nearest images. I scored the results against the colour label, the style label, and both together, with MAP@5, MRR@5, first-rank accuracy and query time.

## What I built

- Extractors for the two descriptors and the six networks, all producing fixed-size vectors stored in one Parquet file per method.
- A pipeline that extracts the catalogue in batches and each query once, then runs the 24 searches on the stored vectors, timing extraction and search separately. A `Makefile` drives it from the Kaggle download to the evaluation.
- The metric functions, with unit tests on average-precision normalisation, failed queries and closest-first ordering for every measure.

## Results

The full tables are in the [evaluation notebook](https://github.com/schalappe/content-based-image-retrieval/blob/main/notebooks/1.0-evaluation.ipynb). On the hardest task, matching both colour and style:

- SigLIP 2 with cosine distance came first: MAP 0.67, MRR 0.87, first-rank accuracy 0.80, in 25 ms per query.
- ConvNeXt-Tiny was second (MAP 0.62) and the fastest network, at 16 ms per query.
- The large networks of the first version, EfficientNetB7 and NASNetLarge, were less accurate (0.55 and 0.51) and 5 to 13 times slower.
- The best local descriptor, AKAZE with Manhattan distance, reached a MAP of 0.17.

DINOv2 was the best on style alone (MAP 0.97) but the weakest network on colour (0.46): its features describe shape more than colour. For the networks, the choice of measure barely matters. Query time is almost all extraction: the exact search over 7,627 images takes under 1 ms with cosine or Euclidean distance.

## Limitations and next steps

I first ran this study in 2023 with TensorFlow and five extractors. Its results were wrong, for three reasons. The cosine search sorted similarities as if they were distances, so it returned the least similar images first. The metric code divided the average precision by the number of hits found instead of the number of relevant images. And the descriptor vectors held raw keypoint bytes padded with zeros. I fixed all three, moved to PyTorch and timm, and reran everything. The numbers above replace the 2023 ones.

I measured the times on an Apple M1 Pro, and they depend on the hardware. A catalogue far larger than 7,627 images would need an approximate nearest-neighbour index. I would also try fine-tuning a model on the catalogue instead of using frozen pretrained features.
