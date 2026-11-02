# moodtape

> Work in progress

Describe the vibe you're in the mood for, such as *"melancholic but danceable, for a late-night drive"*, and get songs that match.

The current stage is data preparation: cleaning a public dataset of Spotify tracks, choosing the audio features that describe how a track sounds, and testing how well similarity on those features finds tracks that belong together.

## How it works so far

```
Kaggle dataset (114,000 rows)
        │
        ▼
analysis/moodtape_analysis.ipynb
  • remove duplicates            → 81,343 unique tracks
  • select 9 audio features      → standardize them
  • explore clusters (K-Means)   → describe the catalog
  • nearest-neighbour search     → similar tracks
        │
        ▼
analysis/data/
  tracks_clean.parquet   tracks, metadata and standardized feature vectors
  scaler.json            mean and standard deviation of each feature
```

## Results

**Data cleaning.** The raw dataset has 114,000 rows, but the same track is listed once per genre it belongs to, and the same song can appear under several Spotify IDs (single and album releases). After removing duplicates and merging their genres, **81,343 unique tracks** remain.

**Features.** Only the 9 continuous audio features are used: danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence and tempo. Categorical or non-audio columns (`key`, `mode`, `time_signature`, `explicit`, `duration_ms`) showed no meaningful relation to mood and distort distances, so they are kept only as metadata.

**Clusters.** K-Means with **k = 7** (chosen with the elbow method and silhouette score) finds recognizable sound profiles: soft acoustic songs, loud and intense tracks, spoken word, energetic instrumentals, calm instrumentals, upbeat dance tracks and live recordings. Still, every silhouette score is below 0.26: tracks form a **continuum**, not well-separated groups.

**Similarity.** Because of that, similar tracks are found with **k-nearest neighbours** on all 9 standardized features instead of "tracks from the same cluster". The first version of the notebook ranked tracks by distance in a 3D PCA projection. One of its top-5 matches for "Brooklyn Baby" (Lana Del Rey) was a black metal track that, measured on the full features, is the **38,724th** closest track: about as similar as a random one. The full before/after comparison is in [analysis/baseline_results.md](analysis/baseline_results.md).

## Project structure

```
analysis/   Data exploration, cleaning and feature preparation (Python notebook)
db/         Database init scripts
```

## Running locally

**Data analysis** (Python 3.13):

```bash
python -m venv .venv
.venv/Scripts/activate                  # Windows; on macOS/Linux: source .venv/bin/activate
pip install -r analysis/requirements.txt
nbstripout --install --attributes .gitattributes   # strip notebook outputs on commit
```

Then run `analysis/moodtape_analysis.ipynb` from top to bottom. It downloads the dataset from Kaggle (no credentials needed) and writes the clean files to `analysis/data/`, which is git-ignored.

**Database** (Docker): a PostgreSQL 17 container with the pgvector extension is defined in `docker-compose.yml`. It is not populated yet.

```bash
cp .env.example .env      # optional: defaults work out of the box
docker compose up -d      # starts Postgres on localhost:5432
```

## Known limitations

- Spotify no longer provides audio features to new apps (since November 2024), so they come from a public Kaggle dataset ([Spotify Tracks Attributes and Popularity](https://www.kaggle.com/datasets/melissamonfared/spotify-tracks-attributes-and-popularity)). The catalog is limited to the tracks in that dataset.
- Audio features describe how a track sounds, not its style, era, lyrics or cultural context. Tracks that are close on these features can still feel like a completely different vibe to a listener.
- The dataset is not redistributed in this repository; it is downloaded when the notebook runs.
