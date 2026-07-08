# Single Cell RNAseq

!!! info "Coming soon — July 2026"
    This workshop is under development and will be available for the July 2026 workshop series. Check back closer to the session date for the full course page.

---

Single-cell RNA sequencing (scRNA-seq) resolves gene expression at the level of individual cells, revealing the diversity of cell types and states within a tissue that bulk RNA-seq would average together. It has become a foundational tool for mapping cell atlases, characterizing tumor microenvironments, and studying development.

In this workshop you will work with a processed single-cell dataset, learn how the cell × gene matrix differs from bulk data, perform quality control and normalization, cluster cells into groups, and identify cell types from marker genes — all visualized through UMAP embeddings.

!!! info "Learning Objectives"
    By the end of this workshop you will be able to:

    - Understand single-cell sequencing technology and its underlying fundamentals
    - Interpret a single-cell expression matrix and understand its file structure
    - Build a Seurat object from barcode, feature, and matrix files

    **QC / Pre-processing**

    - Perform quality control on a Seurat object — scoring mitochondrial content, filtering low-count cells, and thresholding `nFeature_RNA` to flag potential doublets
    - Log-normalize and scale expression data in preparation for dimensionality reduction

    **Post-processing**

    - Reduce dimensionality with PCA and construct a k-nearest neighbor (KNN) graph
    - Cluster cells with the Louvain algorithm and visualize results with UMAP/t-SNE

## Prerequisites

- Completion of the [Introduction to Data Science](../introDataScience/index.md) series, or equivalent R experience
- Recommended: [Differential Gene Expression (Bulk RNAseq)](../bulkDGE/index.md)

---

## Launch Your Workspace

