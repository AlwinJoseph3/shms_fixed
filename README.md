# SHMS — Smart Health Management System

> *AI-powered medical imaging analysis and automated diagnostic report generation.*

[![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![YOLOv5](https://img.shields.io/badge/YOLOv5-00FFFF?style=flat&logo=github&logoColor=black)](https://github.com/ultralytics/yolov5)
[![Pegasus](https://img.shields.io/badge/Pegasus_Transformer-FF6F00?style=flat&logo=huggingface&logoColor=white)](https://huggingface.co/google/pegasus-xsum)

---

## What is SHMS?

SHMS is an AI-powered pipeline that combines computer vision and natural language generation to assist in medical imaging analysis.

Given a chest X-ray, the system detects and localises disease markers using YOLOv5, then automatically generates a plain-language diagnostic summary using the Pegasus transformer — bridging the gap between raw model output and readable clinical reporting.

---

## Pipeline Overview

```
Medical Image (X-Ray)
        ↓
  Preprocessing & Augmentation
        ↓
  YOLOv5 Disease Detection
  (bounding boxes + classifications)
        ↓
  Pegasus Transformer
  (structured report → plain-language summary)
        ↓
  Diagnostic Report Output
```

---

## Datasets Used

| Dataset | Description |
|---|---|
| **MIMIC-CXR** | Large-scale chest X-ray dataset with radiology reports |
| **NIH Chest X-Ray** | 112,000+ frontal-view X-rays across 14 disease classes |

Both datasets were curated, cleaned, and preprocessed to ensure pipeline integrity before model training.

---

## Features

- 🔍 **Disease detection** — YOLOv5 identifies and localises pathological markers in chest X-rays
- 📝 **Automated report summarisation** — Pegasus generates readable diagnostic summaries from structured findings
- 🧹 **Large-scale dataset preprocessing** — MIMIC-CXR and NIH Chest X-Ray pipelines with integrity validation
- 📊 **Deep learning model optimisation** — trained and evaluated for real-world medical imaging conditions

---

## Tech Stack

| Component | Technology |
|---|---|
| Disease Detection | YOLOv5 (computer vision) |
| Report Generation | Pegasus transformer (NLP) |
| Data Processing | Python, NumPy, Pandas |
| Model Training | PyTorch |
| Datasets | MIMIC-CXR, NIH Chest X-Ray |

---

## Why This Matters

Radiologists review hundreds of scans daily. Automated first-pass analysis tools like SHMS can flag high-priority cases and reduce report turnaround time — making AI a genuine clinical assistant, not a replacement.

---

## Getting Started

```bash
git clone https://github.com/AlwinJoseph3/shms_fixed.git
cd shms_fixed
pip install -r requirements.txt
```

> **Note:** MIMIC-CXR access requires credentialed PhysioNet registration. NIH Chest X-Ray is publicly available via Kaggle.

---

## Built By

**Alwin Joseph** — [Portfolio](https://alwinjoseph.netlify.app/) · [LinkedIn](https://www.linkedin.com/in/alwin-joseph-807420221/) · [GitHub](https://github.com/AlwinJoseph3)
