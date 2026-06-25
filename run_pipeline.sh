set -e

echo "BARE METAL ML PIPELINE"

export RAY_memory_usage_threshold=0.99
export RAY_memory_monitor_refresh_ms=0

if [ ! -f "local_dataset.csv" ]; then
    echo "Local dataset missing. (Pulling copy)"
    cp notebooks/dataset.csv local_dataset.csv 2>/dev/null || cp datasets/dataset.csv local_dataset.csv
fi

echo "step 1- model training: "
python3 -c "import json; from madewithml.train import train_model; train_model(experiment_name='llm', dataset_loc='local_dataset.csv', train_loop_config='{\"dropout_p\": 0.5, \"lr\": 1e-4, \"lr_factor\": 0.8, \"lr_patience\": 3}', num_workers=1, cpu_per_worker=1, gpu_per_worker=0, num_epochs=3, batch_size=32, results_fp='results/training_results.json')"

echo "step 2- extraction of best Run ID: "
export RAW_RUN_ID=$(python3 -c "from madewithml.predict import get_best_run_id; print(get_best_run_id(experiment_name='llm', metric='val_loss', mode='ASC'))")
export BEST_RUN_ID=$(echo "$RAW_RUN_ID" | tr -d '\r\n[:space:]')
echo "Target Run ID: $BEST_RUN_ID"

echo "step 3- evaluation against holdout dataset: "
if [ ! -f "holdout_dataset.csv" ]; then
    cp notebooks/holdout.csv holdout_dataset.csv 2>/dev/null || cp datasets/holdout.csv holdout_dataset.csv
fi
python3 -c "import os; from madewithml.evaluate import evaluate; evaluate(run_id=os.environ['BEST_RUN_ID'], dataset_loc='holdout_dataset.csv', results_fp='results/evaluation_results.json')"

echo "PIPELINE COMPLETE"
