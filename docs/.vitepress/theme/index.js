import DefaultTheme from 'vitepress/theme'
import Layout from './Layout.vue'
import AILearningRoadmap from './components/AILearningRoadmap.vue'
import SubscribeCards from './components/SubscribeCards.vue'
import ThemeToggle from './components/ThemeToggle.vue'
import ReadingProgress from './components/ReadingProgress.vue'
import TableOfContents from './components/TableOfContents.vue'
import GiscusComments from './components/GiscusComments.vue'
import './custom.css'

export default {
  ...DefaultTheme,
  Layout,
  enhanceApp({ app }) {
    app.component('AILearningRoadmap', AILearningRoadmap)
    app.component('SubscribeCards', SubscribeCards)
    app.component('ThemeToggle', ThemeToggle)
    app.component('ReadingProgress', ReadingProgress)
    app.component('TableOfContents', TableOfContents)
    app.component('GiscusComments', GiscusComments)
  }
}
