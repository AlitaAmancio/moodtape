# Recommendation results: before and after

How the recommendations for "Brooklyn Baby" (Lana Del Rey) changed between the original Colab
notebook and the revised one. All numbers come from `moodtape_analysis.ipynb`.

## What changed in the pipeline

| | Before (original notebook) | After (revised notebook) |
|---|---|---|
| Data | 113,999 rows, with duplicates | 81,343 unique tracks |
| Features | 14 columns, incl. `key`, `mode`, `time_signature`, `explicit`, `duration_ms` | 9 continuous audio features |
| Similarity | Euclidean distance on 3 PCA components | Euclidean distance on all 9 standardized features (kNN) |
| Candidates | Same K-Means cluster only (k=8, chosen before the analysis) | All tracks |

## Before

Outputs captured from the original notebook before it was revised.

### Version 1: nearest neighbours in PCA 3D, same cluster

| track_name                           | artists               | track_genre | dist |
|--------------------------------------|-----------------------|-------------|------|
| Let's Make Love                      | Faith Hill;Tim McGraw | country     | 0.18 |
| Alone in the Dark Mansion of Madness | Harley Poe            | acoustic    | 0.21 |
| Unspoken                             | Out of Nowhere        | iranian     | 0.23 |
| Crying From The Bathroom             | Koe Wetzel            | country     | 0.24 |
| Ceremony for the Gathering of Death  | Inquisition           | black-metal | 0.27 |

### Version 2: weighted PCA 3D distance (weights 1.0, 1.0, 0.8), same cluster and same genre

| track_name   | artists        | track_genre | dist |
|--------------|----------------|-------------|------|
| Another Love | Tom Odell      | pop         | 0.67 |
| The Hills    | The Weeknd     | pop         | 0.95 |
| The Hills    | The Weeknd     | pop         | 0.95 |
| deja vu      | Olivia Rodrigo | pop         | 1.01 |
| Cherry       | Lana Del Rey   | pop         | 1.01 |

Version 2 looked better, but mostly because of the hard genre filter, not the similarity measure.
"The Hills" appears twice because the dataset had duplicate tracks.

### How close were they really?

Real distance of each old recommendation to "Brooklyn Baby" in the full 9-feature space, and its
rank among all 81,343 tracks (1 = closest). For reference, the median distance to any track is **3.44**.

| track_name                           | distance | rank   |
|--------------------------------------|----------|--------|
| Let's Make Love                      | 1.74     | 2,048  |
| Alone in the Dark Mansion of Madness | 1.40     | 494    |
| Unspoken                             | 1.43     | 585    |
| Crying From The Bathroom             | 1.71     | 1,864  |
| Ceremony for the Gathering of Death  | 3.38     | 38,724 |
| Another Love                         | 1.01     | 52     |
| The Hills                            | 1.89     | 3,301  |
| deja vu                              | 2.92     | 24,832 |
| Cherry                               | 2.40     | 11,620 |

The black metal track ranked top 5 by the PCA 3D approach is at about the median distance: as
similar to "Brooklyn Baby" as a random track. Distances that look small in 3 components can be large
in the full space. (The old results were produced with a different feature set, so this measures
them against the current definition of similarity.)

## After: k-nearest neighbours on the 9 standardized features

| track_name                          | artists                             | genres            | distance |
|-------------------------------------|-------------------------------------|-------------------|----------|
| Returning To You (feat. Alison May) | Seven Lions;Andrew Bayer;Alison May | dubstep           | 0.60     |
| Stars                               | Kayou.                              | chill             | 0.61     |
| Idk How to Kill Myself              | Yunggoth✰                           | emo               | 0.62     |
| Ovotaar                             | aswekeepsearching;Shankuraj Konwar  | ambient           | 0.74     |
| Hilf mir durch die Nacht            | Wietske van Tongeren, Uwe Kröger    | show-tunes        | 0.76     |
| Toh Phir Aao                        | Mustafa Zahid                       | hip-hop, pop-film | 0.77     |
| Heroes And Villains - Remastered 2001 | The Beach Boys                    | psych-rock        | 0.79     |
| Hate Me                             | Blue October                        | grunge            | 0.79     |
| Ghaaf Kaaf Gaaf                     | Rojin Sharafi                       | iranian           | 0.81     |
| Vento No Litoral                    | Cássia Eller;Renato Russo           | brazil, mpb       | 0.85     |

Cosine distance returns 7 of the same 10 tracks. Restricting to tracks that share a genre (`pop`)
brings in "Another Love" (Tom Odell), but this dataset's `pop` is dominated by Indian pop, so the
genre filter is kept optional.

## Conclusion

* The new results are the true closest tracks on every audio feature (distances 0.60–0.85 vs a
  median of 3.44), with no information lost to a projection.
* They are still **not** what a listener would call the same vibe. Audio features describe how a
  track sounds, not its style, era, lyrics or cultural context. Streaming services fill that gap with
  listening behaviour, which is not available to new Spotify apps.
* Getting closer to a listener's sense of similarity requires context beyond audio features, such
  as listener-provided tags or listening behaviour.

## Other issues fixed along the way

- Searching artists with `str.contains("Lana")` also matched "Micky Flanagan" (substring match),
  returning comedy tracks. Tracks are now looked up by exact track name and exact credited artist.
- "I'll Be Home For Christmas" (Kacey Musgraves; Lana Del Rey) appeared 5 times, once per genre it
  was tagged with. Duplicates are now removed and their genres merged.