!!! info "You need a free GitHub account to use this workshop"
    This workshop runs in **GitHub Codespaces** — a cloud environment that requires a GitHub account. If you do not have one, create one for free at [github.com](https://github.com) before the session. No paid plan is required.

    **GitHub Free quota (per account, per month):**

    - 120 core-hours of compute — equivalent to **60 hours** of run time on a standard 2-core Codespace
    - 15 GB of storage

    This is enough for workshops and occasional use, but is **not intended to replace a local development environment** for everyday work.

This workshop runs entirely in a cloud environment — no software installation required. One click opens a pre-configured RStudio session with Seurat and all required packages installed.

<div style="margin: 1.2rem 0;">
<a href="https://codespaces.new/mdibl/mdibl.github.io?devcontainer_path=.devcontainer%2Fsingle-cell%2Fdevcontainer.json" target="_blank">
  <img src="https://github.com/codespaces/badge.svg" alt="Open in GitHub Codespaces" style="height:32px;">
</a>
</div>

!!! info "First launch takes several minutes"
    The first time the Codespace builds, GitHub installs Seurat and its dependencies. Subsequent launches are instant.

**What you'll see:**

1. GitHub opens a VS Code editor in your browser — this is the Codespace container. You do not need to use VS Code for this workshop.
2. A browser tab for **RStudio** will open automatically at port 8787. No login is required.
3. If RStudio does not open automatically: in VS Code, click the **Ports** tab at the bottom panel, find port `8787`, and click the globe icon to open it in a new tab.

!!! tip "Keep your Codespace awake — and stop it when you're done"
    Codespaces automatically pause after **30 minutes of inactivity**, but suspended Codespaces still consume your monthly storage quota. **Closing the browser tab does not stop the Codespace.**

    **At the start of the workshop**, open a new terminal tab in VS Code (**Terminal → New Terminal**) and run this keepalive loop:

    ```bash
    while true; do echo "keepalive $(date)"; sleep 300; done
    ```

    This pings the Codespace every 5 minutes to prevent it from suspending during the session.

!!! danger "How to stop your Codespace *when you're done*"

    1. Switch to the VS Code terminal tab where the `keepalive` loop is running.
    2. Press **Ctrl+C** to stop it.
    3. Go to [github.com/codespaces](https://github.com/codespaces), find your Codespace, click `···`, and select **Stop codespace**.

    ***Closing the browser tab is not enough — a suspended Codespace still counts against your monthly storage quota.***

**Getting oriented in RStudio:**

Once RStudio is open, get the workshop files ready:

1. In the **Files** pane (bottom-right), you will see the workshop directory. Click `scRNAseq.Rproj` to open the project — this sets your working directory correctly so data paths in the script will resolve.
2. Open `workshop.Rmd` (File → Open File, or click it in the Files pane). This is the file you will work through during the workshop.
3. Each grey block is a code chunk. Run a chunk by clicking the **▶ Run Current Chunk** button (green play icon at the top-right of the chunk), or press **Ctrl+Shift+Enter** (Windows/Linux) / **Cmd+Shift+Return** (Mac).

!!! tip "Save your work"
    Press **Ctrl+S** / **Cmd+S** often. At the end of the session, use the **Files** pane → More → Export to download your completed notebook to your computer before closing the Codespace.

---

## About This Dataset

!!! abstract "10x Genomics PBMC 3k — Seurat Guided Clustering Tutorial"
    **Source:** [10x Genomics](https://www.10xgenomics.com/) — Peripheral Blood Mononuclear Cells (PBMC), 2,700 single cells sequenced on the Illumina NextSeq 500
    **Data download:** [`pbmc3k_filtered_gene_bc_matrices.tar.gz`](https://cf.10xgenomics.com/samples/cell/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz)
    **Template:** This workshop follows the structure of the Seurat [**Guided Clustering Tutorial (pbmc3k)**](https://satijalab.org/seurat/articles/pbmc3k_tutorial), developed and maintained by the **Satija Lab and collaborators**.

This dataset and analysis walkthrough is one of the most widely used entry points to single-cell analysis, and the workshop exercises mirror its structure: quality control and filtering, log-normalization, variable feature selection, scaling, PCA, graph-based (Louvain) clustering, UMAP visualization, and marker-based cell type annotation.

**Citing Seurat:** if you use Seurat in your own research, cite the paper corresponding to the version you use:

- Hao, Y. et al. ["Dictionary learning for integrative, multimodal and scalable single-cell analysis."](https://doi.org/10.1038/s41587-023-01767-y) *Nature Biotechnology* (2023) — Seurat v5
- Hao\*, Hao\*, et al. ["Integrated analysis of multimodal single-cell data."](https://doi.org/10.1016/j.cell.2021.04.048) *Cell* (2021) — Seurat v4
- Stuart\*, Butler\*, et al. ["Comprehensive Integration of Single-Cell Data."](https://doi.org/10.1016/j.cell.2019.05.031) *Cell* (2019) — Seurat v3

!!! tip "Acknowledgement"
    Dataset courtesy of 10x Genomics. Tutorial structure and analysis workflow adapted from the Seurat project ([satijalab.org/seurat](https://satijalab.org/seurat/)), developed by the Satija Lab and collaborators.

---

## Part 1 — QC & Pre-processing

### Load packages

Open `workshop.Rmd` and run the **Setup** chunk. This loads all packages and confirms the working directory is set correctly by `scRNAseq.Rproj`.

```r
library(Seurat)
library(patchwork)
library(dplyr)
library(ggplot2)

getwd()  # should end in .../docs/scRNAseq
```

### What is a single-cell expression matrix?

Instead of one column per sample (as in bulk RNA-seq), a single-cell count matrix has **one column per cell** and **one row per gene** — thousands of columns instead of a handful. Each value is the number of UMIs (unique molecular identifiers) for that gene detected in that cell. The vast majority of entries are zero, since any one cell only expresses a fraction of the genome — so Seurat stores the matrix in **sparse format** to save memory.

The `Read10X()` function expects a directory containing three files, the standard output of the [Cell Ranger](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger) pipeline:

| File | Contents |
|---|---|
| `barcodes.tsv.gz` | One cell barcode per line — the column names of the matrix |
| `features.tsv.gz` | One gene per line (ID + symbol) — the row names of the matrix |
| `matrix.mtx.gz` | The sparse count matrix itself, in MatrixMarket format |

---

???+ question "Exercise 1.1 — Load the data and build a Seurat object"

    Run the **Exercise 1** chunk in `workshop.Rmd`:

    ```r
    pbmc.data <- Read10X(data.dir = "data/pbmc3k/filtered_gene_bc_matrices/hg19/")
    pbmc <- CreateSeuratObject(counts = pbmc.data, project = "pbmc3k", min.cells = 3, min.features = 200)
    pbmc
    ```

    `min.cells = 3` drops genes detected in fewer than 3 cells; `min.features = 200` drops cells with fewer than 200 detected genes — a first, coarse pass at removing empty droplets and background noise.

    **Questions:**

    1. How many cells (barcodes) came off the sequencer, and how many genes survive the `min.cells`/`min.features` filter?
    2. Why filter genes and cells before you've even looked at the data?

??? success "Solution"

    ```r
    pbmc.data <- Read10X(data.dir = "data/pbmc3k/filtered_gene_bc_matrices/hg19/")
    pbmc <- CreateSeuratObject(counts = pbmc.data, project = "pbmc3k", min.cells = 3, min.features = 200)
    pbmc
    # An object of class Seurat
    # 13714 features across 2700 samples within 1 assay
    # Active assay: RNA (13714 features, 0 variable features)
    ```

    The raw matrix has 32,738 genes × 2,700 cells. After the `min.cells`/`min.features` filter, 13,714 genes remain (genes never detected in at least 3 cells carry no information); all 2,700 cells are still present at this stage — `min.features = 200` is a very permissive floor, mainly there to drop obviously empty droplets before real QC begins.

---

### QC and selecting cells for further analysis

Three metrics distinguish a real cell from an empty droplet, background noise, or a doublet:

- **`nFeature_RNA`** — the number of unique genes detected in a cell. Too low → empty droplet or a dying cell; abnormally high → possibly two cells captured in one droplet (a **doublet**).
- **`nCount_RNA`** — total UMIs detected in a cell (correlates with `nFeature_RNA`).
- **`percent.mt`** — the percentage of a cell's reads that map to mitochondrial genes. Dying or lysed cells leak cytoplasmic RNA but retain mitochondrial RNA, so a high `percent.mt` flags low-quality cells.

`PercentageFeatureSet()` computes the mitochondrial percentage by summing counts for every gene matching a pattern — human mitochondrial genes are conventionally prefixed `MT-`.

---

???+ question "Exercise 1.2 — Score mitochondrial content and visualize QC metrics"

    Run the **Exercise 2** chunk in `workshop.Rmd`:

    ```r
    pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")

    VlnPlot(pbmc, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

    plot1 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "percent.mt")
    plot2 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
    plot1 + plot2
    ```

    **Questions:**

    1. What is the median `percent.mt` across cells? Are there outlier cells with very high mitochondrial content?
    2. In the `nCount_RNA` vs `nFeature_RNA` scatter plot, what would a cell sitting well above the main trend line (high count, disproportionately high feature number) suggest?

??? success "Solution"

    ```r
    pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")
    summary(pbmc$percent.mt)
    #    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
    #   0.000   1.537   2.031   2.217   2.643  22.569
    ```

    Median `percent.mt` is ~2%, typical for healthy PBMCs — most cells sit in a tight, low band. A handful of cells reach up into the teens and twenties; those are the ones the `percent.mt < 5` threshold below will remove.

    A cell far above the main `nCount_RNA` vs `nFeature_RNA` trend — more total UMIs than its gene count would predict — is one of the signals used to flag potential **doublets**: two cells' worth of transcripts captured under one barcode.

---

### Filtering low-quality cells and doublets

We now apply thresholds on all three metrics at once:

- **`nFeature_RNA > 200`** — removes empty droplets / low-complexity cells
- **`nFeature_RNA < 2500`** — removes the top tail of the distribution, our proxy for doublets: a cell registering an unusually large number of unique genes is more likely to be two cells captured under one barcode than one unusually complex cell
- **`percent.mt < 5`** — removes dying / lysed cells

!!! tip "Setting the doublet threshold in practice"
    The `2500` upper bound on `nFeature_RNA` is this dataset's version of a general strategy: set the ceiling near the top **N%** of the `nFeature_RNA` distribution (inspect the violin plot above) rather than picking a number blind. Dedicated doublet-detection tools (e.g. `scDblFinder`, `DoubletFinder`) formalize this further, but a distribution-informed `nFeature_RNA` ceiling is the standard first pass.

---

???+ question "Exercise 1.3 — Filter the Seurat object"

    Run the **Exercise 3** chunk in `workshop.Rmd`:

    ```r
    pbmc <- subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)
    pbmc
    ```

    **Questions:**

    1. How many cells were removed by this filter?
    2. Which of the three criteria do you think removed the most cells here, and why?

??? success "Solution"

    ```r
    pbmc <- subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)
    pbmc
    # An object of class Seurat
    # 13714 features across 2638 samples within 1 assay
    ```

    2,638 of the original 2,700 cells survive — only **62 cells removed**. Given the median `percent.mt` of ~2% and the tight `nFeature_RNA` distribution seen in the violin plots, most of this dataset was already high quality; the `percent.mt < 5` cutoff catches the small population of cells in the double-digit tail.

---

### Normalizing the data

Just as with bulk RNA-seq, raw UMI counts aren't directly comparable across cells — different cells capture different total numbers of transcripts due to technical variation in droplet capture efficiency, not biology. Seurat's default **`LogNormalize`** method:

1. Divides each gene's count in a cell by that cell's total counts (library-size normalization)
2. Multiplies by a scale factor (`10,000` by default)
3. Log1p-transforms the result

```r
pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 1e4)
```

### Identifying highly variable features

Most genes are either uninformative "housekeeping" genes (similar expression everywhere) or too lowly expressed to be useful. `FindVariableFeatures()` models the mean–variance relationship across all genes and returns the subset that varies the most *beyond* what expression level alone would predict — by default the top 2,000. Downstream steps (scaling, PCA) focus on these features so that biological signal isn't drowned out by uninformative genes.

---

???+ question "Exercise 1.4 — Normalize and find variable features"

    Run the **Exercise 4** chunk in `workshop.Rmd`:

    ```r
    pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 1e4)
    pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)

    top10 <- head(VariableFeatures(pbmc), 10)

    plot1 <- VariableFeaturePlot(pbmc)
    LabelPoints(plot = plot1, points = top10, repel = TRUE)
    ```

    **Questions:**

    1. What are the top 10 most variable genes? Do any look biologically familiar (hint: platelets, granulocytes)?
    2. On the variable feature plot, where do the top genes sit relative to the mean-expression trend line?

??? success "Solution"

    ```r
    top10 <- head(VariableFeatures(pbmc), 10)
    top10
    #  [1] "PPBP"   "LYZ"    "S100A9" "IGLL5"  "GNLY"   "FTL"    "PF4"    "FTH1"
    #  [9] "GNG11"  "S100A8"
    ```

    `PPBP` and `PF4` are platelet markers, `LYZ`/`S100A9`/`S100A8` are myeloid/monocyte markers, and `GNLY` marks NK/cytotoxic cells — this list is already hinting at the distinct cell populations we'll recover with clustering later. Highly variable genes sit **above** the mean-variance trend line: for their average expression level, they show more cell-to-cell variance than expected by chance.

---

### Scaling the data

`ScaleData()` linearly transforms each gene so that, across cells, it has **mean 0** and **variance 1** (a z-score). This is standard practice before PCA: without it, highly-expressed genes would dominate the principal components purely because of their expression magnitude rather than their biological signal.

```r
all.genes <- rownames(pbmc)
pbmc <- ScaleData(pbmc, features = all.genes)
```

---

???+ question "Exercise 1.5 — Scale the data"

    Run the **Exercise 5** chunk in `workshop.Rmd`:

    ```r
    all.genes <- rownames(pbmc)
    pbmc <- ScaleData(pbmc, features = all.genes)
    ```

    **Question:** By default, `ScaleData()` only needs to be run on variable features for PCA to work — why scale `all.genes` here instead?

??? success "Solution"

    Scaling all genes (rather than just the 2,000 variable features) means the resulting `scale.data` slot can also be used later for visualizations like `DoHeatmap()` across any gene of interest — not just the ones used for PCA. It costs more compute but keeps the object flexible for downstream exploration.

    !!! tip "Removing unwanted variation"
        `ScaleData(pbmc, vars.to.regress = "percent.mt")` can regress out a covariate like mitochondrial content directly during scaling — useful when a technical factor is confounding biological signal you care about.

---

## Part 2 — Post-processing

### Perform linear dimensional reduction (PCA)

With scaled data in hand, `RunPCA()` computes principal components using the variable features. Each PC is a linear combination of genes — a "metafeature" summarizing a correlated expression pattern across cells — and the first several PCs typically capture the dominant axes of biological variation (here, differences between immune cell types).

```r
pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc))
```

---

???+ question "Exercise 2.1 — Run and visualize PCA"

    Run the **Exercise 6** chunk in `workshop.Rmd`:

    ```r
    pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc))

    print(pbmc[["pca"]], dims = 1:5, nfeatures = 5)
    VizDimLoadings(pbmc, dims = 1:2, reduction = "pca")
    DimPlot(pbmc, reduction = "pca") + NoLegend()
    ```

    **Question:** Looking at the top genes loading PC1, can you guess which cell populations it's separating?

??? success "Solution"

    PC1's top positive/negative loadings are dominated by myeloid genes (`LYZ`, `CST3`, `S100A8/9`) on one end and lymphocyte genes (`CD3`-family, `IL7R`) on the other — PC1 is primarily separating **myeloid cells (monocytes/DCs) from lymphocytes (T/B/NK cells)**, the single largest axis of variation in PBMCs.

---

### Determining the dimensionality of the dataset

Not every PC captures real signal — later PCs are increasingly dominated by noise. An **elbow plot** ranks PCs by the percentage of variance they explain; the "elbow" — where the curve flattens — is a heuristic for how many PCs carry real signal.

```r
ElbowPlot(pbmc)
```

In this dataset the elbow sits around **PC9–10**, so the workshop uses the first **10 PCs** for everything downstream. (The Seurat authors note that erring on the higher side rarely hurts — the difference between 10, 15, or 20 PCs is usually small — but using only 5 does noticeably degrade results.)

---

### Cluster the cells

Seurat clusters cells using a **graph-based** approach rather than a classic method like k-means:

1. **`FindNeighbors()`** builds a **k-nearest neighbor (KNN) graph** in PCA space — connecting each cell to its most similar neighbors by Euclidean distance on the chosen PCs — then refines edge weights by the *shared* overlap between neighborhoods (Jaccard similarity), producing a shared nearest neighbor (SNN) graph.
2. **`FindClusters()`** partitions that graph into communities using the **Louvain algorithm** (the default modularity-optimization method), which iteratively groups cells to maximize the density of connections within clusters relative to between them.

The `resolution` parameter controls granularity — higher values produce more, smaller clusters. `0.4–1.2` is the typical useful range for a dataset of a few thousand cells.

---

???+ question "Exercise 2.2 — Build the KNN graph and cluster with Louvain"

    Run the **Exercise 7** chunk in `workshop.Rmd`:

    ```r
    pbmc <- FindNeighbors(pbmc, dims = 1:10)
    pbmc <- FindClusters(pbmc, resolution = 0.5)

    head(Idents(pbmc), 5)
    table(Idents(pbmc))
    ```

    **Questions:**

    1. How many clusters does resolution `0.5` produce?
    2. What happens if you try `resolution = 0.1` or `resolution = 1.5`? (Try it and re-run `table(Idents(pbmc))`.)

??? success "Solution"

    ```r
    pbmc <- FindNeighbors(pbmc, dims = 1:10)
    pbmc <- FindClusters(pbmc, resolution = 0.5)
    table(Idents(pbmc))
    #   0   1   2   3   4   5   6   7   8
    # 684 481 476 344 291 162 155  32  13
    ```

    Resolution `0.5` produces **9 clusters**, ranging from 684 cells down to a rare population of just 13. Lowering resolution merges related clusters together (fewer, larger groups); raising it splits them further (more, smaller groups) — there is no single "correct" resolution, only one appropriate to how finely you want to distinguish cell states.

---

### Run non-linear dimensional reduction (UMAP)

PCA and clustering happen in high-dimensional space (10 PCs); **UMAP** compresses that structure into 2D for visualization, aiming to keep cells that are close together in the KNN graph close together on the plot. It's a visualization tool, not a source of biological truth on its own — conclusions should rest on the clustering and marker analysis, not the UMAP layout alone.

```r
pbmc <- RunUMAP(pbmc, dims = 1:10)
```

---

???+ question "Exercise 2.3 — Run UMAP"

    Run the **Exercise 8** chunk in `workshop.Rmd`:

    ```r
    pbmc <- RunUMAP(pbmc, dims = 1:10)
    DimPlot(pbmc, reduction = "umap")
    ```

    **Question:** Do the clusters from `FindClusters()` form visually distinct islands on the UMAP plot, or do some blend together?

??? success "Solution"

    The large lymphocyte clusters (naive/memory CD4+ T, CD8+ T) tend to sit close together with soft boundaries — reflecting real biological similarity between T cell subsets — while monocyte, B, NK, and platelet clusters typically form clearly separated islands. Overlap on the UMAP between two clusters doesn't mean the clustering was wrong; it reflects a continuum of similar transcriptional states.

---

## Bonus — Marker Genes & Cell Type Annotation

Clusters are just numbers until you connect them to biology. `FindAllMarkers()` runs differential expression for every cluster against all other cells and reports the genes that best distinguish each one.

```r
pbmc.markers <- FindAllMarkers(pbmc, only.pos = TRUE)

pbmc.markers %>%
  group_by(cluster) %>%
  dplyr::filter(avg_log2FC > 1) %>%
  slice_head(n = 5) %>%
  ungroup()
```

For PBMCs, a small set of canonical marker genes is enough to assign each cluster a cell type identity:

| Cluster | Markers | Cell Type |
|---|---|---|
| 0 | `IL7R`, `CCR7` | Naive CD4+ T |
| 1 | `CD14`, `LYZ` | CD14+ Mono |
| 2 | `IL7R`, `S100A4` | Memory CD4+ T |
| 3 | `MS4A1` | B |
| 4 | `CD8A` | CD8+ T |
| 5 | `FCGR3A`, `MS4A7` | FCGR3A+ Mono |
| 6 | `GNLY`, `NKG7` | NK |
| 7 | `FCER1A`, `CST3` | DC |
| 8 | `PPBP` | Platelet |

```r
new.cluster.ids <- c("Naive CD4 T", "CD14+ Mono", "Memory CD4 T", "B", "CD8 T",
                      "FCGR3A+ Mono", "NK", "DC", "Platelet")
names(new.cluster.ids) <- levels(pbmc)
pbmc <- RenameIdents(pbmc, new.cluster.ids)

DimPlot(pbmc, reduction = "umap", label = TRUE, pt.size = 0.5) + NoLegend()
```

!!! tip "Rare populations"
    Clusters 7 and 8 are small — 32 and 13 cells respectively — but still resolve cleanly because their marker genes (`FCER1A`/`CST3` for dendritic cells, `PPBP` for platelets) are so strongly and specifically expressed. Rare, transcriptionally distinct populations can be recovered even from a dataset of a few thousand cells.

## Further Reading

- [Seurat — Guided Clustering Tutorial (pbmc3k)](https://satijalab.org/seurat/articles/pbmc3k_tutorial) — the source tutorial this workshop is adapted from
- [Hao et al. 2023, *Nature Biotechnology*](https://doi.org/10.1038/s41587-023-01767-y) — the Seurat v5 paper
- [Stuart\* & Butler\* et al. 2019, *Cell*](https://doi.org/10.1016/j.cell.2019.05.031) — variable feature selection and anchor-based integration methodology
- [Macosko et al. 2015, *Cell*](https://doi.org/10.1016/j.cell.2015.05.002) — Drop-seq and the graph-based clustering approach Seurat builds on
- [10x Genomics — PBMC 3k dataset](https://www.10xgenomics.com/) — original data source

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
