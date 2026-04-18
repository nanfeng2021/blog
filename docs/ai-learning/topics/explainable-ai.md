---
layout: page
title: 可解释 AI
description: 让 AI 决策过程透明、可理解的技术与方法
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">AI 安全 · 治理</span>
    <h1>🔍 可解释 AI (Explainable AI, XAI)</h1>
    <p class="description">使 AI 系统的决策过程对人类透明、可理解，建立信任并支持责任追溯的关键技术</p>
  </div>

  <div class="content-body">

## 概述

**可解释 AI**（XAI）致力于让人类理解 AI 模型的决策依据，对于高风险应用（医疗、金融、司法）至关重要。

## 解释方法

### 1. LIME（局部可解释模型无关解释）

```python
from lime import lime_image
import numpy as np

def explain_prediction(model, image, class_idx):
    """生成图像分类的解释"""
    explainer = lime_image.LimeImageExplainer()
    
    # 生成解释
    explanation = explainer.explain_instance(
        image[0],
        model.predict,
        top_labels=5,
        hide_color=0,
        num_samples=1000
    )
    
    # 获取重要区域
    temp, mask = explanation.get_image_and_mask(
        class_idx,
        positive_only=True,
        num_features=5,
        hide_rest=False
    )
    
    return mask  # 高亮重要区域

# 可视化
explained_mask = explain_prediction(model, test_image, predicted_class)
show_highlighted_image(test_image, explained_mask)
```

### 2. SHAP（SHapley Additive exPlanations）

```python
import shap

# 训练解释器
explainer = shap.DeepExplainer(model, background_data)

# 计算 SHAP 值
shap_values = explainer.shap_values(test_samples)

# 可视化
shap.summary_plot(shap_values, test_samples)
shap.dependence_plot("feature_1", shap_values, test_samples)

# 单个样本解释
shap.force_plot(
    explainer.expected_value,
    shap_values[0],
    test_samples[0]
)
```

### 3. 注意力可视化

```python
import matplotlib.pyplot as plt

def visualize_attention(model, input_ids, attention_mask):
    """可视化 Transformer 注意力权重"""
    outputs = model(input_ids, attention_mask=attention_mask, 
                   output_attentions=True)
    
    attentions = outputs.attentions  # [n_layers, batch, n_heads, seq, seq]
    
    # 平均多头注意力
    avg_attention = attentions[-1].mean(dim=1).squeeze().cpu().numpy()
    
    # 热力图
    plt.figure(figsize=(10, 8))
    plt.imshow(avg_attention, cmap='viridis')
    plt.colorbar(label='Attention Weight')
    plt.title('Last Layer Attention Map')
    plt.show()
    
    return avg_attention
```

### 4. 特征重要性

```python
def permutation_importance(model, X, y, n_repeats=10):
    """排列重要性分析"""
    baseline_score = model.score(X, y)
    importances = []
    
    for feature_idx in range(X.shape[1]):
        scores = []
        
        for _ in range(n_repeats):
            X_permuted = X.copy()
            np.random.shuffle(X_permuted[:, feature_idx])
            
            permuted_score = model.score(X_permuted, y)
            scores.append(baseline_score - permuted_score)
        
        importances.append(np.mean(scores))
    
    # 排序
    sorted_idx = np.argsort(importances)[::-1]
    
    return {
        'features': feature_names[sorted_idx],
        'importances': np.array(importances)[sorted_idx]
    }
```

## LLM 解释技术

### 1. 归因分析

```python
from captum.attr import IntegratedGradients

def attribute_prediction(model, input_text, target_token):
    """计算输入 token 对输出的贡献"""
    ig = IntegratedGradients(model)
    
    input_ids = tokenizer.encode(input_text, return_tensors='pt')
    target_idx = tokenizer.encode(target_token)[0]
    
    # 计算归因
    attributions, delta = ig.attribute(
        input_ids,
        target=target_idx,
        return_convergence_delta=True
    )
    
    # 可视化
    tokens = tokenizer.convert_ids_to_tokens(input_ids[0])
    show_attributions(tokens, attributions[0])
    
    return attributions
```

