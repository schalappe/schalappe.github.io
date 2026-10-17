---
title: "Content-based image retrieval"
description: "A benchmark of five feature extractors and three distance measures for finding similar clothing images, measured with MAP and MRR."
weight: 1
year: 2023
repo: "https://github.com/schalappe/content-based-image-retrieval"
stack: ["TensorFlow", "OpenCV", "scikit-learn", "Polars", "seaborn"]
---

## Problem

Content-based image retrieval finds similar images from their pixels, not from tags or captions. A system like this depends on two choices: how an image is turned into a vector, and how two vectors are compared. I wanted to measure which combination returns the most relevant results on a real catalogue, and what each choice costs in query time.

## Approach

I compared five feature extractors against three similarity measures, so 15 combinations in total:

- Local descriptors from OpenCV: AKAZE and ORB.
- ImageNet-pretrained CNNs, using the penultimate layer as the embedding: VGG16, NASNetLarge and EfficientNetB7.
- Cosine similarity, Euclidean distance and Manhattan distance.

The dataset is the Kaggle Apparel Images dataset, where each folder name gives a colour and a clothing style (for example "black dress"). I made a stratified split: 10,833 images form the searchable database and the other 5,337 are the queries. For each query, the system returns the 5 nearest images. I scored the results against the colour label, the style label, and both together, with mean average precision (MAP), mean reciprocal rank (MRR), first-rank accuracy and median query time.

## What I built

- `Descriptor` classes that keep the 32 strongest keypoints and zero-pad the result to a fixed-length vector, so local descriptors can be compared like embeddings.
- `Compressor` classes that wrap the three Keras models with their own input size and preprocessing.
- A `Finder` with one subclass per distance, timed on every query.
- Scripts to download the data, build the split, extract features to Parquet, and run all 15 evaluations, driven by a `Makefile`.
- The metric functions, with unit tests.

## Results

The full tables are in `reports/1.0-evaluation.pdf` in the repo. On the hardest task, matching both colour and style:

- EfficientNetB7 with Euclidean distance came first: MAP 0.73, MRR 0.77, first-rank accuracy 0.67.
- VGG16 with Euclidean distance was close behind, with a MAP of 0.72.
- The best local descriptor, ORB with Manhattan distance, reached a MAP of 0.20.
- On style alone, the three CNNs scored a MAP between 0.93 and 0.96.

The descriptors were faster (median about 0.02 to 0.03 s per query, against 0.10 s for VGG16 and 0.23 s for EfficientNetB7), but much less accurate. AKAZE also failed to produce features for 24 of the database images.

## Limitations and next steps

The cosine results are not usable. My `CosinusFinder` sorts similarity scores in ascending order, as if they were distances, so it returns the least similar images first. The near-zero cosine scores come from that bug, not from the measure itself. Fixing the sort order and rerunning is the first step.

The query time includes feature extraction and a brute-force scan of the database. A real system would precompute embeddings and use an approximate nearest-neighbour index. I would also try fine-tuning a model on the catalogue instead of using frozen ImageNet features.
