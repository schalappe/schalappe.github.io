---
title: "Deep learning image watermarking"
description: "A PyTorch reproduction of a CNN watermarking paper: two networks trained together against the paper’s attack mix, measured table by table against the published results."
weight: 4
year: 2026
repo: "https://github.com/schalappe/watermark_resolution"
stack: ["PyTorch", "Kornia", "uv"]
result: "40.1 dB PSNR and 1.2% BER without attack, against 40.6 dB and 0.7% in the paper; rotation not learned"
cover_alt: "Watermarking pipeline: an embedding network hides an 8×8 mark in a 128×128 image, a random attack alters it, and an extraction network tries to recover the mark."
---

## Problem

A digital watermark hides an owner's mark inside an image. It has to be invisible, and it has to survive common edits such as compression, blur, noise, cropping or rotation. A blind scheme must also recover the mark without access to the original image. I reproduced the paper ["Convolutional Neural Network-Based Digital Image Watermarking Adaptive to the Resolution of Image and Watermark"](https://www.mdpi.com/2076-3417/10/19/6854) (Lee, Seo and Kim, Applied Sciences, 2020): same architecture, same training settings, same datasets, and the same measurements, so each number can be compared with the published one.

## Approach

The method uses two networks trained together:

- An embedding network takes the luma channel of a 128×128 image and an 8×8 binary mark. It upsamples the mark through four transposed-convolution blocks, merges it with features of the image, and outputs the watermarked image.
- An extraction network reads a possibly attacked image and predicts the mark.

Between the two, every training batch goes through a random attack from the paper's list. Both networks are fully convolutional with a fixed 16:1 image-to-mark ratio, so the weights trained at 128×128 also run at 64, 256 and 512 pixels. Training uses the paper's datasets: 10,000 BOSSbase images down-sampled to 128×128, and the 49 standard 512×512 test images for evaluation.

## What I built

- A rewrite of my first TensorFlow version in PyTorch, with the attacks on the GPU through Kornia.
- The paper's full attack mix: Gaussian, average and median filtering, salt and pepper, Gaussian noise, sharpening, JPEG, rotation, crop, cropout and dropout, each at the paper's strengths.
- A resumable training loop that logs losses, PSNR and bit error ratio (BER) every epoch.
- An evaluation script that rebuilds the paper's tables: BER per attack, PSNR and BER per image resolution, and the effect of the embedding strength.
- Where the paper is silent (channel counts, the exact meaning of crop and cropout, weight decay), I documented my choice in the code where it applies.

The full run used the paper's settings on an RTX 3090 and stopped at epoch 2,607 of 4,000, once loss, PSNR and BER had been stable for about 1,500 epochs.

## Results

On the 49 evaluation images, the watermarked images reach a PSNR of 40.1 dB (paper: 40.6 dB), and the mark comes back with 1.2% of wrong bits when there is no attack (paper: 0.7%).

| Attack | BER measured | BER paper |
|---|---|---|
| Gaussian filter 9×9 | 8.3% | 18.5% |
| Median filter 5×5 | 8.9% | 10.6% |
| JPEG, quality 50 | 3.5% | 8.1% |
| JPEG, quality 10 | 28.5% | 31.5% |
| Gaussian noise σ = 0.08 | 17.4% | 12.0% |
| Crop 0.5 | 17.4% | 14.6% |
| Dropout 0.5 | 6.6% | 6.3% |
| Rotation 45° | 50.2% | 5.0% |

Filtering and JPEG do better than in the paper; noise, salt and pepper, crop and cropout do a few points worse. A stronger embedding trades quality for robustness. From strength 0.5 to 2, PSNR falls from 41.9 to 37.9 dB and BER from 3.2% to 0.5%. The [full report](https://github.com/schalappe/watermark_resolution/blob/main/docs/report-paper.md) has every row.

## Limitations

The extractor never learned rotation. BER stays around 50%, which is chance, at every angle and resolution, against 1.8 to 5.0% in the paper. I did not investigate the cause. PSNR also rises much less with resolution than in the paper (+0.5 dB from 64 to 512 pixels, against +2.4 dB). The authors did not publish their other watermark images, so I could not reproduce the adaptability columns. The project ends with this run.
