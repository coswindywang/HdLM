# HdLM: Making Language Model a Hierarchical Classifier and Generator
 
This repository provides tools for hierarchical text classification using HdLM method based Llama3-8B, demonstrated with the Web of Science (WoS) dataset. The implementation supports easy adaptation to other datasets like ESC and DBPedia.

## 📂 Dataset Preparation (WoS Example)

### 1. Obtain the Dataset
The Web of Science (WoS) dataset contains 46,985 documents across 134 hierarchical categories. For details, see [WoS Dataset | Papers With Code](https://paperswithcode.com/dataset/web-of-science).

### 2. Preprocessing Steps
```bash
# Navigate to WoS data directory
cd HdLM/data/Depth2/WoS

# Create required directories
mkdir -p alpaca_datasets splited_jsondata

# Process data
python data_processor.py
python generate_dataset.py
```
Processed datasets will be available in:

```
HdLM/data/Depth2/WoS/alpaca_datasets/
├── wos_train_data.json
├── wos_test_data.json
└── wos_valid_data.json  # Optional validation set
```

## 🚀 Training Configuration
### 1. Register Dataset
Update dataset registry in HdLM/utils/LLaMA-Factory/data/dataset_info.json:
```json
{
  "WoS-HTC":{
        "file_name": "/your/wos_dataset/path/",
        "formatting": "alpaca",
        "add_thought": true,
        "has_subtask": true,
        "columns":{
            "prompt": "system",
            "query": "input",
            "thought": "think",
            "subtask": "subtask",
            "response": "assistant"
        }
    }
}
```

### 2. Configure Training Script
Edit HdLM/train/wos_train.sh, replace the model addresses in the script, including the base model and the fine-tuned output model.

### 3. Start Training
```bash
bash HdLM/train/wos_train.sh
```

## ⚠️ Notes
1. **If encountering syntax error in Linux:**
```bash
vim HdLM/train/wos_train.sh +":set fileformat=unix" +wq
```
2. **Here, WoS is taken as an example. Other datasets provide cases. The original datasets can be preprocessed according to demo_cases.json**

<!-- ## 📚 References
... -->