### 2. 反事实解释

```python
def generate_counterfactual(model, original_input, desired_output):
    """生成最小修改以达到期望输出"""
    
    current_output = model.generate(original_input)
    
    if current_output == desired_output:
        return "Already matches"
    
    # 迭代修改输入
    modified_input = original_input
    for step in range(max_steps):
        # 找到最敏感的 token
        sensitivity = compute_sensitivity(model, modified_input)
        most_sensitive_idx = sensitivity.argmax()
        
        # 替换 token
        modified_input[most_sensitive_idx] = alternative_token
        
        # 检查是否达到目标
        new_output = model.generate(modified_input)
        if new_output == desired_output:
            return {
                'original': original_input,
                'modified': modified_input,
                'changed_token': most_sensitive_idx
            }
    
    return "No counterfactual found"
```

### 3. 自然语言解释

```python
def generate_natural_explanation(model, input_context, prediction):
    """用自然语言解释决策"""
    
    prompt = f"""
请解释为什么模型做出了这个预测：

输入：{input_context}
预测：{prediction}

解释应该包括：
1. 关键证据
2. 推理过程
3. 置信度原因
"""
    
    explanation = explainer_llm.generate(prompt)
    return explanation
```

## 评估指标

### 保真度（Fidelity）

```python
def fidelity_score(model, explainer, test_data):
    """解释与模型行为的一致性"""
    fidelities = []
    
    for x, y in test_data:
        original_pred = model(x)
        
        # 基于解释的简化模型预测
        simplified_pred = explainer.simplified_predict(x)
        
        # 一致性
        fidelity = similarity(original_pred, simplified_pred)
        fidelities.append(fidelity)
    
    return np.mean(fidelities)
```

### 稳定性（Stability）

```python
def stability_score(explainer, test_data, n_perturbations=10):
    """解释对输入扰动的鲁棒性"""
    stabilities = []
    
    for x in test_data:
        explanations = []
        
        for _ in range(n_perturbations):
            x_perturbed = x + small_noise()
            exp = explainer.explain(x_perturbed)
            explanations.append(exp)
        
        # 解释间的一致性
        stability = variance(explanations)
        stabilities.append(stability)
    
    return np.mean(stabilities)
```

## 应用场景

### 1. 医疗诊断

```python
# 解释为什么诊断为某种疾病
diagnosis = model.predict(patient_data)
explanation = shap_explainer.explain(patient_data)

print(f"诊断：{diagnosis}")
print(f"关键因素:")
for feature, importance in explanation.top_features():
    print(f"  - {feature}: {importance:.3f}")

# 医生可以验证合理性
```

### 2. 信贷审批

```python
# 解释贷款拒绝原因
decision = loan_model(applicant_data)
explanation = lime_explainer.explain(applicant_data)

if decision == "rejected":
    print("拒绝原因:")
    for reason in explanation.negative_factors[:3]:
        print(f"  - {reason}")
    
    # 提供改进建议
    print("\n改进建议:")
    print("  - 提高信用分数")
    print("  - 降低负债率")
```

### 3. 司法辅助

```python
# 解释量刑建议
sentence_recommendation = justice_model(case_details)
explanation = generate_legal_explanation(case_details, sentence_recommendation)

print(f"建议刑期：{sentence_recommendation}")
print(f"法律依据:")
for law in explanation.cited_laws:
    print(f"  - {law}")
print(f"关键情节:")
for factor in explanation.key_factors:
    print(f"  - {factor}")
```

## 最佳实践

### 多层次解释

