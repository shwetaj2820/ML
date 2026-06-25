**This project is based on the Made With ML repository(https://github.com/GokuMohandas/Made-With-ML). I refactored the project to support fully local training, evaluation, serving, and CI execution without cloud infrastructure.**

## Local Pipeline
```
bash run_pipeline.sh
```
The pipeline performs the following steps: 
1. Verify whether the required datasets are available.
2. Train the model locally.
3. Select the best MLflow run.
4. Evaluate the trained model on the holdout dataset.
5. Generate training and evaluation metrics.
6. Save artifacts inside the local project directory.

## Generated Outputs
After execution the following files are created: 
```
results/
├── training_results.json
├── evaluation_results.json
├── tuning_results.json
└── test_data_results.txt
```
## CI/CD Support
Github Actions has been updated to executed the same local workflow used during development. The workflow automatically:

- Runs the local pipeline
- converts metrics into Markdown reports
- publishes results in pull requests
- validates that the local execution succeeds
