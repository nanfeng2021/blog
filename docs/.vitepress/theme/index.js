import DefaultTheme from 'vitepress/theme'
import Layout from './Layout.vue'
import AILearningRoadmap from './components/AILearningRoadmap.vue'
import SubscribeCards from './components/SubscribeCards.vue'
import './custom.css'

export default {
  ...DefaultTheme,
  Layout,
  enhanceApp({ app }) {
    app.component('AILearningRoadmap', AILearningRoadmap)
    app.component('SubscribeCards', SubscribeCards)
  }
}
