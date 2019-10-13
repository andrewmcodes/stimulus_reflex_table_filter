import { Controller } from 'stimulus'
import StimulusReflex from 'stimulus_reflex'
import { confetti } from 'dom-confetti'

export default class extends Controller {
  connect () {
    StimulusReflex.register(this)
  }

  afterReflex (anchorElement) {
    confetti(anchorElement)
  }
}
