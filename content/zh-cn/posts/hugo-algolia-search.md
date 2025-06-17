+++
title = "以Hugo 的 LoveIt 模板为例搭建github个人博客"
date = "2025-06-15"
draft = false
tags = ["github", "blog", "algolia", "search"]
categories = ["技巧"]
og_title = "hugo-algolia-search"
+++

## 文章简介
本文将手把手带你在 GitHub 上搭建高效、现代化的个人博客，内容涵盖：

- 博客框架选型：基于 [Hugo](https://gohugo.io/) 静态网站生成器，配合美观强大的 [LoveIt](https://hugoloveit.com/) 主题。
- 自动化部署：利用 GitHub Actions 实现双库模式下的持续集成与自动发布，无需手动操作，提交代码后即可自动上线。
- 搜索功能集成：接入 [Algolia](https://www.algolia.com/) 实现全站内容搜索，并通过自动化脚本/流程实时同步索引，提升内容检索体验。
- 基于Giscus实现博客的留言功能。

虽然本教程的流程看起来较长，但实际上非常简单。只需跟着操作一遍，你无需购买服务器，就能拥有一个以 github.io 域名为后缀的个人博客。博客会根据你设置的标签和分类自动归档，支持全站搜索和评论等强大功能，而且这些全部都是免费的！只需投入一点时间，你就能在全球访问量最高的网站之一 GitHub 上拥有属于自己的博客。快来试试吧！

本文不仅想告诉各位看官看其然，也试图想让各位看官知其所以然。这样有助于大家在脱离我使用的这套工具以外，探索其它工具的使用，利用GitHub搭建出属于自己博客。

##  GitHub 博客搭建流程示意图
{{< mermaid >}}
flowchart TD
    A[Install Hugo] --> B[Create GitHub source repo]
    B --> C[Create GitHub deploy repo]
    C --> D[Initialize blog with Hugo]
    D --> E[Configure submodules: themes/loveit, public]
    E --> F[Create a test post]
    F --> G[Create GitHub Personal Token]
    G --> H[Configure GitHub Actions for auto-deploy]
    H --> I[Configure multilingual support]
    I --> J[Integrate Algolia search]
    J --> K[Update Action to push Algolia index]
    K --> L[Configure Giscus comment system]
{{< /mermaid >}}

> 以上流程图可视化了从本地环境准备到自动化部署和评论系统集成的完整步骤。

## 操作流程

### 创建两个GitHub仓库
