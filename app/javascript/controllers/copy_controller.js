import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti"

export default class extends Controller {
  static targets = [ "source", "message" ]

  copy(event) {
    event.preventDefault()

    const text = this.sourceTarget.textContent
    navigator.clipboard.writeText(text).then(() => {
      this.messageTarget.textContent = "Texto copiado!"
      this.messageTarget.classList.remove('hidden')
      setTimeout(() => this.messageTarget.classList.add('hidden'), 2000)

      confetti({
        particleCount: 100,
        spread: 70,
        origin: { y: 0.6 }
      })
    }, () => {
      this.messageTarget.textContent = "Error al copiar el texto."
      this.messageTarget.classList.remove('hidden')
      setTimeout(() => this.messageTarget.classList.add('hidden'), 2000)
    })
  }
}