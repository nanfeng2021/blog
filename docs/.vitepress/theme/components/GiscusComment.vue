<template>
  <div class="giscus-comment">
    <component 
      :is="'script'"
      src="https://giscus.app/client.js"
      data-repo="nanfeng2021/ai-learning-journey"
      data-repo-id="R_kgDORxSaKw"  
      data-category="General"
      data-category-id="DIC_kwDORxSaK84C53CU"
      data-mapping="pathname"
      data-strict="0"
      data-reactions-enabled="1"
      data-emit-metadata="0"
      data-input-position="bottom"
      data-theme="preferred_color_scheme"
      data-lang="zh-CN"
      crossorigin="anonymous"
      async
    />
  </div>
</template>

<script setup>
// Giscus 评论组件
// 仓库：nanfeng2021/ai-learning-journey
// 分类：General
</script>

<style scoped>
.giscus-comment {
  margin-top: 3rem;
  padding-top: 2rem;
  border-top: 1px solid var(--vp-c-divider);
}

/* 暗黑模式适配 */
html.dark .giscus-comment {
  border-top-color: var(--vp-c-divider-dark);
}
</style>
