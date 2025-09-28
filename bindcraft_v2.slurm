#!/bin/bash
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --partition=GPU_long
#SBATCH --gpus-per-node=1
#SBATCH --mem 42gb
#SBATCH --time 24:00:00
#SBATCH --signal=B:TERM@300
#SBATCH --output=bindcraft_%A.log

#SBATCH --mail-user=deniz.hulse@fhnw.ch
#SBATCH --mail-type=END,FAIL,TIME_LIMIT

set -euo pipefail

# Always start in the directory you ran `sbatch` from
cd "$SLURM_SUBMIT_DIR"

# Use the Python inside your env (no conda activation needed)
PYTHON="$HOME/.conda/envs/BindCraft/bin/python"
if [ ! -x "$PYTHON" ]; then
  echo "ERROR: $PYTHON not found or not executable"; exit 1
fi

# JAX memory knobs (safe defaults)
export XLA_PYTHON_CLIENT_PREALLOCATE=false
export XLA_PYTHON_CLIENT_MEM_FRACTION=0.7

# ---- Paths ----
PROJECT_DIR="/rg/bioinf-kahraman/software/tmp_BindCraft"
PYTHON="$(which python)"

echo "CWD: $(pwd)"
echo "Python: $PYTHON"
echo "Project: $PROJECT_DIR"

# ---- PEPTIDE SETTINGS ----

# Run with ABSOLUTE paths so /var/lib/slurmd working dir doesn't matter
#"$PYTHON" -u "$PROJECT_DIR/bindcraft.py" \
#  --settings "$PROJECT_DIR/settings_target/PDL1_peptide.json" \
#  --filters  "$PROJECT_DIR/settings_filters/peptide_filters.json" \
#  --advanced "$PROJECT_DIR/settings_advanced/peptide_3stage_multimer_mpnn.json"

# ---- DEFAULT SETTINGS ----

# Run with ABSOLUTE paths so /var/lib/slurmd working dir doesn't matter
"$PYTHON" -u "$PROJECT_DIR/bindcraft.py" \
  --settings "$PROJECT_DIR/settings_target/PDL1.json" \
  --filters  "$PROJECT_DIR/settings_filters/default_filters.json" \
  --advanced "$PROJECT_DIR/settings_advanced/default_4stage_multimer.json"
