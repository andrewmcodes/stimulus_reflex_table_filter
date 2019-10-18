import { Controller } from 'stimulus'
import StimulusReflex from 'stimulus_reflex'
import { confetti } from 'dom-confetti'

export default class extends Controller {
  connect () {
    console.log("connected")
    StimulusReflex.register(this)
  }

  beforeReflex () {
    console.log('before reflex')
  }

  afterReflex (anchorElement) {
    console.log("after reflex")
    confetti(anchorElement)
  }
}
