---
title: "Deep learning image watermarking"
description: "A TensorFlow implementation of a CNN watermarking paper: two networks trained together against ten image attacks, tuned with Optuna."
weight: 4
year: 2023
repo: "https://github.com/schalappe/watermark_resolution"
stack: ["TensorFlow", "Keras", "Optuna", "imgaug"]
---

## Problem

A digital watermark hides an owner's mark inside an image. It has to be invisible, and it has to survive common edits such as compression, blur, noise, cropping or rotation. A blind scheme must also recover the mark without access to the original image. I implemented the paper "Convolutional Neural Network-Based Digital Image Watermarking Adaptive to the Resolution of Image and Watermark" (Lee, Seo and Kim, Applied Sciences, 2020) and focused on finding the training settings that make it work.

## Approach

The method uses two networks trained together:

- An embedding network takes a 128×128 image and an 8×8 binary mark. It converts the image to YCbCr, upsamples the mark through four transposed-convolution blocks, merges it with features of the luma channel, and rebuilds the RGB image.
- An extraction network reads the luma channel of a possibly attacked image and predicts the mark.

Between the two, every training batch goes through a random attack. The embedding loss balances image fidelity (MSE) against mark recovery (MAE); the extraction loss only measures mark recovery. The authors used the BOSS dataset; I used two public grayscale datasets from Hugging Face, 10K images for training and 6K for testing.

## What I built

- Custom Keras layers for colour conversion, luma/chroma split and Arnold cat map scrambling of the mark.
- A `WatermarkModel` with its own `train_step`: one `GradientTape`, two losses and two Adam optimizers.
- Ten attacks built on imgaug and TensorFlow: crop, dropout, rotation, salt and pepper, median, average and Gaussian blur, JPEG quality, Gaussian noise, and no attack.
- PSNR and bit error ratio (BER) metrics.
- A two-stage Optuna search, first on learning rates, batch size and epochs, then on the loss weights. The retained values are in `models/best_params.json`.

## Results

The evaluation in `notebooks/0.1-result_learn.ipynb` reports a PSNR of 18.0 dB for the watermarked images, which is a visible change, and a BER around 50% under every attack. That BER uses the raw float output without thresholding (see below), so it can't tell whether the extractor learned the mark. Mark recovery stays unverified until I fix the metric and rerun the evaluation.

The project does show a complete, reproducible pipeline: data download, augmentation, joint training, hyperparameter search and evaluation per attack.

## Limitations and next steps

Before more training, the evaluation itself needs a fix. The BER compares the raw float output of the extractor with the binary mark, without thresholding it first, so the metric does not reflect what a rounded prediction would give. The scrambling option is also incomplete: `extract_stack` discards the result of the inverse Arnold transform.

Next, I would threshold the prediction in the BER, check that the extractor can recover the mark with no attack, then add attacks progressively and compare PSNR and BER with the values reported in the paper.
