#!/usr/bin/env bash
# Prepares the Computational Workflows Codespace:
#   1. installs Nextflow
#   2. downloads the workshop FASTQ files into data/fastq/
#   3. pre-downloads the nf-core/rnaseq pipeline code
set -euo pipefail

cd "$(dirname "$0")"

PIPELINE_VERSION="3.27.0"
FASTQ_URL="https://raw.githubusercontent.com/nf-core/test-datasets/rnaseq/testdata/GSE110004"

# 1. Nextflow (version pinned by NXF_VER in devcontainer.json)
if ! command -v nextflow >/dev/null 2>&1; then
    echo "Installing Nextflow..."
    curl -fsSL https://get.nextflow.io | bash
    sudo mv nextflow /usr/local/bin/nextflow
fi
nextflow -version

# 2. FASTQ files: 7 sequencing runs of baker's yeast (GEO: GSE110004), subsampled to be tiny
mkdir -p data/fastq
for run in SRR6357070 SRR6357071 SRR6357072 SRR6357073 SRR6357074 SRR6357075 SRR6357076; do
    for read in 1 2; do
        file="data/fastq/${run}_${read}.fastq.gz"
        [ -s "$file" ] || curl -fsSL -o "$file" "${FASTQ_URL}/${run}_${read}.fastq.gz"
    done
done
echo "FASTQ files ready:"
ls -lh data/fastq

# 3. Pipeline code (containers are pulled on the first run)
nextflow pull nf-core/rnaseq -r "$PIPELINE_VERSION"

echo "Setup complete."
