#!/bin/bash
if [ -n "$MLP_WORKER_NUM" ]; then
  NNODES="$MLP_WORKER_NUM"
  GPUS_PER_NODE=8
else
  NNODES=1
  GPUS_PER_NODE=1
fi

if [ -n "$MLP_ROLE_INDEX" ]; then
  NODE_RANK="$MLP_ROLE_INDEX"
else
  NODE_RANK=0
fi

if [ -n "$MLP_WORKER_0_HOST" ]; then
  MASTER_ADDR="$MLP_WORKER_0_HOST"
  MASTER_PORT="$MLP_WORKER_0_PORT"
else
  MASTER_ADDR=localhost
  MASTER_PORT=12345
fi

export HF_DATASETS_OFFLINE=1
export TRANSFORMERS_OFFLINE=1
cd utils/LLaMA-Factory

torchrun \
    --nproc_per_node $GPUS_PER_NODE \
    --nnodes $NNODES \
    --node_rank $NODE_RANK \
    --master_addr $MASTER_ADDR \
    --master_port $MASTER_PORT \
    src/train.py \
    --train_intermediate_layer \
    --has_subtask false \
    --intermediate_layer_index 16 \
    --intermediate_loss_weight 1 \
    --final_loss_weight 5 \
    --model_name_or_path "MODEL_PATH" \
    --template gsm8k \
    --stage sft \
    --do_train true \
    --finetuning_type full \
    --pref_beta 0.1 \
    --pref_loss sigmoid \
    --deepspeed examples/deepspeed/ds_z3_config.json \
    --dataset GSM8K-Depth2 \
    --cutoff_len 2048 \
    --max_samples 10000000000 \
     --overwrite_cache true \
    --preprocessing_num_workers 64 \
    --output_dir "OUTPUT_MODEL_PATH" \
    --logging_steps 100 \
    --save_strategy epoch \
    --plot_loss true \
    --overwrite_output_dir true \
    --per_device_train_batch_size 1 \
    --gradient_accumulation_steps 1 \
    --learning_rate 5.0e-4 \
    --num_train_epochs 2.0 \
    --lr_scheduler_type linear \
    --warmup_ratio 0.1 \
    --bf16 true \
    --ddp_timeout 360000000 \
    --flash_attn fa2 \
    --weight_decay 0.01 