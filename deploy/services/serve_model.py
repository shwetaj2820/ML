import os
import shutil
import sys

sys.path.append(".")

from madewithml.config import MODEL_REGISTRY  # NOQA: E402
from madewithml.serve import ModelDeployment  # NOQA: E402

os.makedirs(str(MODEL_REGISTRY), exist_ok=True)

local_mlflow_source = "mlflow_runs"

if os.path.exists(local_mlflow_source):
    shutil.copytree(local_mlflow_source, str(MODEL_REGISTRY), dirs_exist_ok=True)
else:
    print(f"Warning: Local source folder '{local_mlflow_source}' not found.")

run_id = [line.strip() for line in open("run_id.txt")][0]
entrypoint = ModelDeployment.bind(run_id=run_id, threshold=0.9)
