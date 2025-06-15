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

## 🧹 Inference

Inference can be performed using specific commands to run the model and obtain predictions, as outlined below:

### For WoS Dataset
```bash
layer_index=16
python HdLM/infra/WoS/multicard_infer.py --model_path /YOUR/MODEL/PATH/ --intermediate_layer_index $layer_index
```
After running the above command, you will be able to see the **Macro-F1** and **Micro-F1** score results for the WoS dataset.

### For ESC Dataset

For the ESC dataset, running this command will also yield the **Macro-F1** and **Micro-F1** scores for emotion prediction and strategy selection. Additionally, the generated responses from the inference process will be saved as a separate JSON file for subsequent evaluation using specific assessment methods, and the JSON path is "/HdLM/infra/ESC/result.json"

## 🔍 Evaluate

The Evaluation phase is designed to comprehensively assess the inference results. Here are the detailed methods for evaluation:

### Evaluation on ESC Dataset
Refer to the following command to run the evaluation script:
```bash
bash HdLM/eval/ESC/run.sh
```
This command evaluates the inference results against the correct answers, calculating the following metrics:
- **Dist-2**: Measures the diversity of the generated text; a higher value indicates richer and more varied text.
- **CIDEr**: A metric used to evaluate the similarity between generated text and reference text. It is commonly used in image description generation tasks and can also be employed here to assess the quality of generated responses.

By comparing the results of our method with those of conventional baselines, We demonstrate that our approach achieves performance that not only matches but also exceeds that of conventional baseline methods, showcasing its superiority. Moreover, under comparable performance, our method offers the advantage of significantly reduced computational demands during both training and inference.

## ⚠️ Notes
1. **If encountering syntax error in Linux:**
```bash
vim HdLM/train/wos_train.sh +":set fileformat=unix" +wq
```
2. **Here, WoS and ESC are taken as examples. Other datasets provide cases. The original datasets can be preprocessed according to demo_cases.json**

<!-- ## 📚 References
... -->