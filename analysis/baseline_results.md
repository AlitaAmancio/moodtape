# Baseline results (original Colab notebook)

Outputs captured from the original notebook before it was revised, so the
"before/after" comparison of the recommendation approach can be documented.

Original approach: K-Means with k=8 on standardized features, then Euclidean
distance on the first 3 PCA components, restricted to the reference track's cluster.

## Recommendations for "Brooklyn Baby" (Lana Del Rey)

### Version 1: nearest neighbours in PCA 3D, same cluster

| track_name                           | artists               | track_genre | dist |
|--------------------------------------|-----------------------|-------------|------|
| Let's Make Love                      | Faith Hill;Tim McGraw | country     | 0.18 |
| Alone in the Dark Mansion of Madness | Harley Poe            | acoustic    | 0.21 |
| Unspoken                             | Out of Nowhere        | iranian     | 0.23 |
| Crying From The Bathroom             | Koe Wetzel            | country     | 0.24 |
| Ceremony for the Gathering of Death  | Inquisition           | black-metal | 0.27 |

A black metal track as a top-5 match for "Brooklyn Baby" shows how much
information is lost when distances are computed on only 3 principal components.

### Version 2: weighted PCA 3D distance (weights 1.0, 1.0, 0.8), same cluster and same genre

| track_name   | artists        | track_genre | dist |
|--------------|----------------|-------------|------|
| Another Love | Tom Odell      | pop         | 0.67 |
| The Hills    | The Weeknd     | pop         | 0.95 |
| The Hills    | The Weeknd     | pop         | 0.95 |
| deja vu      | Olivia Rodrigo | pop         | 1.01 |
| Cherry       | Lana Del Rey   | pop         | 1.01 |

Results look better, but mostly because of the hard genre filter, not the
similarity measure. "The Hills" appears twice: the dataset has duplicate tracks.

## Other issues observed

- Searching artists with `str.contains("Lana")` also matched "Micky Flanagan"
  (substring match), returning comedy tracks.
- "I'll Be Home For Christmas" (Kacey Musgraves; Lana Del Rey) appears 5 times,
  once per genre it is tagged with.