```python
def multi_level_explanation(model, input_data, prediction):
    """提供不同层次的解释"""
    
    return {
        'summary': brief_summary(prediction),
        'key_factors': top_features(model, input_data),
        'detailed_analysis': full_shap_analysis(model, input_data),
        'counterfactuals': what_if_scenarios(model, input_data),
        'confidence': prediction_confidence(model, input_data)
    }
```

### 用户适配

```python
def user_adapted_explanation(user_type, explanation_data):
    """根据用户类型调整解释"""
    
    if user_type == "expert":
        return technical_explanation(explanation_data)
    elif user_type == "practitioner":
        return practical_explanation(explanation_data)
    else:  # layman
        return simple_explanation(explanation_data)
```

## 学习资源

- [Interpretability ML Course](https://interpretability.ml/)
- [SHAP 文档](https://shap.readthedocs.io/)
- [LIME 论文](https://arxiv.org/abs/1602.04938)

## 相关概念

- [[对抗攻击]](/ai-learning/topics/adversarial-attacks) - 安全挑战
- [[AI 治理]](/ai-learning/topics/ai-governance) - 监管框架
- [[价值对齐]](/ai-learning/topics/value-alignment) - 伦理基础

## 下一步学习

1. **[AI 治理](/ai-learning/topics/ai-governance)** - 政策框架
2. **[AI 安全综合](/ai-learning/resources/ai-safety-guide)** - 完整指南
3. **[负责任的 AI](/ai-learning/resources/responsible-ai)** - 最佳实践

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/adversarial-attacks" class="nav-link">← 对抗攻击</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/ai-governance" class="nav-link">AI 治理 →</a>
    </div>
  </div>
</div>

<style scoped>
.learning-content { max-width: 900px; margin: 0 auto; padding: 2rem; }
.content-header { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 2px solid #e5e7eb; }
.category-badge { display: inline-block; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.85rem; margin-bottom: 1rem; text-transform: uppercase; }
.content-header h1 { font-size: 2.5rem; margin-bottom: 0.75rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.description { font-size: 1.1rem; color: #666; line-height: 1.6; }
.content-body { line-height: 1.8; color: #374151; }
.content-body h2 { color: #667eea; margin-top: 2rem; margin-bottom: 1rem; font-size: 1.5rem; }
.content-body h3 { color: #764ba2; margin-top: 1.5rem; margin-bottom: 0.75rem; font-size: 1.2rem; }
.content-body ul, .content-body ol { margin: 1rem 0; padding-left: 1.5rem; }
.content-body li { margin: 0.5rem 0; line-height: 1.6; }
.content-body a { color: #667eea; text-decoration: none; transition: color 0.2s; font-weight: 500; }
.content-body a:hover { color: #764ba2; text-decoration: underline; }
.content-body strong { color: #1f2937; font-weight: 600; }
.content-body pre { background: #1f2937; color: #f3f4f6; padding: 1.5rem; border-radius: 8px; overflow-x: auto; margin: 1.5rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.9em; line-height: 1.6; }
.content-body code { font-family: 'JetBrains Mono', monospace; }
.content-body blockquote { border-left: 4px solid #f093fb; padding-left: 1rem; margin: 1.5rem 0; color: #4b5563; font-style: italic; background: #f9fafb; padding: 1rem; border-radius: 0 8px 8px 0; }
.content-navigation { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; }
.nav-card { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s ease; }
.nav-card:hover { border-color: #f093fb; box-shadow: 0 4px 12px rgba(240, 147, 251, 0.2); transform: translateY(-2px); }
.nav-label { display: block; font-size: 0.85rem; color: #6b7280; margin-bottom: 0.5rem; }
.nav-link { display: block; font-size: 1.1rem; font-weight: 600; color: #667eea; text-decoration: none; transition: color 0.2s; }
.nav-link:hover { color: #764ba2; }
@media (max-width: 768px) { .learning-content { padding: 1rem; } .content-header h1 { font-size: 1.8rem; } .content-navigation { grid-template-columns: 1fr; } }
</style>
